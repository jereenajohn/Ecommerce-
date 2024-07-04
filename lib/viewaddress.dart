import 'dart:convert';
import 'dart:io';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/updateaddress.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class viewAddress extends StatefulWidget {
  final String? userId;
  viewAddress({Key? key, this.userId}) : super(key: key);

  @override
  State<viewAddress> createState() => _viewAddressState();
}

class _viewAddressState extends State<viewAddress> {
  var tokenn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _initData();
    fetchAddress();
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    // Use userId after getting the value
  }

  String durl =
      "https://med-champions-assisted-written.trycloudflare.com//delete-address/";

  String url = "https://med-champions-assisted-written.trycloudflare.com//get-address/";
  List<Map<String, dynamic>> address = [];

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
        title: Text("Address"),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                 
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: addressList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> addressData = addressList[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Container(
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 205, 204, 204)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(addressData['address'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(addressData['email'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(addressData['phone'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(addressData['city'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(addressData['state'] ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child:
                                      Text(addressData['pincode'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //  ElevatedButton(
                                      //                            onPressed: () {
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateAddress(id:addressData['id'])));
                                      //                            },
                                      //                            style: ElevatedButton.styleFrom(
                                      //   foregroundColor: Colors.white,
                                      //   backgroundColor: Colors.black,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      //   fixedSize: Size(double.infinity,
                                      //       20), // Adjust the width and height as needed
                                      //                            ),
                                      //                            child: Text(
                                      //   "Edit",
                                      //   style: TextStyle(fontSize: 9),
                                      //                            ),

                                      //                          ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateAddress(
                                                          id: addressData[
                                                              'id'])));
                                        },
                                        child: Image.asset(
                                                        "lib/assets/edit.jpg",

                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,  
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          deleteaddress(addressData['id']);
                                          removeProduct(index);
                                        },
                                        child: Image.asset(
                                          "lib/assets/delete.gif",
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      // return ListTile(
                      //   title: Text(addressData['state'] ?? ''),
                      //   subtitle: Text(addressData['address'] ?? ''),
                      // );
                    },
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()));
                  // Navigate to Profile page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteaddress(int Id) async {
    final token = await gettokenFromPrefs();
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG$token");

    try {
      final response = await http.delete(
        Uri.parse('$durl$Id/'),
        headers: {
          'Authorization': '$token',
        },
      );
      print("uuuuuuuuuuuuuuuuuuuuuuuuuu");
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 204) {
        print('Wishlist ID deleted successfully: $Id');
      } else {
        throw Exception('Failed to delete wishlist ID: $Id');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void removeProduct(int index) {
    setState(() {
      addressList.removeAt(index);
    });
  }
}
