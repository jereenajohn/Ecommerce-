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
      "http://51.20.129.52/register/";
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
              padding: const EdgeInsets.only(top: 100),
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
                    color:  Color.fromARGB(255, 37, 197, 28),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  SizedBox(height: 10),
                 Center(
                   child: Padding(
                     padding: const EdgeInsets.only(left: 20, right: 20),
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                       child: TextField(
                         controller: firstname,
                         decoration: InputDecoration(
                           labelText: 'First Name',
                           hintText: 'Enter First Name',
                            labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                            hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                         ),
                       ),
                     ),
                   ),
                 ),

                  

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                       width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                      child: TextField(
                        
                        controller: lastname,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          hintText: 'Enter Last Name',
                           labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                          hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                        ),
                      ),
                    ),
                  ),
                                 

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width

                      child: TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter Phone Number',
                           labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                           hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                        ),
                      ),
                    ),
                  ),
                                

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                                             width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width

                      child: TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email Address',
                          
                          labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                          hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                        ),
                      ),
                    ),
                  ),
                                  

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                                             width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width

                      child: TextField(
                        controller: place,
                        decoration: InputDecoration(
                          labelText: 'Place',
                          hintText: 'Enter Place',
                           labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                           hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                        ),
                      ),
                    ),
                  ),
                                    

                 Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: Container(
    width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
    child: TextField(
      controller: zipcode,
      decoration: InputDecoration(
        labelText: 'Zipcode',
        hintText: 'Enter Zipcode',
         labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
        hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
      ),
    ),
  ),
),

                                 

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                                             width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width

                      child: TextField(
                        controller: password,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                           labelStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
        ),
                           hintStyle: TextStyle(
          fontSize: 12, // Set the desired font size here
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
                  ),
                  SizedBox(
                    height: 30,
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
                            MaterialStateProperty.all<Color>( Color.fromARGB(255, 37, 197, 28)),
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
                    "If You Already Have An Account? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login_Page()));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Color.fromARGB(255, 49, 107, 223)),
                    ),
                  ),
                ],
              )
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
    } catch (e) {
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
