import 'dart:convert';

import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sign_Up extends StatefulWidget {
  const Sign_Up({Key? key}) : super(key: key);

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  var url =
      "https://reliance-appropriations-capital-information.trycloudflare.com/register/";
  bool _obscureText = true;

  var userId;

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController zipcode = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 4,
                    width: 160,
                    color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: firstname,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: lastname,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                                     SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                                     SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                                     SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: place,
                      decoration: InputDecoration(
                        labelText: 'Place',
                        hintText: 'Enter Place',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                                     SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: zipcode,
                      decoration: InputDecoration(
                        labelText: 'Zipcode',
                        hintText: 'Enter Zipcode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                                     SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
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
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        RegisterUserData(
                          url,
                          firstname.text,
                          lastname.text,
                          int.tryParse(phone.text) ?? 0,
                          email.text,
                          place.text,
                          int.tryParse(zipcode.text) ?? 0,
                          password.text,
                          scaffoldContext,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
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

  void RegisterUserData(
    String url,
    String firstname,
    String lastname,
    int phone,
    String email,
    String place,
    int zipcode,
    String password,
    BuildContext scaffoldContext,
  ) async {
    if (firstname.isEmpty ||
        lastname.isEmpty ||
        phone == 0 ||
        email.isEmpty ||
        place.isEmpty ||
        zipcode ==0 ||
        password.isEmpty) {
      // Show SnackBar if any field is empty
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields.'),
        ),
      );
      return;
    }

    if (!isValidEmail(email)) {
      // Show SnackBar for invalid email address
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "image": null,
            "first_name": firstname,
            "last_name": lastname,
            "email": email,
            "phone": phone,
            "place": place,
            "zip_code": zipcode,
            "password": password
          }));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Registered Successfully.'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login_Page()),
        );
      } else if (response.statusCode == 400) {
        // Show alert box for validation errors
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

      Map<String, dynamic> responseData = jsonDecode(response.body);
      userId = responseData['data']['id'];
      print('User ID is $userId');
    } catch (e) {
      print("Error: $e");
      // Show SnackBar for network error
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Network error. Please check your connection.'),
        ),
      );
    }
  }

  bool isValidEmail(String email) {
    // Simple email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
