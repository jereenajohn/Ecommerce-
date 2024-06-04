import 'dart:convert';

import 'package:bepocart/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class resetpassword extends StatefulWidget {
  const resetpassword({super.key});

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  TextEditingController pass=TextEditingController();
    TextEditingController newpass1=TextEditingController();

  TextEditingController newpass2=TextEditingController();
    var url = "https://c36a-59-92-192-37.ngrok-free.app/user-password-reset/";


  Future<void> resetpassword() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'old_password': pass.text,
            'new_password': newpass1.text,
            'retype_password': newpass2.text,
          },
        ),
      );

      print("Response: $response");

      if (response.statusCode == 200) {
        print('Password reset successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset successfully'),
            duration: Duration(seconds: 2),
          ),
        );

       logout();
      } else {
        print('Failed to Reset Password: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Reset Password'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
   void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); 
    await prefs.remove('token'); 
    print('logout Success');

    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Page()));
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
                              Text("Reset Password!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                                          controller: pass,
                                          decoration: InputDecoration(
                                            labelText: 'Current Password',
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
                                          TextField(
                                          controller: newpass1,
                                          decoration: InputDecoration(
                                            labelText: 'New Password',
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
                                          TextField(
                                          controller: newpass2,
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password',
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
                                resetpassword();
                               
                              },
                              child: Text(
                                "Reset",
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
    );
  }
}