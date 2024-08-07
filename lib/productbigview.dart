import 'dart:convert';
import 'dart:ui';

import 'package:bepocart/cart.dart';
import 'package:bepocart/discountproducts.dart';
import 'package:bepocart/fullscreenimage.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/recommendedproducts.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product_big_View extends StatefulWidget {
  Product_big_View(
      {required this.product_id,
      required this.Category_id,
      required this.slug});

  final product_id;
  final Category_id;
  final slug;

  @override
  State<Product_big_View> createState() => _Product_big_ViewState();
}

class _Product_big_ViewState extends State<Product_big_View> {
  final producturl =
      "http://51.20.129.52/category/";

  final multipleimageurl =
      "http://51.20.129.52/product-images/";

  final String addtocarturl =
      "http://51.20.129.52/cart/";
  final String wishlisturl =
      "http://51.20.129.52/add-wishlist/";

  final String discountsurl =
      "http://51.20.129.52/discount-sale/";

  var recentlyviewedurl =
      "http://51.20.129.52/recently-viewed/";

  final String recommendedproductsurl =
      "http://51.20.129.52/recommended/";
  final imageurl =
      "http://51.20.129.52/product/";

  final String ratingurl =
      "http://51.20.129.52/review/";
  List<Map<String, dynamic>> Products = [];
  List<Map<String, dynamic>> categoryProducts = [];
  List<Map<String, dynamic>> images = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> discountproducts = [];
  List<Map<String, dynamic>> recenlyviewd = [];
  List<Map<String, dynamic>> recommendedproducts = [];
  List<Map<String, dynamic>> productsrating = [];

  List<bool> isFavorite = [];
  int _selectedIndex = 0;

  List<String> sizeNames = [];
  String? selectedSize;
  int? selectedstock;
  var sizes;

  var name;
  var image;
  var price;
  var stock;
  var shortdescription;
  var description;
  var salePrice;
  var offer_type;

  bool isDataLoaded = false;
  var tokenn;

  @override
  void initState() {
    _initData();
    // fetchproductdata();
    fetchDiscountProducts();
    recentlyviewed();
    fetchRecommendedProducts();
    sizecolor();
    fetchRatingData();
    super.initState();
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    // Use userId after getting the value
  }

  double totalRating = 0.0;
  String averageRating = "0.0"; // Changed to String to hold the formatted value

  Future<void> fetchRatingData() async {
    try {
      final token = await gettokenFromPrefs();

      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse('$ratingurl${widget.product_id}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final productsData = jsonDecode(response.body) as List;

        List<Map<String, dynamic>> productratingList = [];

        for (var productData in productsData) {
          String imageUrl = "${productData['image']}";
          productratingList.add({
            'rating': productData['rating'],
            'review_text': productData['review_text'] ?? 'No review',
            'first_name': productData['first_name'] ?? 'No first name',
            'image': imageUrl
          });

          // Calculate total rating
          totalRating += productData['rating'];
        }

        // Compute average rating and format to one decimal place

        setState(() {
          if (productsData.isNotEmpty) {
            averageRating =
                (totalRating / productsData.length).toStringAsFixed(1);
          }
          productsrating = productratingList;
        });
      } else {
        throw Exception('Failed to load rating data');
      }
    } catch (error) {}
  }

  Future<void> fetchRecommendedProducts() async {
    try {
      final token =
          await gettokenFromPrefs(); // Make sure this method returns your token correctly

      final response = await http.get(
        Uri.parse(recommendedproductsurl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['data'];

        List<Map<String, dynamic>> productRecommendedList = [];

        for (var productData in productsData) {
          String imageUrl = "${productData['image']}";
          productRecommendedList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
            'slug':productData['slug']
          });
        }

        setState(() {
          recommendedproducts = productRecommendedList;
        });
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {}
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

      if (response.statusCode == 200) {
        final recent = jsonDecode(response.body);

        final List<dynamic> recentproductsData = recent['data'];
        List<Map<String, dynamic>> Recentlylist = [];

        for (var recentproductsData in recentproductsData) {
          String imageUrl = "${recentproductsData['image']}";
          Recentlylist.add({
            'id': recentproductsData['id'],
            'mainCategory': recentproductsData['mainCategory'],
            'name': recentproductsData['name'],
            'salePrice': recentproductsData['salePrice'],
            'image': imageUrl,
            'slug': recentproductsData['slug']
          });
        }

        setState(() {
          recenlyviewd = Recentlylist;
        });
      } else {}
    } catch (error) {}
  }

