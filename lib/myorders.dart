import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<String> ratedProducts = []; // List to store rated product IDs

  @override
  void initState() {
    super.initState();
    _initData();
    loadRatedProducts(); // Load rated products from shared preferences
    myOrderDetails();
  }

  Future<void> saveRatedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('ratedProducts', ratedProducts);
  }

  Future<void> loadRatedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ratedProducts = prefs.getStringList('ratedProducts') ?? [];
    });
  }

  var tokenn;

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();
    print("--------------------------------------------R$tokenn");
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  final String orders =
      "https://denmark-eagle-house-wedding.trycloudflare.com/order-items/";
  final String ratingurl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/product-review/";

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  Future<String?> getTokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> myOrderDetails() async {
    try {
      final token = await getTokenFromPrefs();

      print("TTTTTTTTTTTTTOOOOOOOOOOOOOOOOOOOOOOOKKKKKKKKKKKKKKKKKKKKK$token");

      final response = await http.get(
        Uri.parse(orders),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
      );

      print(
          "77777777777777777777777777777777777766666666666666666666666666666666666${response.body}");
      print(
          "55555555555555555555544444444444444444444444444443333333333333333333333${response.statusCode}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['data'];
        List<Map<String, dynamic>> orderProducts = [];

        print("WWWWWWWWWWWqqqqqqqqqwwwwwwwwwwwweeeeeeeeeeeeeeee$productsData");

        for (var productData in productsData) {
          String imageUrl =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${productData['image']}";
          orderProducts.add({
            'id': productData['order'].toString(),
            'productid': productData['product'].toString(),
            'name': productData['name'],
            'salePrice': productData['sale_price'].toString(),
            'image': imageUrl,
            'status': productData['status'],
          });
        }

        setState(() {
          products = orderProducts;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {
      print('Error fetching recommended products: $error');
    }
  }

  Future<void> postrating(
      String productid, double rating, String feedback) async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.post(
        Uri.parse('$ratingurl$productid/'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'rating': rating.toInt(),
            'review_text': feedback,
          },
        ),
      );

      print('$ratingurl$productid/');
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        print('Rating submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rating submitted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        ratedProducts.add(productid);
        saveRatedProducts(); // Save the updated list
      } else {
        print('Failed to submit rating: ${response.statusCode}');
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: ${response.body}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error submitting rating: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting rating'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRatingDialog(BuildContext context, String productid) {
    if (ratedProducts.contains(productid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already rated this product.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double _rating = 4.0;
        TextEditingController _feedbackController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text('Rate and review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rating (${_rating.toStringAsFixed(1)}/5)'),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.teal,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Review'),
              SizedBox(height: 10),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Feedback.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                postrating(productid, _rating, _feedbackController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (tokenn == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login_Page()));
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
              }
            },
            icon: Image.asset(
              "lib/assets/bag.png",
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                Color statusColor = (product['status'] == 'pending')
                    ? Colors.red
                    : Color.fromARGB(255, 6, 157, 3);

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (product['status'] == 'Completed')
                          _showRatingDialog(context, product['productid']);
                      },
                      child: Container(
                        height: 110,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.network(product['image']),
                          title: Text(
                            product['name'],
                            style: TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '\$${product['salePrice']}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Spacer(),
                              Text(
                                '${product['status']}',
                                style:
                                    TextStyle(color: statusColor, fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[200],
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 244, 244, 244),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: GNav(
            gap: 20,
            onTabChange: (index) {
              setState(() {});
            },
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
                },
              ),
              GButton(
                icon: Icons.favorite,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wishlist()));
                },
              ),
              GButton(
                icon: Icons.person,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
