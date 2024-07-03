import 'dart:convert';
import 'dart:io';

import 'package:bepocart/addaddress.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/viewaddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAddress extends StatefulWidget {
  final String? userId;
  var id;
  UpdateAddress({Key? key, this.userId, required this.id}) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  var tokenn;
  @override
  void initState() {
    super.initState();
    fetchAddress();
     _initData();
  }

   Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    // Use userId after getting the value
    
  }


  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController note = TextEditingController();

  String updateaddressurl =
      "https://latina-warcraft-welsh-arcade.trycloudflare.com//update-address/";

  String durl = "https://latina-warcraft-welsh-arcade.trycloudflare.com//delete-address/";

  String url = "https://latina-warcraft-welsh-arcade.trycloudflare.com//get-address/";

  List<Map<String, dynamic>> addressList = [];

  Future<void> fetchAddress() async {
    final token = await gettokenFromPrefs();
    print("--------------------------------------------R$token");

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': '$token',
    },);

    print("FetchWishlistData status code: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['address'];

      setState(() {
        addressList = List<Map<String, dynamic>>.from(data);
        print(addressList);

        if (addressList.isNotEmpty) {
          var fetchedAddress = addressList[0];
          address.text = fetchedAddress['address'] ?? '';
          email.text = fetchedAddress['email'] ?? '';
          phone.text = fetchedAddress['phone'] ?? '';
          pin.text = fetchedAddress['pincode']?.toString() ?? '';
          city.text = fetchedAddress['city'] ?? '';
          state.text = fetchedAddress['state'] ?? '';
          note.text = fetchedAddress['note'] ?? '';
        }
      });
    } else {
      print("Failed to fetch address data");
    }
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Change Address"),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Update Address !",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: address,
                                          decoration: InputDecoration(
                                            labelText: 'Address',
                                            hintText: address.text.isNotEmpty ? address.text : 'Enter your address',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: email,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            hintText: email.text.isNotEmpty ? email.text : 'Enter your email',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: phone,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
                                            hintText: phone.text.isNotEmpty ? phone.text : 'Enter your phone number',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: pin,
                                          decoration: InputDecoration(
                                            labelText: 'Pincode',
                                            hintText: pin.text.isNotEmpty ? pin.text : 'Enter your pincode',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: city,
                                          decoration: InputDecoration(
                                            labelText: 'City',
                                            hintText: city.text.isNotEmpty ? city.text : 'Enter your city',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: state,
                                          decoration: InputDecoration(
                                            labelText: 'State',
                                            hintText: state.text.isNotEmpty ? state.text : 'Enter your state',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: note,
                                          decoration: InputDecoration(
                                            labelText: 'Note',
                                            hintText: note.text.isNotEmpty ? note.text : 'Enter a note (optional)',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 165, 165, 165)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                          255, 170, 170, 170)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 2, 2)),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                updateaddress(widget.id);
                                
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                    if (tokenn == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_Page()));
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

  Future<void> updateaddress(int id) async {
    print("========================>>>>>>>>>>>>>>>>>.....$id");
    try {
      final token = await gettokenFromPrefs();

      print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$token");
      var response = await http.put(
        Uri.parse('$updateaddressurl$id/'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'address': address.text,
            'city': city.text,
            'state': state.text,
            'pincode': int.parse(pin.text),
            'email': email.text,
            'phone': phone.text,
            'note': note.text,
          },
        ),
      );

      print("Response: $response");

      if (response.statusCode == 200) {
        print('Address updated successfully');
        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewAddress()));
      } else {
        print('Failed to update address: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating address: $error');
    }
  }
}
