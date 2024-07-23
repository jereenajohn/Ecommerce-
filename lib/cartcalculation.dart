import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class offer extends StatefulWidget {
  const offer({super.key});

  @override
  State<offer> createState() => _offerState();
}

class _offerState extends State<offer> {


  @override
  void initState() {
    super.initState();
   
    fetchProducts();
    fetchoffers();
    
  }


    List<Map<String, dynamic>> products = [];
    List<Map<String, dynamic>> offers = [];
      final String productsurl =
      "https://emails-permanent-available-risk.trycloudflare.com//products/";
       final String offersurl =
      "https://emails-permanent-available-risk.trycloudflare.com//offer/";

   Future<void> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse(productsurl));
    print('Response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final List<dynamic> productsData = parsed['products'];
      List<Map<String, dynamic>> productsList = [];

      for (var productData in productsData) {
        String imageUrl =
            "https://emails-permanent-available-risk.trycloudflare.com/${productData['image']}";
        productsList.add({
          'id': productData['id'],
          'name': productData['name'],
          'salePrice': productData['salePrice'],
          'image': imageUrl,
        });
      }

      setState(() {
        products = productsList;
        print('productsssssssssssssssssssssssssssssssssssssssss: $products');
        
        // Filter the products that are present in offerProducts
        List<Map<String, dynamic>> productsInOffer = products.where((product) {
          return offerProducts.contains(product['id']);
        }).toList();

        print('Products in Offer: $productsInOffer');
      });
    } else {
      throw Exception('Failed to load wishlist products');
    }
  } catch (error) {
    print('Error fetching wishlist products: $error');
  }
}

List<int> offerProducts = [];

Future<void> fetchoffers() async {
  try {
    final response = await http.get(Uri.parse(offersurl));
    print('Response:::::::::::::::::::::::::: ${response.body}');

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      List<Map<String, dynamic>> productsList = [];
      List<int> offerCategories = [];

      for (var productData in parsed) {
        productsList.add({
          'title': productData['name'],
          'buy': productData['buy'],
          'buy_value': productData['buy_value'],
          'get_value': productData['get_value'],
          'method': productData['method'],
          'amount': productData['amount'],
        });

        if (productData.containsKey('offer_products') && productData['offer_products'].isNotEmpty) {
          offerProducts.addAll(List<int>.from(productData['offer_products']));
        } else if (productData.containsKey('offer_category')) {
          offerCategories.addAll(List<int>.from(productData['offer_category']));
        }
      }

      setState(() {
        offers = productsList;
        // Store offerProducts and offerCategories in state variables if needed
        print('offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: $offers');
        print('Offer Products: $offerProducts');
        print('Offer Categories: $offerCategories');
        fetchProducts();
      });
    } else {
      throw Exception('Failed to load wishlist products');
    }
  } catch (error) {
    print('Error fetching wishlist products: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("haiiiiiiiiiiiiiii"),
    );
  }
}