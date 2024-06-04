import 'package:bepocart/addaddress.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/contactus.dart';
import 'package:bepocart/editprofile.dart';
import 'package:bepocart/forgotpassword.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
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

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

   void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); 
    await prefs.remove('token'); 

    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Page()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.amber,
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'lib/assets/user.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add edit functionality here
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Add spacing between containers
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust to your needs
              children: [
                GestureDetector(
                  onTap: () {
                    // Add onTap functionality here
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
                        child: Text("Your Order"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add onTap functionality here
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          20, // Adjust width as needed
                      height: 70,
                      child: Center(
                        child: Text("Wishlist"),
                      ), // Adjust container height
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add spacing between rows
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust to your needs
              children: [
                GestureDetector(
                  onTap: () {
                    // Add onTap functionality here
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          20, // Adjust width as needed
                      height: 70,
                      child: Center(
                        child: Text("Cart"),
                      ), // Adjust container height
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add onTap functionality here
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          20, // Adjust width as needed
                      height: 70,
                      child: Center(
                        child: Text("Track Order"),
                      ), // Adjust container height
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.only(right: 220),
              child: Text(
                "Account Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
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
                                Icons.person,
                                size: 30,
                              ), // Edit Profile Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
                              Text("Edit Profile")
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
                SizedBox(
                  height: 30,
                ),
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
                              ), // Address Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=>Return_Refund_Details()));

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
                              ), // Return and Refunds Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Terms_and_conditions()));

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
                                Icons.library_books,
                                size: 30,
                              ), // Terms and Conditions Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Shipping_Policy_Details()));

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
                              ), // Shipping Policies Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
                              Text("Shipping Policies"),
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));

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
                                Icons.payment,
                                size: 30,
                              ), // Payment Methods Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
                              Text("Payment Methods"),
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>usersettings()));

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
                              Icon(Icons.settings), // Settings Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact_Us()));
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
                                Icons.help,
                                size: 30,
                              ), // Help & Support Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
                              Text("Help & Support"),
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
                SizedBox(
                  height: 30,
                ),
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
                              ), // Logout Icon
                              SizedBox(
                                  width: 10), // Add space between icon and text
                              Text("Logout"),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                          // Image.asset(
                          //   'lib/assets/right-arrow.png',
                          //   width: 30,
                          //   height: 30,
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
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
