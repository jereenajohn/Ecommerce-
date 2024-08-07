import 'dart:convert';

import 'package:bepocart/editprofile.dart';
import 'package:bepocart/forgotpassword.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/registerationpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  bool _obscureText = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  List<dynamic> data = [];

  var url = "http://51.20.129.52/login/";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 251),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                height: 150,
                width: 150,
                "lib/assets/cycling.gif"
              ),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Login Now',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 4,
                width: 160,
                color: Color.fromARGB(255, 37, 197, 28),
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30,left: 30),
                child: TextField(
                  controller: password,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgotpassword()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 22, 22, 22), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    UserLogin();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color.fromARGB(255, 37, 197, 28),),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Or",
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Sign_Up()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Color.fromARGB(255, 49, 107, 223)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> storeUserData(String userId, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('token', token);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> UserLogin() async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {"email": email.text, "password": password.text},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var status = responseData['status'];

        if (status == 'success') {
          var token = responseData['token']; // Extract token
          var userId = responseData['id'];

          await storeUserData(userId.toString(), token);

          // Navigate to HomePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          showSnackbar('Login failed: $status');
        }
      } else {
        showSnackbar('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      showSnackbar('Error: $e');
    }
  }
}
