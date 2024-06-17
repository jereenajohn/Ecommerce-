import 'package:bepocart/contactus.dart';
import 'package:bepocart/homepage.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60.0,
              ),
              SizedBox(height: 20.0),
              Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Your order has been placed successfully. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Handle Order History tap
              //   },
              //   child: Text(
              //     'Order History',
              //     style: TextStyle(
              //       color: Colors.green,
              //       fontSize: 16.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // // SizedBox(height: 20.0),
              // // Text(
              // //   'Get delivery by Mon, 06 Feb - Thu, 09 Feb',
              // //   textAlign: TextAlign.center,
              // //   style: TextStyle(
              // //     fontSize: 16.0,
              // //   ),
              // // ),
              // SizedBox(height: 10.0),
              // GestureDetector(
              //   onTap: () {
              //     // Handle Track My Order tap
              //   },
              //   child: Text(
              //     'Track My Order',
              //     style: TextStyle(
              //       color: Colors.green,
              //       fontSize: 16.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Contact_Us()));
                },
                child: Text(
                  'Have any questions? Reach directly to our Customer Support',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
