import 'dart:convert';

import 'package:bepocart/checkout.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/selectdeliveryaddress.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final String? user_id;

  const Cart({Key? key, this.user_id}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? userId;
  List<dynamic> cartProductIds = [];
  List<dynamic> productIds = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cartProducts = [];
  List<dynamic> quantities = [];
  List<dynamic> productPrice = [];

  List<dynamic> pages = [HomePage(), Cart(), UserProfilePage()];

  int _selectedIndex = 0;
  var tokenn;

  var CartUrl = "https://audio-travesti-imposed-versions.trycloudflare.com/cart-products/";
  final String productsurl =
      "https://audio-travesti-imposed-versions.trycloudflare.com/products/";

  final quantityincrementurl =
      "https://audio-travesti-imposed-versions.trycloudflare.com/cart/increment/";

  final quantitydecrementurl =
      "https://audio-travesti-imposed-versions.trycloudflare.com/cart/decrement/";

  final deletecarturl =
      "https://audio-travesti-imposed-versions.trycloudflare.com/cart-delete/";

  @override
  void initState() {
    _initData();

    super.initState();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn =await gettokenFromPrefs();
    print("--------------------------------------------R$userId");

    fetchCartData();
    calculateTotalPrice();
  }

   Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchCartData() async {
    print("Fetching cart data...");
    try {
      final token = await gettokenFromPrefs();
      print("Token: $token");

      final response = await http.post(Uri.parse(CartUrl), headers: {
        'Authorization': '$token',
      }, body: {
        'token': token,
      });

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        print("AAAAAAAAAAAA AAAAAAAAAAHHHHHHHHHHHDEEEEEEEEEEEEEEEEEEEEE$data");

        List<Map<String, dynamic>> cartItems = [];

        for (var item in data) {
          String imageUrl ="https://audio-travesti-imposed-versions.trycloudflare.com/${item['image']}";

          cartItems.add({
            'id': item['id'],
            'productId': item['product'],
            'mainCategory':item['mainCategory'],
            'quantity': item['quantity'],
            'actualprice':item['price'],
            'price': item['salePrice'],
            'name': item['name'],
            'image': imageUrl,
            'color':item['color'],
            'size':item['size']

            // Update with correct price value
          });
        }

        setState(() {
          cartProducts = cartItems;
        });
        print(cartProducts.length);
        print("cccccccccccccccccccccccCart Products: $cartProducts");
      } else {
        print("Failed to fetch cart data");
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }

  Future<void> incrementquantity(int cartProductId, int newQuantity) async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$quantityincrementurl$cartProductId/'),
        headers:
         {'Authorization': '$token'},
        body: jsonEncode({'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        print('Quantity updated successfully');

        setState(() {
          fetchCartData();
          calculateTotalPrice();
        });
      } else {
        print('Failed to update quantity: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }

  Future<void> Decrementquantity(int cartProductId, int newQuantity) async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$quantitydecrementurl$cartProductId/'),
        headers: {'Authorization': '$token'},
        body: jsonEncode({'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        print('Quantity updated successfully');
        setState(() {
          calculateTotalPrice();
          fetchCartData();
        });
      } else {
        print('Failed to update quantity: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }

  Future<void> deleteCartProduct(int cartProductId) async {
    final token = await gettokenFromPrefs();

    try {
      final response = await http.delete(
        Uri.parse('$deletecarturl$cartProductId/'),
      );
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 204) {
        print('Wishlist ID deleted successfully: $cartProductId');
      } else {
        throw Exception('Failed to delete wishlist ID: $cartProductId');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void removeProduct(int index) {
    setState(() {
      cartProducts.removeAt(index);
    });
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Future<String?> gettokenFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    setState(() {
      for (int i = 0; i < cartProducts.length; i++) {
        totalPrice += double.parse(cartProducts[i]['price']) *
            (cartProducts[i]['quantity'] ?? 1);
        print("total::::::$totalPrice");
      }
    });

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (tokenn == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login_Page()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wishlist()));
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                     Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Product_big_View(
                                      product_id:
                                          cartProducts[index]
                                              ['productId'],
                                      Category_id: int.parse(
                                          cartProducts[index]
                                              ['mainCategory']),
                                    ),
                                  ),
                                );
                  },
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 120,
                          width: 120,
                          child: Image.network(
                            cartProducts[index]['image'],
                            width: 120,
                            height: 120,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartProducts[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                 SizedBox(height: 5),
                                 if(cartProducts[index]['actualprice']!=null)
                                Text(
                                  '\$${cartProducts[index]['actualprice']}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14,
                                    color: Colors.grey
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${cartProducts[index]['price']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green
                                  ),
                                ),
                                if(cartProducts[index]['color']!=null && cartProducts[index]['size']!=null)
                                  Row(
                                    children: [
                                      Text(
                                    '${cartProducts[index]['color']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(255, 115, 115, 115)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    '${cartProducts[index]['size']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:  const Color.fromARGB(255, 115, 115, 115)
                                    ),
                                  ),

                                    ],

                                ),
                               
                                // Inside the ListView.builder itemBuilder method
                                Container(
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.black),
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Decrementquantity(
                                              cartProducts[index]['id'],
                                              cartProducts[index]["quantity"] +
                                                  1);
                  
                                          setState(() {
                                            calculateTotalPrice();
                                            fetchCartData();
                                          });
                                        },
                                        icon: Icon(Icons.remove),
                                        iconSize: 18,
                                      ),
                                      Text(
                                        '${cartProducts[index]["quantity"] ?? 1}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          print(cartProducts[index]['id']);
                  
                                          incrementquantity(
                                              cartProducts[index]['id'],
                                              cartProducts[index]["quantity"] +
                                                  1);
                  
                                          setState(() {
                                            calculateTotalPrice();
                                            fetchCartData();
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                        iconSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 15),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  deleteCartProduct(cartProducts[index]['id']);
                                  removeProduct(index);
                                },
                                child: ImageIcon(
                                  AssetImage('lib/assets/close.png'),
                                  size: 24,
                                  color: Color.fromARGB(255, 0, 0, 0),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Select_Delivery_Address()));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => search()));
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
      print(_selectedIndex);
    });
  }
}
