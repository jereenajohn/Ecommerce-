import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

  class coin extends StatefulWidget {
  const coin({super.key});

  @override
  State<coin> createState() => _coinState();
}

class _coinState extends State<coin> {


 void initState() {
    super.initState();
  
    fetchCoins();
 }


  final String orders =
      "https://sr-shaped-exports-toolbar.trycloudflare.com/coin/";

        Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  List<Map<String, dynamic>> coinResults = [];
int totalcoins = 0;
double totalamount = 0;
double value = 0;

Future<void> fetchCoins() async {
  try {
    final token = await gettokenFromPrefs();

    final response = await http.get(
      Uri.parse(orders),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print("$parsed");

      // Access the 'data' field which contains the list of items
      final List<dynamic> data = parsed['data'];
      List<Map<String, dynamic>> coindatalist = [];
      var coinvalue = parsed['coinValue'];
      value = (coinvalue['value'] as num).toDouble();
      print("-VALLLLLLLLLLLLLLLLLLLL$value");

      for (var productData in data) {
        // Ensure 'amount' is parsed as an integer
        int amount = (productData['amount'] is int)
            ? productData['amount'] // If 'amount' is already an int, use it directly
            : int.parse(productData['amount'].toString()); // Otherwise, parse it to int

        coindatalist.add({
          'amount': amount,
        });
      }

      setState(() {
        coinResults = coindatalist;

        totalcoins = 0; // Initialize totalcoins to 0 before summing
        for (int i = 0; i < coinResults.length; i++) {
          print(coinResults[i]['amount']);
          totalcoins += coinResults[i]['amount'] as int; // Explicitly cast to int
        }

        totalamount = totalcoins * value; // Calculate totalamount
        print("8888888888888888888 $coinResults");
        print(totalcoins);
        print("Total amount: $totalamount");
      });
    } else {
      throw Exception('Failed to load recommended products');
    }
  } catch (error) {
    print('Error fetching recommended products: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          'BECOINS',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 73, 134),
                            const Color.fromARGB(255, 255, 255, 255)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Optional: Add some padding for better layout
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Text(
                                  'Total Coins',
                                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                                ),
                                Text(
                                  '$totalcoins',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = LinearGradient(
                                      colors: [
                                        Color.fromARGB(232, 255, 255, 255),
                                        Color.fromARGB(255, 247, 188, 71)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                  ),
                                ),
                                SizedBox(height: 10,),

                                 Text(
                                  'Total Amount: $totalamount',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = LinearGradient(
                                      colors: [
                                        Color.fromARGB(232, 255, 255, 255),
                                        Color.fromARGB(255, 247, 188, 71)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                  ),
                                ),

                                
                              ],
                            ),
                            Spacer(),
                            Image.asset(
                              'lib/assets/coin.png',
                              width: 115,
                              height: 115,
                              color: Colors.white, // Apply a white color filter to make it blend with the gradient
                              colorBlendMode: BlendMode.modulate, // Blend mode for applying color
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}