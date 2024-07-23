import 'dart:convert';

import 'package:bepocart/loginpage.dart';
import 'package:bepocart/otp.dart';
import 'package:bepocart/otpsucesspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class changepassword extends StatefulWidget {
  var email;
  changepassword({super.key, required this.email});

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  TextEditingController newpass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  var url = "https://emails-permanent-available-risk.trycloudflare.com//change-password/";

  Future<void> change() async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          "new_password": newpass.text,
          "confirm_password": confirmpass.text,
          "email": widget.email
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("changed");
        logout();
      }
      else if(response.statusCode == 401){
         print("session expired");
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Page()));


      }
    } catch (e) {
      print("erorrrrrrrrrrrrrrrr$e");
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');
    print('logout Success');

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login_Page()));
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Change Password!",
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
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextField(
                                          controller: newpass,
                                          decoration: InputDecoration(
                                            labelText: 'New Paaword',
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
                                          controller: confirmpass,
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Paaword',
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
                                await change();
                              },
                              child: Text(
                                "Change",
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
    );
  }
}
