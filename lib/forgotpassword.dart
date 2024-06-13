import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/otp.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;


class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  var url="https://sample-houston-cet-travel.trycloudflare.com/forgot-password/";
  TextEditingController email=TextEditingController();
  var emailres;


  Future<void> sendemail() async {
  try {
    var response = await http.post(
      Uri.parse(url),
      body: {"email": email.text},
    );
    if(response.statusCode==200){
      print(response.body);
       var responseData = jsonDecode(response.body);  
       print("otpppppppppppppp${responseData['email']}");
       emailres=email.text;
       
      
    }
     print(response.statusCode);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage(email:emailres)),
        );
      
    
   
  } catch (e) {
    print("erorrrrrrrrrrrrrrrr$e");
    
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                 
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
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
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Forgot Password!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Container(
                                    child: Column(
                                      children: [
                                       
                                        SizedBox(height: 15,),
                                        TextField(
                                          controller: email,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: const Color.fromARGB(255, 165, 165, 165)),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color.fromARGB(255, 170, 170, 170).withOpacity(0.5)),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color.fromARGB(255, 188, 2, 2)),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        
                                       
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                    sendemail();
                               
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                    // Navigate to Cart page
                  },
                ),
                GButton(
                  icon: Icons.search,
                  onPressed: () {
                    //  Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => search()));
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
}