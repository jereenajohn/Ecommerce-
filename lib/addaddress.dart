import 'dart:convert';
import 'dart:io';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/selectdeliveryaddress.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/viewaddress.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAddress extends StatefulWidget {
  final String? userId;
  UserAddress({Key? key, this.userId}) : super(key: key);

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController note = TextEditingController();

  String url =
      "https://hot-states-obligation-dvds.trycloudflare.com/add-address/";
  var tokenn;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
        
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => viewAddress()));
                    
              }, 
              child: Text(
                "View Address", // Your address text here
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 16,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black), // Set background color to black
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  // Container(
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: const Color.fromARGB(255, 183, 183, 183).withOpacity(0.5),
                  //         spreadRadius: 5,
                  //         blurRadius: 10,
                  //         offset: Offset(0, 3),
                  //       ),
                  //     ],
                  //     color: Colors.white,
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 35, left: 20),
                  //     child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: Image.asset(
                  //             "lib/assets/backarrow.png",
                  //             width: 30,
                  //             height: 30,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         Spacer(),

                  //          Padding(
                  //            padding: const EdgeInsets.only(right: 10,bottom: 10),
                  //            child: ElevatedButton(
                  //                                      onPressed: () {
                  //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>viewAddress()));
                  //                                      },
                  //                                      style: ElevatedButton.styleFrom(
                  //             foregroundColor: Colors.white,
                  //             backgroundColor: Colors.black,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             fixedSize: Size(double.infinity,
                  //                 20), // Adjust the width and height as needed
                  //                                      ),
                  //                                      child: Text(
                  //             "View Address",
                  //             style: TextStyle(fontSize: 9),
                  //                                      ),
                  //                                    ),
                  //          ),

                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                                "Add Address !",
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
                                String addressText = address.text;
                                String emailText = email.text;
                                String phoneText = phone.text;
                                String pinText = pin.text;
                                String cityText = city.text;
                                String stateText = state.text;
                                String noteText = note.text;

                                if (addressText.isEmpty ||
                                    phoneText.isEmpty ||
                                    pinText.isEmpty ||
                                    emailText.isEmpty) {
                                  ScaffoldMessenger.of(scaffoldContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Please fill out all fields.'),
                                    ),
                                  );
                                  return;
                                }

                                if (!isValidEmail(emailText)) {
                                  ScaffoldMessenger.of(scaffoldContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please enter a valid email address.'),
                                    ),
                                  );
                                  return;
                                }

                                String? token = await gettokenFromPrefs();
                                if (token != null) {
                                  RegisterUserData(
                                    url,
                                    addressText,
                                    emailText,
                                    phoneText,
                                    pinText,
                                    cityText,
                                    stateText,
                                    noteText,
                                    token,
                                    scaffoldContext,
                                  );
                                } else {
                                  ScaffoldMessenger.of(scaffoldContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text('Token not found.'),
                                    ),
                                  );
                                }
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void RegisterUserData(
    String url,
    String addresss,
    String email,
    String phone,
    String pin,
    String city,
    String state,
    String note,
    String token,
    BuildContext scaffoldContext,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': '$token',
        },
        body: jsonEncode({
          "address": addresss,
          "email": email,
          "phone": phone,
          "pincode": pin,
          "city": city,
          "state": state,
          "note": note
        }),
      );
      print("===========${response.statusCode}");
      print("===========${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Registered Successfully.'),
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserAddress()));
      }
      else if(response.statusCode==500){
         ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('session Expired.'),
          ),
        );
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Page()));


      }
       else if (response.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Map<String, dynamic> data = responseData['data'];
        String errorMessage =
            data.entries.map((entry) => entry.value[0]).join('\n');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Network error. Please check your connection.'),
        ),
      );
    }
  }
}
