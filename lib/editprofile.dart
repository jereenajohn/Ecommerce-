import 'dart:convert';
import 'dart:io';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class EditProfile extends StatefulWidget {
  final String? userId;
  EditProfile({Key? key, this.userId}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    getprofiledata();
  }

  var url =
      "https://reliance-appropriations-capital-information.trycloudflare.com/profile/";
  var url2 =
      "https://reliance-appropriations-capital-information.trycloudflare.com/profile-image/";
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController zip_code = TextEditingController();
  var tokkenn;

  var userdata;

  var viewprofileurl =
      "https://reliance-appropriations-capital-information.trycloudflare.com/profile-view/";
  Future<void> getprofiledata() async {
    print("jvnxsssssssssssssssssssssssssssssssssssssss");
    try {
      final token = await gettokenFromPrefs();

      var response = await http.get(
        Uri.parse('$viewprofileurl'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      print(
          "Responserrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee: ${response.body}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        var productsData = parsed['data'];
        print("999999999999999999999999999${productsData['first_name']}");
        setState(() {
          first_name.text = productsData['first_name'];
          last_name.text = productsData['last_name'];
          email.text = productsData['email'];
          phone.text = productsData['phone'];
          place.text = productsData['place'];
          zip_code.text = productsData['zip_code'];

          print(
              "ttttttttttttthhhhhhhhhhhhhhhaaaaaaaaaallllllllllaaaaaaaaaaaaaaaa$first_name");
        });

        print('Profile data fetched successfully');
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  Future<void> updateprofile() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$url'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'first_name': first_name.text,
            'last_name': last_name.text,
            'email': email.text,
            'phone': phone.text,
            'place': place.text,
            'zip_code': zip_code.text,
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
                            children: [
                              Text(
                                "Edit Profile",
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
                                        TextField(
                                          controller: first_name,
                                          decoration: InputDecoration(
                                            labelText: 'First Name',
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
                                          controller: last_name,
                                          decoration: InputDecoration(
                                            labelText: 'Last Name',
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
                                          controller: email,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
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
                                          controller: phone,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
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
                                          controller: place,
                                          decoration: InputDecoration(
                                            labelText: 'place',
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
                                          controller: zip_code,
                                          decoration: InputDecoration(
                                            labelText: 'Zip Code',
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
                                        GestureDetector(
                                          onTap: () {
                                            imageSelect();
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color.fromARGB(
                                                  255, 224, 223, 223),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'lib/assets/upload.png', // Replace 'upload_icon.png' with your image asset path
                                                  width:
                                                      24, // Adjust the width of the image
                                                  height:
                                                      24, // Adjust the height of the image
                                                  color: Color.fromARGB(
                                                      255,
                                                      2,
                                                      2,
                                                      2), // Adjust the color of the image
                                                ),
                                                SizedBox(
                                                    width:
                                                        10), // Spacer between icon and text
                                                Text(
                                                  "Select Image",
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              116,
                                                              116,
                                                              116)),
                                                ),
                                              ],
                                            ),
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
                                updateprofile();

                                tokkenn = await gettokenFromPrefs();
                                RegisterUserData(url2, selectedImage,
                                    scaffoldContext, tokkenn!);
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

  File? selectedImage;

  void imageSelect() async {
    try {
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkk");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          selectedImage = File(result.files.single.path!);
          print("================$selectedImage");
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("image1 selected successfully."),
          backgroundColor: Color.fromARGB(173, 120, 249, 126),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error while selecting the file."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void RegisterUserData(
    String url,
    File? image1,
    BuildContext scaffoldContext,
    String token,
  ) async {
    try {
      print("00000000000000000000000000000000000$token");
      print(
          "imageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$image1");
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // Add headers to the request
      request.headers['Content-type'] = 'application/json';
      request.headers['Authorization'] = '$token';

      if (image1 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image1.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(
          "statttttttttttttttttttsssssssssssssssssssssssttttttttt${response.body}");

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Registration successful
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Data Added Successfully.'),
          ),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => add_product()),
        // );
      } else if (response.statusCode == 400) {
        // Handle validation errors or other specific errors from the server
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('image2') &&
            responseData.containsKey('image3')) {
          // Show error dialog for specific image validation errors
        } else {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(
              content: Text('Something went wrong. Please try again later.'),
            ),
          );
        }
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      // Handle network errors or exceptions
      print("Error: $e");
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Network error. Please check your connection.'),
        ),
      );
    }
  }
}
