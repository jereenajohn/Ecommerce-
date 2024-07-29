import 'dart:convert';

import 'package:bepocart/addaddress.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/coin_page.dart';
import 'package:bepocart/contactus.dart';
import 'package:bepocart/editprofile.dart';
import 'package:bepocart/forgotpassword.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/myorders.dart';
import 'package:bepocart/returnandrefundsdetails.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/settings.dart';
import 'package:bepocart/shippingpolicy.dart';
import 'package:bepocart/termsandconditions.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class UserProfilePage extends StatefulWidget {
    final String? user_id; // Receive user_id as a parameter

  UserProfilePage({Key? key, this.user_id}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
    String? userId; // Declare userId variable to store user ID

  var tokenn;
  @override
   void initState() {
    super.initState();
     _initData();
    getprofiledata();
     getimage();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();


    // Use userId after getting the value
  }
   Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
var userimage;
            String imageUrl='';
  Future<void> getimage() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.post(
        Uri.parse(viewimage),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        userimage = jsonDecode(response.body);

        setState(() {

            imageUrl =
              "${userimage['image']}";
        });
      } else {
      }
    } catch (error) {
    }
  }

   void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); 
    await prefs.remove('token'); 

    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }

   Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

var userdata;

var username="";
var email="";
var phone="";
var viewprofileurl =
      "http://51.20.129.52/profile-view/";
      var viewimage =
      "http://51.20.129.52/profile-image/";
  Future<void> getprofiledata() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.get(
        Uri.parse('$viewprofileurl'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

    

      if (response.statusCode == 200) {
        // userdata = jsonDecode(response.body);
         final parsed = jsonDecode(response.body);
        var productsData = parsed['data'];
      
            setState(() {
              username=productsData['first_name'];
              email=productsData['email'];
              phone=productsData['phone'];
             

            });

      } else {
      }
    } catch (error) {
}
}
  @override
  Widget build(BuildContext context) {
      String imageUrl =
        userimage != null && userimage['image'] != null && userimage['image'].isNotEmpty
            ? "${userimage['image']}"
            : '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: imageUrl.isNotEmpty
                        ? ClipOval(
  child: Image.network(
    imageUrl,
    width:75,
    height: 75,
    fit: BoxFit.cover, // Ensure the image covers the circle
  ),
)

                        : Image.asset(
                            'lib/assets/user.png',
                            width: 70,
                            height: 70,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$username",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 3),
                        Text("$email"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditProfile()));
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyOrder()));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 70,
                      child: Center(
                        child: Text("MY ORDERS",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Wishlist()));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 70,
                      child: Center(
                        child: Text("WISHLIST",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Cart()));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 70,
                      child: Center(
                        child: Text("CART",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>coin()));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 70,
                      child: Center(
                        child: Text("BECOINS",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Account Settings",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserAddress()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Address"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Return_Refund_Details()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Return and Refunds"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Shipping_Policy_Details()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.local_shipping,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Shipping Policy"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Terms_and_conditions()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.description,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Terms and Conditions"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Contact_Us()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Contact Us"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => usersettings()));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.settings,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Settings"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),


                GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text("Logout"),
                            ],
                          ),
                          Image.asset(
                            'lib/assets/right-arrow.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
