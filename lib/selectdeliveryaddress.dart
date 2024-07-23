// import 'dart:convert';
// import 'package:bepocart/addaddress.dart';
// import 'package:bepocart/address2.dart';
// import 'package:bepocart/orderpage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Select_Delivery_Address extends StatefulWidget {
//   final String? user_id;
  

//   const Select_Delivery_Address({Key? key, this.user_id}) : super(key: key);

//   @override
//   State<Select_Delivery_Address> createState() =>
//       _Select_Delivery_AddressState();
// }

// class _Select_Delivery_AddressState extends State<Select_Delivery_Address> {
//   String? userId;
//   String fetchaddressurl =
//       "https://emails-permanent-available-risk.trycloudflare.com//get-address/";
//   List<Map<String, dynamic>> addressList = [];
//    Map<String, dynamic>? selectedAddress;

//   int selectedAddressIndex = -1; 
//   var selectedAddressId;
//   var selectedAddressname;
//   var selectedAddressemail;
//   var selectedAddressphone;
//   var selectedAddresspincode;
//   var selectedAddresscity;
//   var selectedAddressstate;
//   var selectedAddressnote;
//   var selectedAddressuserid;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     userId = await getUserIdFromPrefs();
//     print("--------------------------------------------R$userId");
//     fetchAddress();
//   }

//   Future<String?> getUserIdFromPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId');
//   }

//   Future<String?> gettokenFromPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> fetchAddress() async {
//     final token = await gettokenFromPrefs();
//     print("--------------------------------------------R$token");

//     var response = await http.get(Uri.parse(fetchaddressurl), headers: {
//       'Authorization': '$token',
//     },);

//     print("Fetch address: ${response.body}");

//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       var data = responseData['address'];

//       setState(() {
//         addressList = List<Map<String, dynamic>>.from(data);
//       });
//     } else {
//       print("Failed to fetch address data");
//     }
//   }


//    void showAddressBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return ListView(
//               children: addressList.map((address) {
//                 return RadioListTile<Map<String, dynamic>>(
//                   title: Text(address['address']),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('City: ${address['city']}'),
//                       Text('State: ${address['state']}'),
//                       Text('Pincode: ${address['pincode']}'),
//                       Text('Phone: ${address['phone']}'),
//                       Text('Email: ${address['email']}'),
//                     ],
//                   ),
//                   value: address,
//                   groupValue: selectedAddress,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedAddress = value;
//                     });
//                     this.setState(() {
//                       selectedAddress = value;
//                     });
//                     Navigator.pop(context);
//                   },
//                 );
//               }).toList(),
//             );
//           },
//         );
//       },
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Delivery Address"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: addressList.length,
//               itemBuilder: (context, index) {
//                 var address = addressList[index];
//                 print(address);
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       selectedAddressIndex = index;
//                       selectedAddressId =
//                           address['id']; // Store the selected address ID
//                       print("Selected address ID: $selectedAddressId");
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: RadioListTile(
//                       value: index,
//                       groupValue: selectedAddressIndex,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedAddressIndex = index;
//                           selectedAddressId =
//                               address['id']; // Store the selected address ID
//                           selectedAddressname = address['address'];
//                           selectedAddresscity = address['city'];
//                           selectedAddressstate = address['state'];
//                           selectedAddresspincode = address['phone'];
//                           selectedAddressnote = address['note'];
//                           selectedAddressuserid = address['user'];

//                           selectedAddressphone = address['pincode'];

//                           selectedAddressemail = address['email'];

//                           print("Selected address ID: $selectedAddressId");
//                           print("Selected address name: $selectedAddressname");
//                         });
//                       },
//                       title: Text(address['address']),
//                       subtitle: Text(
//                         '${address['city']}, ${address['state']}, ${address['pincode']}, ${address['email']}, ${address['phone']}, ${address['note']}',
//                       ),
//                       controlAffinity: ListTileControlAffinity.trailing,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             margin: EdgeInsets.all(16),
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Add Address",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       // Add other widgets for adding address here
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => UserAddress2()),
//                     );
//                   },
//                   child: Image.asset(
//                     'lib/assets/right-arrow.png',
//                     width: 30, // Adjust width as needed
//                     height: 30, // Adjust height as needed
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             // onTap: submitAddress, // Add your submit address logic here
//             child: GestureDetector(
//               onTap: () {
//                 if (selectedAddressIndex == -1) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: Colors.red,
//                       content: Text('Please select an address first'),
//                     ),
//                   );
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => order(
//                             // addressid: selectedAddressId,
//                             // name: selectedAddressname,
//                             // city: selectedAddresscity,
//                             // state: selectedAddressstate,
//                             // pincode: selectedAddresspincode,
//                             // number: selectedAddressphone,
//                             // email: selectedAddressemail,
//                             // note: selectedAddressnote,
//                             // userid: selectedAddressuserid,
                          
//                             )),
//                   );
//                 }
//               },
//               child: Container(
//                 height: 70,
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16),
//                 color: Colors.black,
//                 child: Center(
//                   child: Text(
//                     "Save Address",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
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
