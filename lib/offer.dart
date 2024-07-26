import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Offer extends StatefulWidget {
  const Offer({super.key});

  @override
  State<Offer> createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  @override
  void initState() {
    super.initState();

    fetchProducts();
    fetchoffers();
  }

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> productsInOffer = [];
  final String productsurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com//products/";
  final String offersurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com//offer/";

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsurl));

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['products'];
        List<Map<String, dynamic>> productsList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://garden-tunnel-tue-episodes.trycloudflare.com/${productData['image']}";
          productsList.add({
            'id': productData['id'],
            'name': productData['name'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          products = productsList;

          // Filter the products that are present in offerProducts
          productsInOffer = products.where((product) {
            return offerProducts.contains(product['id']);
          }).toList();

        });
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
    }
  }

  List<int> offerProducts = [];

  Future<void> fetchoffers() async {
    try {
      final response = await http.get(Uri.parse(offersurl));

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

          if (productData.containsKey('offer_products') &&
              productData['offer_products'].isNotEmpty) {
            offerProducts.addAll(List<int>.from(productData['offer_products']));
          } else if (productData.containsKey('offer_category')) {
            offerCategories
                .addAll(List<int>.from(productData['offer_category']));
          }
        }

        setState(() {
          offers = productsList;
          // Store offerProducts and offerCategories in state variables if needed
         
          fetchProducts();
        });
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offer Products"),
      ),
      body: productsInOffer.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productsInOffer.length,
              itemBuilder: (context, index) {
                final product = productsInOffer[index];
                return ListTile(
                  leading: Image.network(product['image']),
                  title: Text(product['name']),
                  subtitle: Text('\$${product['salePrice']}'),
                );
              },
            ),
    );
  }
}