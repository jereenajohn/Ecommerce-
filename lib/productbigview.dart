import 'dart:convert';
import 'dart:ui';

import 'package:bepocart/cart.dart';
import 'package:bepocart/discountproducts.dart';
import 'package:bepocart/fullscreenimage.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/recommendedproducts.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/category/";

  final multipleimageurl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/product-images/";

  final String addtocarturl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/cart/";
  final String wishlisturl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/add-wishlist/";

  final String discountsurl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/discount-sale/";

  var recentlyviewedurl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/recently-viewed/";

  final String recommendedproductsurl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com/recommended/";
  List<Map<String, dynamic>> Products = [];
  List<Map<String, dynamic>> categoryProducts = [];
  List<Map<String, dynamic>> images = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> discountproducts = [];
  List<Map<String, dynamic>> recenlyviewd = [];
  List<Map<String, dynamic>> recommendedproducts = [];

  List<bool> isFavorite = [];
  int _selectedIndex = 0;

  List<String> sizeNames = [];
  String? selectedSize;

  var name;
  var image;
  var price;
  var shortdescription;
  var description;
  var salePrice;
  var offer_type;

  bool isDataLoaded = false;
  var tokenn;

  @override
  void initState() {
    print("product_iddddddddddddddd${widget.product_id}");
    print("category_idddddddddddddd${widget.Category_id}");
    _initData();
    fetchproductdata();
    multipleimage();
    fetchDiscountProducts();
    recentlyviewed();
    fetchRecommendedProducts();
    super.initState();
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    print("--------------------------------------------R$tokenn");
    // Use userId after getting the value
  }

  Future<void> fetchRecommendedProducts() async {
    try {
      final token =
          await gettokenFromPrefs(); // Make sure this method returns your token correctly

      print("Token: $token");

      final response = await http.get(
        Uri.parse(recommendedproductsurl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      print("Response Body: ${response.body}");
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['data'];

        print("Products Data: $productsData");

        List<Map<String, dynamic>> productRecommendedList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${productData['image']}";
          productRecommendedList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          recommendedproducts = productRecommendedList;
          print("Recommended Products: $recommendedproducts");
        });
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {
      print('Error fetching recommended products: $error');
    }
  }

  Future<void> recentlyviewed() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.get(
        Uri.parse('$recentlyviewedurl'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      print(
          "viewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww ${response.body}");

      if (response.statusCode == 200) {
        final recent = jsonDecode(response.body);

        final List<dynamic> recentproductsData = recent['data'];
        List<Map<String, dynamic>> Recentlylist = [];

        print(
            "RRRRRRRRRRREEEEEEEEECCCCCCCCCCCCEEEEEEEEENNNNNNNTTTTTTTTTTTT$recentproductsData");

        for (var recentproductsData in recentproductsData) {
          String imageUrl =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${recentproductsData['image']}";
          Recentlylist.add({
            'id': recentproductsData['id'],
            'mainCategory': recentproductsData['mainCategory'],
            'name': recentproductsData['name'],
            'salePrice': recentproductsData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          recenlyviewd = Recentlylist;

          print(
              "RRRRRRRRRRRRRRRRRRTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT$recenlyviewd");
        });

        print('Profile data fetched successfully');
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  Future<void> fetchDiscountProducts() async {
    try {
      final response = await http.get(Uri.parse(discountsurl));
      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed;

        List<Map<String, dynamic>> productDiscountList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${productData['image']}";
          productDiscountList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }
        setState(() {
          discountproducts = productDiscountList;
          print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$discountproducts");
        });
      } else {
        throw Exception('Failed to load discount products');
      }
    } catch (error) {
      print('Error fetching discount products: $error');
    }
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
      print('AAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL$addtocarturl$productId/');
      final token = await gettokenFromPrefs();

      final response = await http.post(
        Uri.parse('$addtocarturl$productId/'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
          'name': name,
          'price': price,
          'color': selectedColor,
          'size': selectedSize
        }),
      );
      print('statsssssssssssssssssssssssssssssssssssssssss${response.body}');

      if (response.statusCode == 201) {
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
      }
    } catch (error) {
      print('Error adding product to cart: $error');
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
              if (tokenn == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login_Page()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wishlist()));
              }
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(image: image),
                          ),
                        );
                      },
                      child: ClipRRect(
                        child: image != null
                            ? Image.network(
                                (image), // Decode base64 image
                                fit: BoxFit.fill,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                    if (offer_type != null &&
                        offer_type !=
                            "normal") // Check if discount percentage is available
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
                          if (price != null)
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
                                  sizeNames = images.firstWhere((image) =>
                                          image['color'] ==
                                          selectedColor)['size_names'] ??
                                      [];
                                  selectedSize = sizeNames.isNotEmpty
                                      ? sizeNames[0]
                                      : null;
                                  print("colorrrrrrrrrrr$selectedColor");

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

              if (selectedColor != null && sizeNames.isNotEmpty)
                Container(
                  height: 80,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: sizeNames.map((size) {
                        return Container(
                          width: 40.0, // Adjust the width and height as needed
                          height: 40.0, // Adjust the width and height as needed
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets
                                  .zero, // Remove default button padding
                              foregroundColor: selectedSize == size
                                  ? Color.fromARGB(255, 1, 80, 12)
                                  : Colors.black,
                              side: BorderSide(
                                color: selectedSize == size
                                    ? Color.fromARGB(255, 28, 146, 1)
                                    : Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Half of width/height
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedSize = size;
                                print("sizeeeeeeeeeee$selectedSize");
                              });
                            },
                            child: Center(
                              // Center the text inside the button
                              child: Text(size.toUpperCase()),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                      width: 140,
                      child: ElevatedButton(
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
                              "*${description}",
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
                                          if (product['price'] != null)
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

              if (discountproducts.isNotEmpty)
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Color.fromARGB(255, 217, 219, 221),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Discounts for you",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Discount_Products(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 0, 0,
                                      0), // Set white background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                child: Text(
                                  'See More',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: (discountproducts.length > 4)
                              ? 4
                              : discountproducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = discountproducts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Product_big_View(
                                        product_id: product['id'],
                                        Category_id: product['mainCategory'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        product['image'],
                                        width: 100,
                                        height: 100,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          product['name'],
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          ' \₹${product['price']}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          ' \₹${product['salePrice']}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      if (product['discount'] != null)
                                        Text(
                                            'Discount: ${product['discount']}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              if (recenlyviewd.isNotEmpty)
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recently Viewed",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height:
                              220, // Adjusted height to accommodate the images
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: SizedBox(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recenlyviewd.length >= 5
                                    ? 5
                                    : recenlyviewd.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final product = recenlyviewd[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Product_big_View(
                                            product_id: product['id'],
                                            Category_id:
                                                product['mainCategory'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 150, // Adjust the width as needed
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 173, 173, 173),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height:
                                                160, // Adjusted height to accommodate the images
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(recenlyviewd[
                                                        index][
                                                    'image']), // Using NetworkImage directly
                                                // fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              recenlyviewd[index]['name'],
                                              style: TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  '\₹${recenlyviewd[index]['salePrice']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Column(
                children: [
                  if (recommendedproducts.isNotEmpty)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          color: Color.fromARGB(255, 196, 220, 193),
                          child: Column(
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Text("Discounts for you",
                              //   style: TextStyle(fontWeight: FontWeight.bold)),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("Recommended Products",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Recommended_products(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255), // Set white background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      child: Text(
                                        'See More',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                children: List.generate(
                                  (recommendedproducts.length > 4)
                                      ? 4
                                      : recommendedproducts.length,
                                  (index) {
                                    final product = recommendedproducts[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Product_big_View(
                                                product_id: product['id'],
                                                Category_id:
                                                    product['mainCategory'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 211, 211, 211),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Image.network(
                                                recommendedproducts[index]
                                                    ['image'],
                                                width: 100,
                                                height: 100,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  recommendedproducts[index]
                                                      ['name'],
                                                  style: TextStyle(
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                              if (recommendedproducts[index]
                                                      ['price'] !=
                                                  null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Text(
                                                    '\₹${recommendedproducts[index]['price']}',
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  ' \₹${recommendedproducts[index]['salePrice']}',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                              if (product['discount'] != null)
                                                Text(
                                                    'Discount: ${recommendedproducts[index]['discount']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                ],
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
                  if (tokenn == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login_Page()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  }

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
      final response = await http
          .get(Uri.parse('$producturl${widget.Category_id}/products/'));

      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        List<Map<String, dynamic>> productsList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${productData['image']}";
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
        print(
            "==========================LLLLLLLLLLLLLLLLLLLLLLLLLL$categoryProducts");
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
    print('======================$multipleimageurl${widget.product_id}/r');
    Set<String> colorsSet = {};
    try {
      final response =
          await http.get(Uri.parse('$multipleimageurl${widget.product_id}/'));
      print("statussssssssssssssssssssssssss${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> imageData = jsonDecode(response.body)['product'];
        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$imageData");

        // product = jsonDecode(response.body)['product'];

        List<Map<String, dynamic>> productsList = [];

        for (var imageData in imageData) {
          String imageUrl1 =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${imageData['image1']}";
          String imageUrl2 =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${imageData['image2']}";
          String imageUrl3 =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${imageData['image3']}";
          String imageUrl4 =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${imageData['image4']}";
          String imageUrl5 =
              "https://latina-warcraft-welsh-arcade.trycloudflare.com/${imageData['image5']}";
          productsList.add({
            'id': imageData['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': imageData['color'],
            'size_names': List<String>.from(
                imageData['size_names']), // Cast to List<String>
          });
          colorsSet.add(imageData['color']);
        }

        setState(() {
          images = productsList;
          colors = colorsSet.toList();
          selectedColor = colors.isNotEmpty ? colors[0] : null;
          sizeNames = images.firstWhere(
                  (image) => image['color'] == selectedColor)['size_names'] ??
              [];
          selectedSize = sizeNames.isNotEmpty ? sizeNames[0] : null;
        });
      } else {
        throw Exception('Error fetching product image');
      }
    } catch (error) {
      print('Error fetching product image : $error');
    }
  }
}
