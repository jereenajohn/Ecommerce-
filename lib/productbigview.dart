import 'dart:convert';
import 'dart:ui';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product_big_View extends StatefulWidget {
  Product_big_View({required this.product_id, required this.Category_id});

  final product_id;
  final Category_id;

  @override
  State<Product_big_View> createState() => _Product_big_ViewState();
}

class _Product_big_ViewState extends State<Product_big_View> {
  final producturl =
      "https://3f25-59-92-198-21.ngrok-free.app/category/";

  final multipleimageurl = "https://3f25-59-92-198-21.ngrok-free.app/product/";

  final String addtocarturl = "https://3f25-59-92-198-21.ngrok-free.app/Cart/";

  final String wishlisturl =
      "https://3f25-59-92-198-21.ngrok-free.app/add-wishlist/";

  List<Map<String, dynamic>> Products = [];
  List<Map<String, dynamic>> categoryProducts = [];
  List<Map<String, dynamic>> images = [];
  List<Map<String, dynamic>> products = [];
  List<bool> isFavorite = [];
  int _selectedIndex = 0;

  var name;
  var image;
  var price;
  var shortdescription;
  var description;
  var salePrice;
  var offer_type;

  bool isDataLoaded = false;

  @override
  void initState() {
    print("product_iddddddddddddddd${widget.product_id}");
    print("category_idddddddddddddd${widget.Category_id}");
    fetchproductdata();
    multipleimage();
    super.initState();
  }