  Future<void> fetchDiscountProducts() async {
    try {
      final response = await http.get(Uri.parse(discountsurl));

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed;

        List<Map<String, dynamic>> productDiscountList = [];

        for (var productData in productsData) {
          String imageUrl = "${productData['image']}";
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
        });
      } else {
        throw Exception('Failed to load discount products');
      }
    } catch (error) {}
  }

  Future<void> addProductToWishlist(int productId) async {
    try {
      final token = await gettokenFromPrefs();

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
      } else {}
    } catch (error) {}
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

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to Cart'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 400) {
        // Product already in cart, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already in Cart'),
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('session expired'),
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login_Page()));
      } else {}
    } catch (error) {}
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
                      if(productmaindata['name'] != null)
                                  Text(
                                  "${productmaindata['name']}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                ),
                              
                      
                          
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          if(productmaindata['salePrice'] != null)
                              Text(
                                  "${productmaindata['salePrice']}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                ),
                            
                          SizedBox(
                            width: 5,
                          ),
                          if (productmaindata['price'] != null)
                            Text(
                              "${productmaindata['price']}",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 155, 153, 153),
                                  decoration: TextDecoration.lineThrough),
                            ),
                          SizedBox(
                            width: 4,
                          ),
                          if (averageRating != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 255, 197, 5),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "$averageRating",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 255, 197, 5),
                                  ),
                                ),
                              ],
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Wrap(
                            spacing: 8.0,
                            children: colors.map<Widget>((color) {
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
                                    print(selectedColor);
                                   sizecolor();
                                    updateDisplayedImage(selectedColor);
                                  });
                                },
                                child: Text(color.toUpperCase()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (selectedColor != null && selectedSize!=null)
                Container(
                  height: 60,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: sizes.map<Widget>((sizeData) {
                          return Container(
                            width: 47.0,
                            height: 47.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal:
                                    4.0), // Add horizontal margin for spacing
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor:
                                    selectedSize == sizeData['size']
                                        ? Color.fromARGB(255, 1, 80, 12)
                                        : Colors.black,
                                side: BorderSide(
                                  color: selectedSize == sizeData['size']
                                      ? Color.fromARGB(255, 28, 146, 1)
                                      : Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: sizeData['stock'] > 0
                                  ? () {
                                      setState(() {
                                        selectedSize = sizeData['size'];
                                        selectedstock = sizeData['stock'];
                                        print("selectedSizeeeeeees$selectedSize");
                                        print("selectedSizeeeeeees$selectedstock");

                                      });
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  sizeData['size'].toUpperCase(),
                                  style: TextStyle(
                                    decoration: sizeData['stock'] == 0
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

              
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: (selectedStock ?? 0) > 0
                              ? () {
                                  addProductToCart(
                                      widget.product_id, name, price);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: (selectedStock ?? 0) > 0
                                ? Colors.black
                                : Colors.grey,
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
                          if (name != null)
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
                            child: description != null
                                ? Text(
                                    "*${description}",
                                    maxLines:
                                        null, // Set maxLines to null for unlimited lines
                                  )
                                : SizedBox.shrink(),
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
                            child: shortdescription != null
                                ? Text(
                                    "*${shortdescription}",
                                    maxLines:
                                        null, // Set maxLines to null for unlimited lines
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      SizedBox(height: 15)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              if (productsrating.isNotEmpty)
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Reviews",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis
                                .horizontal, // Set the scroll direction to horizontal
                            itemCount: productsrating.length,
                            itemBuilder: (context, index) {
                              final rating = productsrating[index]['rating'];
                              var img = productsrating[index]['image'];

                              final reviewText =
                                  productsrating[index]['review_text'];
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width:
                                      300, // Set a fixed width for each review container

                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 237, 237, 237),
                                        Color.fromARGB(255, 245, 243, 243)!
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)
                                                .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  img != null && img.isNotEmpty
                                                      ? ClipOval(
                                                          child: Image.network(
                                                            img,
                                                            width: 25,
                                                            height: 25,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          'lib/assets/user.png',
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                            ),
                                            Text(productsrating[index]
                                                ['first_name']),
                                          ],
                                        ),
                                        Text(
                                          "$reviewText",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: List.generate(5, (i) {
                                            return Icon(
                                              i < rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 15,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),

              SizedBox(
                height: 5,
              ),

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
                                              product_id:
                                                  categoryProducts[index]['id'],
                                              Category_id:
                                                  categoryProducts[index]
                                                      ['mainCategory'],
                                              slug: categoryProducts[index]
                                                  ['slug'],
                                            )));

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
                                        slug: categoryProducts[index]['slug'],
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
                        padding: const EdgeInsets.only(left: 10, bottom: 10,top: 10),
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
                              230, // Adjusted height to accommodate the images
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
                                            slug: product['slug'],
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

                SizedBox(height: 15,),

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
                                                slug: product['slug'],
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
                icon: Icons.favorite,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wishlist()));
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
      print('uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$producturl${widget.Category_id}/products/');
      final response = await http
          .get(Uri.parse('$producturl${widget.Category_id}/products/'));

      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        List<Map<String, dynamic>> productsList = [];

        for (var productData in productsData) {
          String imageUrl =
              "${productData['image']}";
          productsList.add({
            'id': productData['id'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'stock': productData['stock'],
            'shortDescription': productData['short_description'],
            'description': productData['description'],
            'mainCategory': productData['mainCategory'],
            'offer_type': productData['offer_type'],
            'image': imageUrl,
            'slug': productData['slug']
          });
        }

        setState(() {
          for (int i = 0; i < productsList.length; i++) {
            if (widget.product_id == productsList[i]['id']) {
              image = productsList[i]['image'];
              name = productsList[i]['name'];
              price = productsList[i]['price'];
              stock = productsList[i]['stock'];
              salePrice = productsList[i]['salePrice'];
              shortdescription = productsList[i]['shortDescription'];
              description = productsList[i]['description'];
              offer_type = productsList[i]['offer_type'];
            }
          }

          categoryProducts = productsList;
          isDataLoaded = true;
        });
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (error) {}
  }

  Map<String, dynamic> product = {};
  String? selectedColor;
  List<String> colors = [];


int? selectedStock;

Map productmaindata={};
Future<void> sizecolor() async {
  Set<String> colorsSet = {};
  try {
    print('urlllllllllllllllllllllllllllllllllllllllllllllllll$imageurl${widget.slug}/');
    final response = await http.get(Uri.parse('$imageurl${widget.slug}/'));
    print("responseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (!data.containsKey('images')) {
        throw Exception('No images key in response data');
      }

      final List<dynamic> imageData = data['images'];
      productmaindata = data['product'];
      print("productmaindataaaaaaaaaaaaaaaaaaaaaaa${productmaindata}");
      String imageUrl =
          "${productmaindata['image']}";

      List<Map<String, dynamic>> productsList = [];

      for (var image in imageData) {
        String imageUrl1 = "${image['image1']}";
        String imageUrl2 = "${image['image2']}";
        String imageUrl3 = "${image['image3']}";
        String imageUrl4 = "${image['image4']}";
        String imageUrl5 = "${image['image5']}";

        List<Map<String, dynamic>> sizes = [];

        if (image['type'] == 'single') {
          productsList.add({
            'id': image['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': image['color'],
            'stock': image['stock'],
            'type': image['type']
          });
          colorsSet.add(image['color']);
        } else if (image['type'] == 'variant') {
          sizes = (image['stock_info'] as List<dynamic>)
              .map((variant) => {
                    'size': variant['size'],
                    'stock': variant['stock']
                  }).toList();
          print("siiiiiiiiiiiiiiiiiiiiiii$sizes");

          productsList.add({
            'id': image['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': image['color'],
            'sizes': sizes,
            'type': image['type']
          });
          colorsSet.add(image['color']);
        } else {
          throw Exception('Unknown product type');
        }
      }

      setState(() {
        image = imageUrl;
        images = productsList;
        colors = colorsSet.toList();
        if (selectedColor == null && colors.isNotEmpty) {
          selectedColor = colors[0];
        }

        if (productsList.isNotEmpty) {
          Map<String, dynamic>? selectedProduct = productsList.firstWhere(
              (product) => product['color'] == selectedColor,
              orElse: () => <String, dynamic>{});

          if (selectedProduct.isNotEmpty && selectedProduct['type'] == 'variant') {
            sizes = selectedProduct['sizes'] ?? [];
            selectedSize = sizes.isNotEmpty ? sizes[0]['size'] : null;
            selectedStock = sizes.isNotEmpty ? sizes[0]['stock'] : null;
          } else if (selectedProduct.isNotEmpty && selectedProduct['type'] == 'single') {
            selectedSize = null;
            selectedStock = selectedProduct['stock'];
          }
        }
      });
    } else {
      throw Exception('Error fetching product image');
    }
  } catch (error) {
    print('Error fetching product image: $error');
  }
}


}
