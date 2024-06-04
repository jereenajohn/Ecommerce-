import 'dart:convert';
import 'dart:io';

import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String? userId;
  EditProfile({Key? key, this.userId}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var url = "https://c36a-59-92-192-37.ngrok-free.app//profile/";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<void> updateprofile() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$url'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'username': name.text,
            'email': email.text,
            'phone': phone.text,
          },
        ),
      );

      print("Response: $response");

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
      } else {
        print('Failed to update profile: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
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

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            children: [
                              Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                                        TextField(
                                          controller: name,
                                          decoration: InputDecoration(
                                            labelText: 'Username',
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
                                        TextField(
                                          controller: phone,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
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
                                updateprofile();
                              },
                              child: Text(
                                "Update",
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
