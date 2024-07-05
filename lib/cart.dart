import 'dart:convert';

import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
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

  var CartUrl =
      "https://hourly-mv-mo-virtual.trycloudflare.com/cart-products/";
  final String productsurl =
      "https://hourly-mv-mo-virtual.trycloudflare.com/products/";

  final quantityincrementurl =
      "https://hourly-mv-mo-virtual.trycloudflare.com/cart/increment/";

  final quantitydecrementurl =
      "https://hourly-mv-mo-virtual.trycloudflare.com/cart/decrement/";

  final deletecarturl =
      "https://hourly-mv-mo-virtual.trycloudflare.com/cart-delete/";

  @override
  void initState() {
    _initData();

    super.initState();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();
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

      final response = await http.get(
        Uri.parse(CartUrl),
        headers: {
          'Authorization': '$token',
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        print("AAAAAAAAAAAA AAAAAAAAAAHHHHHHHHHHHDEEEEEEEEEEEEEEEEEEEEE$data");

        List<Map<String, dynamic>> cartItems = [];

        for (var item in data) {
          String imageUrl =
              "https://hourly-mv-mo-virtual.trycloudflare.com${item['image']}";

          cartItems.add({
            'id': item['id'],
            'productId': item['product'],
            'mainCategory': item['mainCategory'],
            'quantity': item['quantity'],
            'actualprice': item['price'],
            'price': item['salePrice'],
            'name': item['name'],
            'image': imageUrl,
            'color': item['color'],
            'size': item['size'],
            'offer_type': item['offer_type'],
            'stock': item['stock'],

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
        headers: {'Authorization': '$token'},
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
  var Dquantity;

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    double? leastPrice;
    int offerProductCount = 0;

    setState(() {
      if (selectedOption == 'Option 1') {
        for (int i = 0; i < cartProducts.length; i++) {
          double price = double.parse(cartProducts[i]['price']);
          int quantity = cartProducts[i]['quantity'] ?? 1;

          totalPrice += price * quantity;
        }
        print("option111111111111111111111111111111$totalPrice");
      } else {
        for (int i = 0; i < cartProducts.length; i++) {
          double price = double.parse(cartProducts[i]['price']);
          int quantity = cartProducts[i]['quantity'] ?? 1;

          // Add price to total price
          totalPrice += price * quantity;

          // Check if this product has an offer
          String? offerType = cartProducts[i]['offer_type'];
          if (offerType == "BUY 1 GET 1" || offerType == "BUY 2 GET 1") {
            // Count the offer products
            offerProductCount += quantity;

            // Determine the least priced offer product
            if (leastPrice == null || price < leastPrice!) {
              leastPrice = price;
              Dquantity = quantity;
              print("Quantity of least price product: $Dquantity");
            }
          }
        }

// Adjust the total price based on the offer type
        if (leastPrice != null) {
          for (int i = 0; i < cartProducts.length; i++) {
            String? offerType = cartProducts[i]['offer_type'];
            if (offerType == "BUY 1 GET 1") {
              // For "BUY 1 GET 1", each pair gets one free
              int freeItems = offerProductCount ~/ 2;
              print("Free items: $freeItems");

              while (freeItems > 0) {
                int dQuantity = Dquantity ?? 0;

                if (freeItems >= dQuantity) {
                  totalPrice -= (leastPrice! * dQuantity);
                  freeItems -= dQuantity;
                  print(
                      "Total after reduction: $totalPrice, remaining free items: $freeItems");

                  // Find the next least priced product with the same offer
                  double? nextLeastPrice;
                  int nextDquantity = 0;
                  for (int j = 0; j < cartProducts.length; j++) {
                    double price = double.parse(cartProducts[j]['price']);
                    String? nextOfferType = cartProducts[j]['offer_type'];
                    if ((nextLeastPrice == null || price < nextLeastPrice) &&
                        (nextOfferType == "BUY 1 GET 1" ||
                            nextOfferType == "BUY 2 GET 1") &&
                        price > leastPrice!) {
                      nextLeastPrice = price;
                      nextDquantity = cartProducts[j]['quantity'] ?? 1;
                    }
                  }

                  if (nextLeastPrice == null)
                    break; // No more lower priced products

                  leastPrice = nextLeastPrice;
                  Dquantity = nextDquantity;
                } else {
                  totalPrice -= (leastPrice! * freeItems);
                  freeItems = 0;
                  print("Total after final reduction: $totalPrice");
                }
              }
              break; // Exit the loop after processing the first offer type "BUY 1 GET 1"
            } else if (offerType == "BUY 2 GET 1") {
              // For "BUY 2 GET 1", every three items, one is free
              int freeItems = offerProductCount ~/ 3;
              print("Free items: $freeItems");

              while (freeItems > 0) {
                int dQuantity = Dquantity ?? 0;

                if (freeItems >= dQuantity) {
                  totalPrice -= (leastPrice! * dQuantity);
                  freeItems -= dQuantity;
                  print(
                      "Total after reduction: $totalPrice, remaining free items: $freeItems");

                  // Find the next least priced product with the same offer
                  double? nextLeastPrice;
                  int nextDquantity = 0;
                  for (int j = 0; j < cartProducts.length; j++) {
                    double price = double.parse(cartProducts[j]['price']);
                    String? nextOfferType = cartProducts[j]['offer_type'];
                    if ((nextLeastPrice == null || price < nextLeastPrice) &&
                        (nextOfferType == "BUY 1 GET 1" ||
                            nextOfferType == "BUY 2 GET 1") &&
                        price > leastPrice!) {
                      nextLeastPrice = price;
                      nextDquantity = cartProducts[j]['quantity'] ?? 1;
                    }
                  }

                  if (nextLeastPrice == null)
                    break; // No more lower priced products

                  leastPrice = nextLeastPrice;
                  Dquantity = nextDquantity;
                } else {
                  totalPrice -= (leastPrice! * freeItems);
                  freeItems = 0;
                  print("Total after final reduction: $totalPrice");
                }
              }
              break; // Exit the loop after processing the first offer type "BUY 2 GET 1"
            }
          }
        }
      }
    });

    print("Total price after applying offers: $totalPrice");
    return totalPrice;
  }

  String? selectedOption = 'Option 1';
  var offerquantity;

  double? leastPrice = null;

  int offerProductCount = 0;

  int calculateOfferQuantity(String offerType, int quantity) {
    if (offerType == 'BUY 1 GET 1') {
      return quantity * 2;
    } else if (offerType == 'BUY 2 GET 1') {
      return quantity + (quantity ~/ 2);
    }
    return quantity;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                
                Row(
                  children: [
                    Radio<String>(
                      value: 'Option 1',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    Text('Option 1'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Option 2',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    Text('Option 2'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                var stock = cartProducts[index]['stock'] ?? 0;
                var quantity = cartProducts[index]['quantity'] ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Product_big_View(
                          product_id: cartProducts[index]['productId'],
                          Category_id:
                              int.parse(cartProducts[index]['mainCategory']),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        SizedBox(width: 10),
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
                                if (cartProducts[index]['actualprice'] != null)
                                  Text(
                                    '\$${cartProducts[index]['actualprice']}',
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${cartProducts[index]['price']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                if (cartProducts[index]['color'] != null &&
                                    cartProducts[index]['size'] != null)
                                  Row(
                                    children: [
                                      Text(
                                        '${cartProducts[index]['color']}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                              255, 115, 115, 115),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${cartProducts[index]['size']}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                              255, 115, 115, 115),
                                        ),
                                      ),
                                    ], 
                                  ),
                                // Inside the ListView.builder itemBuilder method
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Decrementquantity(
                                              cartProducts[index]['id'],
                                              cartProducts[index]["quantity"] -
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
                                          if (stock > quantity) {
                                            incrementquantity(
                                                cartProducts[index]['id'],
                                                cartProducts[index]
                                                        ["quantity"] +
                                                    1);

                                            setState(() {
                                              calculateTotalPrice();
                                              fetchCartData();
                                            });
                                          } else {
                                            print("out of stockkk");
                                          }
                                        },
                                        icon: Icon(Icons.add),
                                        iconSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                if (selectedOption == 'Option 1' &&
                                    (cartProducts[index]['offer_type'] ==
                                            'BUY 1 GET 1' ||
                                        cartProducts[index]['offer_type'] ==
                                            'BUY 2 GET 1'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      cartProducts[index]['offer_type'] ==
                                              'BUY 2 GET 1'
                                          ? 'Special Offer: ${cartProducts[index]['offer_type']}'
                                          : 'Special Offer: ${cartProducts[index]['offer_type']} - Get ${calculateOfferQuantity(cartProducts[index]['offer_type'], cartProducts[index]['quantity'])} items',
                                      style: TextStyle(  
                                        fontSize: 11,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Select_Delivery_Address()));
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
