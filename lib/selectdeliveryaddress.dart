import 'dart:convert';
import 'package:bepocart/addaddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Select_Delivery_Address extends StatefulWidget {
  final String? user_id;

  const Select_Delivery_Address({Key? key, this.user_id}) : super(key: key);

  @override
  State<Select_Delivery_Address> createState() =>
      _Select_Delivery_AddressState();
}

class _Select_Delivery_AddressState extends State<Select_Delivery_Address> {
  String? userId;

  String fetchaddressurl =
      "https://c05e-59-92-206-153.ngrok-free.app///user-address/";

  List<Map<String, dynamic>> addressList = [];
  int selectedAddressIndex = -1;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    print("--------------------------------------------R$userId");
    fetchAddress();
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchAddress() async {
    final token = await gettokenFromPrefs();
    print("--------------------------------------------R$token");

    var response = await http.post(Uri.parse(fetchaddressurl), headers: {
      'Authorization': '$token',
    }, body: {
      'token': token,
    });

    print("FetchWishlistData status code: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      setState(() {
        addressList = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print("Failed to fetch address data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Address"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                var address = addressList[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedAddressIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: RadioListTile(
                      value: index,
                      groupValue: selectedAddressIndex,
                      onChanged: (_) {
                        setState(() {
                          selectedAddressIndex = index;
                        });
                      },
                      title: Text(address['address']),
                      subtitle: Text(
                        '${address['city']}, ${address['state']}, ${address['pincode']}, ${address['email']}, ${address['phone']}, ${address['note']}',
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),
                );
              },
            ),
          ),
      Container(
  width: double.infinity,
  margin: EdgeInsets.all(16),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // Add other widgets for adding address here
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAddress()));
        },
        
        child: Image.asset(
          'lib/assets/right-arrow.png',
          width: 30, // Adjust width as needed
          height: 30, // Adjust height as needed
        ),
      ),
    ],
  ),
),

          InkWell(
            // onTap: submitAddress,
            child: Container(
              height: 70,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: Center(
                child: Text(
                  "Save Address",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