   Future<void> addProductToWishlist(int productId) async {
    print(
        "PPPPPPPPPPPPPRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOO$productId");

    try {
      final token = await gettokenFromPrefs();
      print("TTTTTTTOOOOOOOOOOKKKKKKKKKKKKKKKEEEEEEEEENNNNNNNNN$token");

      final response = await http.post(
        Uri.parse('${wishlisturl}${productId}/'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
        }),
      );

      if (response.statusCode == 201) {
        print('Product added to wishlist: $productId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to wishlist'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 400) {
        // Product already in wishlist, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already in wishlist'),
          ),
        );
      } else {
        print('Failed to add product to wishlist: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error adding product to wishlist: $error');
    }
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    // Check if the product is being added or removed from the wishlist
    if (isFavorite[index]) {
      // If the product is being added to the wishlist
      addProductToWishlist(
        products[index]['id'],
      );
    } else {
      // If the product is being removed from the wishlist
      // You can implement this logic if needed
    }
  }

  Icon buildFavoriteIcon(int index) {
    return Icon(
      isFavorite[index] ? Icons.favorite : Icons.favorite_border,
      color: isFavorite[index] ? Colors.red : Colors.black,
    );
  }

  Future<void> addProductToCart(int productId, var name, var price) async {
    try {
      final token = await gettokenFromPrefs();

      final response = await http.post(
        Uri.parse(addtocarturl),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
          'name': name,
          'price': price
        }),
      );

      if (response.statusCode == 200) {
        // Product successfully added to cart, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to cart successfully'),
          ),
        );
        print('Product added to cart: $productId');
      } else if (response.statusCode == 400) {
        // Product already in cart, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already in Cart'),
          ),
        );
      } else {
        print('Failed to add product to cart: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' product added to cart successfully'),
          ),
        );
      }
    } catch (error) {
      print('Error adding product to cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding product to cart'),
        ),
      );
    }
  }

  void updateDisplayedImage(String? color) {
    for (var image in images) {
      if (image['color'] == color) {
        setState(() {
          this.image = image['image1'];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop By Category',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wishlist()));
            },
            icon: Image.asset(
              "lib/assets/heart.png",
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 236, 234, 234),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      child: image != null
                          ? Image.network(
                              (image), // Decode base64 image
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    if (offer_type !=
                        null && offer_type !="normal") // Check if discount percentage is available
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '$offer_type',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          addProductToWishlist(widget.product_id);
                          // Add functionality to handle favorite action
                        },
                      ),
                    ),
                  ],
                ),
              ),

              if (images.isNotEmpty)
                Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = images[index]['image1'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 151, 151, 151),
                                    width: 1), // Border definition
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                images[index]['image1'],
                                width: 85,
                                height: 85,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = images[index]['image2'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 151, 151, 151),
                                    width: 1), // Border definition
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                images[index]['image2'],
                                fit: BoxFit.cover,
                                width: 85,
                                height: 85,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = images[index]['image3'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 151, 151, 151),
                                    width: 1), // Border definition
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                images[index]['image3'],
                                fit: BoxFit.cover,
                                width: 85,
                                height: 85,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = images[index]['image4'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 151, 151, 151),
                                    width: 1), // Border definition
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                images[index]['image4'],
                                fit: BoxFit.cover,
                                width: 85,
                                height: 85,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = images[index]['image5'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 151, 151, 151),
                                    width: 1), // Border definition
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                images[index]['image5'],
                                fit: BoxFit.cover,
                                width: 85,
                                height: 85,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$name",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 87, 87, 87)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            "\₹$salePrice",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                         
                          if(price!=null)
                          Text(
                            "\₹$price",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 155, 153, 153),
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addProductToCart(widget.product_id, name, price);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("ADD TO CART"),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 5,
              ),

              if (colors.isNotEmpty)
                Container(
                  height: 70,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: colors.map((color) {
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: selectedColor == color
                                    ? Color.fromARGB(255, 1, 80, 12)
                                    : Colors.black,
                                side: BorderSide(
                                  color: selectedColor == color
                                      ? Color.fromARGB(255, 28, 146, 1)
                                      : Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Adjust the radius as needed
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedColor = color;

                                  updateDisplayedImage(selectedColor);
                                });
                              },
                              child: Text(color.toUpperCase()),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 5),

              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Product Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "* ${description}",
                              maxLines:
                                  null, // Set maxLines to null for unlimited lines
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "* ${shortdescription}",
                              maxLines:
                                  null, // Set maxLines to null for unlimited lines
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              // Add spacing between product view and horizontal list
              if (isDataLoaded)
                Container(
                  color: Colors.white,
                  height: 290, // Adjust height as needed
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Similar Products",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProducts.length,
                          itemBuilder: (context, index) {
                            var product = categoryProducts[index];
                            if (product['id'] == widget.product_id) {
                              return SizedBox
                                  .shrink(); // Skip rendering this item
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Product_big_View(
                                            product_id: categoryProducts[index]
                                                ['id'],
                                            Category_id: categoryProducts[index]
                                                ['mainCategory'])));

                                // Handle tap on product
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 173, 173, 173)),
                                ),
                                margin: EdgeInsets.all(10),
                                width: 150, // Adjust width as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          150, // Adjust image height as needed
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        product['name'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                   
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                           if(product['price']!=null)
                                          Text(
                                            '\$${product['price']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors
                                                  .grey, // Set line color to grey
                                            ),
                                          ),
                                          Text(
                                            'Sale Price: \$${product['salePrice']}',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 244, 244, 244),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: GNav(
            gap: 20,
            onTabChange: (index) {
              setState(() {
                // _index = index;
                // if (index == 2) {
                //   _showSearchDialog(context);
                // }
              });
            },
            padding: EdgeInsets.all(16),
            // selectedIndex: _index,
            tabs: [
              GButton(
                icon: Icons.home,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                  // Navigate to Home page
                },
              ),
              GButton(
                icon: Icons.shopping_bag,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                  // Navigate to Cart page
                },
              ),
              GButton(
                icon: Icons.search,
                onPressed: () {
                  //  Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => search()));
                  // Show search dialog if tapped
                },
              ),
              GButton(
                icon: Icons.person,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage()));
                  // Navigate to Profile page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchproductdata() async {
    try {
      final response =
          await http.get(Uri.parse('$producturl${widget.Category_id}/products/'));

      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        List<Map<String, dynamic>> productsList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://3f25-59-92-198-21.ngrok-free.app${productData['image']}";
          productsList.add({
            'id': productData['id'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'shortDescription': productData['short_description'],
            'description': productData['description'],
            'mainCategory': productData['mainCategory'],
            'offer_type': productData['offer_type'],
            'image': imageUrl,

            
          });
        }

        setState(() {
          for (int i = 0; i < productsList.length; i++) {
            if (widget.product_id == productsList[i]['id']) {
              print(
                  "AAAAAAAAAMMMMMMMMMMMMMMMMMMMAAAAAAAAAAAAAAAAAAAAAAAAAAA${productsList[i]}");
                  
              image = productsList[i]['image'];
              name = productsList[i]['name'];
              price = productsList[i]['price'];
              salePrice = productsList[i]['salePrice'];
              shortdescription = productsList[i]['shortDescription'];
              description = productsList[i]['description'];
              offer_type = productsList[i]['offer_type'];
            }
          }
          print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR$price");

          print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS$salePrice");
          print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT$shortdescription");
          categoryProducts = productsList;
          isDataLoaded = true;
        });
        print("==========================LLLLLLLLLLLLLLLLLLLLLLLLLL$categoryProducts");
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (error) {
      print('Error fetching category products: $error');
    }
  }

  Map<String, dynamic> product = {};
  String? selectedColor;
  List<String> colors = [];

  Future<void> multipleimage() async {
    Set<String> colorsSet = {};
    try {
      final response =
          await http.get(Uri.parse('$multipleimageurl${widget.product_id}'));

      if (response.statusCode == 200) {
        final List<dynamic> imageData =
            jsonDecode(response.body)['productImage'];

        product = jsonDecode(response.body)['product'];

        List<Map<String, dynamic>> productsList = [];

        for (var imageData in imageData) {
          String imageUrl1 =
              "https://3f25-59-92-198-21.ngrok-free.app${imageData['image1']}";
          String imageUrl2 =
              "https://3f25-59-92-198-21.ngrok-free.app${imageData['image2']}";
          String imageUrl3 =
              "https://3f25-59-92-198-21.ngrok-free.app${imageData['image3']}";
          String imageUrl4 =
              "https://3f25-59-92-198-21.ngrok-free.app${imageData['image4']}";
          String imageUrl5 =
              "https://3f25-59-92-198-21.ngrok-free.app${imageData['image5']}";
          productsList.add({
            'id': imageData['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': imageData['color'],
          });
          colorsSet.add(imageData['color']);
        }

        setState(() {
          images = productsList;
          colors = colorsSet.toList();
          selectedColor = colors.isNotEmpty ? colors[0] : null;
        });
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (error) {
      print('Error fetching category products: $error');
    }
  }
}
