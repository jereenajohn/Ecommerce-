import 'dart:convert';
import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/selectdeliveryaddress.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';

class order extends StatefulWidget {
  var addressid;
  var name;
  var city;
  var state;
  var number;
  var pincode;
  var email;
  var note;
  var userid;

  order(
      {super.key,
      required this.addressid,
      required this.name,
      required this.city,
      required this.state,
      required this.number,
      required this.pincode,
      required this.email,
      required this.note,
      required this.userid});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  String? userId;
  String fetchaddressurl =
      "https://4a48-117-193-85-167.ngrok-free.app/get-address/";
  List<Map<String, dynamic>> addressList = [];
  int selectedAddressIndex = -1;

  @override
  void initState() {
    super.initState();
    _initData();
    print(widget.name);
    print(widget.addressid);
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();

    fetchCartData();
    // calculateTotalPrice();
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  var CartUrl = "https://4a48-117-193-85-167.ngrok-free.app/cart-products/";
  List<Map<String, dynamic>> cartProducts = [];
  var orginalprice;
  var sellingprice;
  var discount;
  var deliverycharge;

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
        print("data: $data");

        List<Map<String, dynamic>> cartItems = [];

        for (var item in data) {
          String imageUrl =
              "https://4a48-117-193-85-167.ngrok-free.app${item['image']}";

          // Check if item['price'] is null and assign zero if so
          var price = item['price'] != null ? item['price'] : 0;

          cartItems.add({
            'id': item['id'],
            'productId': item['product'],
            'mainCategory': item['mainCategory'],
            'quantity': item['quantity'],
            'saleprice': item['salePrice'],
            'price': price,
            'name': item['name'],
            'image': imageUrl,
          });
        }

        setState(() {
          cartProducts = cartItems;
          orginalprice = calculateOriginalPrice();
          sellingprice = calculateTotalPrice();
          discount = orginalprice - sellingprice;
          print("Original Price: $orginalprice");
          print("Selling Price: $sellingprice");
          print("Discount: $discount");
        });

        print(cartProducts.length);
        print("Cart Products: $cartProducts");
      } else {
        print("Failed to fetch cart data");
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }

  double calculateOriginalPrice() {
    double totalPrice = 0.0;

    for (int i = 0; i < cartProducts.length; i++) {
      double price = cartProducts[i]['price'] is String
          ? double.parse(cartProducts[i]['price'])
          : cartProducts[i]['price'].toDouble();
      int quantity = cartProducts[i]['quantity'] ?? 1;

      // Check if price is zero, use selling price instead
      if (price == 0) {
        price = double.parse(cartProducts[i]['saleprice']);
      }

      totalPrice += price * quantity;
    }

    print("Total Original Price: $totalPrice");
    return totalPrice;
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    setState(() {
      for (int i = 0; i < cartProducts.length; i++) {
        totalPrice += double.parse(cartProducts[i]['saleprice']) *
            (cartProducts[i]['quantity'] ?? 1);
        print("total::::::$totalPrice");
      }
      if (totalPrice < 500) {
        deliverycharge = 60;
        totalPrice = totalPrice + deliverycharge;
      }
    });

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Select_Delivery_Address()),
            );
          },
          child: Text(
            "Order Summary",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStep(1, "Address", currentStep >= 1),
                            _buildSeparator(currentStep >= 2),
                            _buildStep(2, "Order Summary", currentStep >= 2),
                            _buildSeparator(currentStep >= 3),
                            _buildStep(3, "Payment", currentStep >= 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 202, 201, 201)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              widget.name,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              "${widget.city}, ${widget.state}, ${widget.number.toString()}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              widget.email,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              widget.pincode.toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildCartItems(),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 202, 201, 201)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Price Details",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Price",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                "₹${orginalprice}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Discount",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                "-₹${discount}",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Delivery Charge",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                deliverycharge != 60
                                    ? "Free Delivery"
                                    : "₹${deliverycharge}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: deliverycharge != 60
                                      ? Colors.green
                                      : Colors
                                          .black, // Change color if free delivery
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Spacer(),
                              Text(
                                "₹${sellingprice}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "You will save ₹${discount} on this order",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 70,
                          color: Color.fromARGB(255, 228, 227, 227),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                              ),
                              Image.asset(
                                "lib/assets/safe.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                  width:
                                      15), // Add some space between the image and text
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Safe and secure payment.Easy ",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            "\nreturns. 100% Authentic products.",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), // Display cart items here
                ],
              ),
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
                    "Payment",
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

  final int currentStep = 2; // Change this value to reflect the current step

  Widget _buildStep(int step, String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: isActive
              ? Text(
                  step.toString(),
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  step.toString(),
                  style: TextStyle(color: Colors.white),
                ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(bool isActive) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 202, 201, 201).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product['image'],
                height: 80.0,
                width: 80.0,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 5.0),
                    Text('Quantity: ${product['quantity']}'),
                    SizedBox(height: 5.0),
                    Text('\₹${product['saleprice']}'),
                    Text(
                      '\₹${product['price'] != 0 ? product['price'] : 'No offer available'}',
                      style: TextStyle(
                        color: product['price'] != 0
                            ? Colors.grey
                            : Colors.green, // Text color change
                        decoration: product['price'] != 0
                            ? TextDecoration.lineThrough
                            : TextDecoration
                                .none, // Line-through effect if price is not zero
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
