// import 'package:bepocart/selectdeliveryaddress.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({Key? key}) : super(key: key);

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Checkout"),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 borderRadius: BorderRadius.circular(
//                     10), // Border radius for the first container
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               height: 100,
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         'lib/assets/home.png',
//                         width: 35,
//                         height: 35,
//                       ),
//                       SizedBox(width: 16),
//                       Text(
//                         'Delivery Address',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => Select_Delivery_Address()));
//                     },
//                     child: Image.asset(
//                       'lib/assets/right-arrow.png',
//                       width: 20,
//                       height: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 254, 253, 251),
//                 borderRadius: BorderRadius.circular(
//                     10), // Border radius for the second container
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               height: 100,
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         'lib/assets/wallet.png',
//                         width: 35,
//                         height: 35,
//                       ),
//                       SizedBox(width: 16),
//                       Text(
//                         'Payment',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => Select_Delivery_Address()));
//                     },
//                     child: Image.asset(
//                       'lib/assets/right-arrow.png',
//                       width: 20,
//                       height: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => CheckoutPage()));
//               },
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.black,
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Submit Order",
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
