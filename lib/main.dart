import 'package:bepocart/loginpage.dart';
import 'package:bepocart/registerationpage.dart';
import 'package:bepocart/waitingpagebeforelogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homepage.dart'; // Import your HomePage widget here

void main() {
  runApp(Bepocart());
}

class Bepocart extends StatelessWidget {
  const Bepocart({Key? key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(255, 255, 255, 255), // Set your desired color here
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
