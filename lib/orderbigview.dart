import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';


class OrderBigView extends StatefulWidget {
  var orderids;
  OrderBigView({super.key, required this.productid, required this.orderids});
  final int productid;

  @override
  State<OrderBigView> createState() => _OrderBigViewState();
}

class _OrderBigViewState extends State<OrderBigView> {
  @override
  void initState() {
    super.initState();
    myOrderDetails();

    print(
        "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW${widget.productid}");
  }

  final String orders =
      "https://sample-houston-cet-travel.trycloudflare.com/orders/";

  final String productsUrl =
      "https://sample-houston-cet-travel.trycloudflare.com/products/";

  List<dynamic> productIds = [];
  var productquantity;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true; // Add loading state

  Future<String?> getTokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
var quantity;
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

        for (var productData in productsData) {
          if(widget.productid == productData['product']) {
            quantity=productData['quantity'];

          }
         
        }

        setState(() {
          productquantity = quantity;
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

        print("Products Data: $productsData");
        for (var productData in productsData) {
          if (widget.productid == productData['id']) {
            String imageUrl =
                "https://sample-houston-cet-travel.trycloudflare.com/${productData['image']}";
            filteredProducts.add({
              'id': productData['id'],
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
          'Orders Details',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
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
                return Container(
  height: 170,
  margin: EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 188, 187, 187).withOpacity(0.3),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  ),
  child: Row(
    children: [
      Column(
        children: [
          Container(
            child: Image.network(
              product['image'],
              height: 140,
              width: 150,
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '\$${product['salePrice']}',
              style: TextStyle(
                color: Color.fromARGB(255, 27, 154, 44),
                fontSize: 12,
              ),
            ),
            Text(
              'Quantity:$productquantity',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      )
    ],
  ),
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
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
