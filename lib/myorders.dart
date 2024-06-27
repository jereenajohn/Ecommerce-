import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/orderbigview.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  void initState() {
    super.initState();
    _initData();
    myOrderDetails();
  }

  var tokenn;

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    print("--------------------------------------------R$tokenn");
    // Use userId after getting the value
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  final String orders =
      "https://michelle-miniature-depot-studied.trycloudflare.com/orders/";

  final String productsUrl =
      "https://michelle-miniature-depot-studied.trycloudflare.com/products/";

  List<dynamic> productIds = [];
  List<dynamic> orderIds = [];
  List<Map<String, dynamic>> products = [];
  bool isLoading = true; // Add loading state

  Future<String?> getTokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> myOrderDetails() async {
    try {
      final token = await getTokenFromPrefs();

      print("TTTTTTTTTTTTTOOOOOOOOOOOOOOOOOOOOOOOKKKKKKKKKKKKKKKKKKKKK$token");

      final response = await http.post(
        Uri.parse(orders),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      print(
          "77777777777777777777777777777777777766666666666666666666666666666666666${response.body}");
      print(
          "55555555555555555555544444444444444444444444444443333333333333333333333${response.statusCode}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['data'];

        print("WWWWWWWWWWWqqqqqqqqqwwwwwwwwwwwweeeeeeeeeeeeeeee$productsData");

        List<int> ids = [];
        List<int> orderids = [];

        for (var productData in productsData) {
          ids.add(productData['product']);
          orderids.add(productData['id']);
        }

        setState(() {
          productIds = ids;
          orderIds = orderids;
        });

        // Fetch product details after getting order details
        fetchProducts();
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {
      print('Error fetching recommended products: $error');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      print('fetchProducts Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['products'];
        List<Map<String, dynamic>> filteredProducts = [];

        print(
            "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYUUUUUUUUUUUUUUUUUUUUUIIIIIIIIIIIIIIIIIIIIIIII$productsData");
        for (var productData in productsData) {
          if (productIds.contains(productData['id'])) {
            String imageUrl =
                "https://michelle-miniature-depot-studied.trycloudflare.com/${productData['image']}";
            filteredProducts.add({
              'productid': productData['id'],
              'name': productData['name'],
              'salePrice': productData['salePrice'],
              'image': imageUrl,
              'mainCategory': productData['mainCategory']
            });
          }
        }

        setState(() {
          products = filteredProducts;
          isLoading = false; // Set loading state to false

          print(
              "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG$products");
        });
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      print('Error fetching wishlist products: $error');
    }
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
          ? Center(child: CircularProgressIndicator()) // Display loader
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderBigView(
                                    productid: product['productid'],
                                    orderids: orderIds)));
                      },
                      child: Container(
                        height: 90,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.network(product['image']),
                          title: Text(
                            product['name'],
                            style: TextStyle(
                                fontSize: 13, overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(
                            '\$${product['salePrice']}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[
                          200], // You can adjust the color and thickness here
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
}
