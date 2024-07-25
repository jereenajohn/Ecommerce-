import 'dart:convert';
import 'dart:ffi';

import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/orderpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/selectdeliveryaddress.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final String? user_id;

  const Cart({Key? key, this.user_id}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? userId;
  List<dynamic> cartProductIds = [];
  List<dynamic> productIds = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cartProducts = [];
  List<dynamic> quantities = [];
  List<dynamic> productPrice = [];

  List<dynamic> pages = [HomePage(), Cart(), UserProfilePage()];

  int _selectedIndex = 0;
  var tokenn;

  var CartUrl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/cart-products/";
  final String productsurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/products/";

  final quantityincrementurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/cart/increment/";

  final quantitydecrementurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/cart/decrement/";

  final deletecarturl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/cart-delete/";

  @override
  void initState() {
    _initData();

    super.initState();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();
    print("--------------------------------------------R$userId");

    fetchCartData();
    fetchoffers();
    calculateTotalPrice();
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  var option = false;
  var total;
  // void optionselect() {

  //   print("OOOOOOOOooooooooooooooooooooooooooooo$total");
  //   for (int i = 0; i < cartProducts.length; i++) {
  //     if (cartProducts[i]['offer_type'] == "BUY 1 GET 1" ||
  //         cartProducts[i]['offer_type'] == "BUY 2 GET 1") {
  //       option = true;
  //     } else {
  //       option = false;
  //     }
  //   }
  // }

  Future<void> fetchCartData() async {
    print("Fetching cart data...");
    try {
      final token = await gettokenFromPrefs();
      // print("Token: $token");

      final response = await http.get(
        Uri.parse(CartUrl),
        headers: {
          'Authorization': '$token',
        },
      );

      print(
          "ResponseEWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW: ${response.body}");
      // print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        // print("AAAAAAAAAAAA AAAAAAAAAAHHHHHHHHHHHDEEEEEEEEEEEEEEEEEEEEE$data");

        List<Map<String, dynamic>> cartItems = [];

        for (var item in data) {
          String imageUrl =
              "https://garden-tunnel-tue-episodes.trycloudflare.com/${item['image']}";

          cartItems.add({
            'id': item['id'],
            'productId': item['product'],
            'mainCategory': item['mainCategory'],
            'quantity': item['quantity'],
            'actualprice': item['price'],
            'price': item['salePrice'],
            'name': item['name'],
            'image': imageUrl,
            'color': item['color'],
            'size': item['size'],
            'offer_type': item['offer_type'],
            'stock': item['stock'],
            'has_offer': item['has_offer'],
            'discount_product': item['discount_product']

            // Update with correct price value
          });
        }

        setState(() {
          cartProducts = cartItems;

          for (int i = 0; i < cartProducts.length; i++) {
            if (cartProducts[i]['offer_type'] == "BUY 1 GET 1" ||
                cartProducts[i]['offer_type'] == "BUY 2 GET 1") {
              option = true;
              break;
            } else {
              option = false;
              print(option);
            }
          }
        });
        // print(cartProducts.length);
        print("cccccccccccccccccccccccCart Products: $cartProducts");
      } else if (response.statusCode == 401) {
        final responseData = jsonDecode(response.body);
        final data = responseData['message'];
        if (data == "Token has expired") {
          print("Token has expired");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login_Page()));
        }
      } else {
        print("Failed to fetch cart data");
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }

  Future<void> incrementquantity(int cartProductId, int newQuantity) async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$quantityincrementurl$cartProductId/'),
        headers: {'Authorization': '$token'},
        body: jsonEncode({'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        print('Quantity updated successfully');

        setState(() {
          fetchCartData();
          calculateTotalPrice();
        });
      } else {
        print('Failed to update quantity: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }

  Future<void> Decrementquantity(int cartProductId, int newQuantity) async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.put(
        Uri.parse('$quantitydecrementurl$cartProductId/'),
        headers: {'Authorization': '$token'},
        body: jsonEncode({'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        print('Quantity updated successfully');
        setState(() {
          calculateTotalPrice();
          fetchCartData();
        });
      } else {
        print('Failed to update quantity: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }

  Future<void> deleteCartProduct(int cartProductId) async {
    final token = await gettokenFromPrefs();

    try {
      final response = await http.delete(
        Uri.parse('$deletecarturl$cartProductId/'),
      );
      print(
          "Response status codeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 204) {
        print('cart ID deleted successfully: $cartProductId');
      } else {
        throw Exception('Failed to delete cart ID: $cartProductId');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void removeProduct(int index) {
    setState(() {
      cartProducts.removeAt(index);
    });
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Future<String?> gettokenFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }
  var Dquantity;

  List<int> offerProducts = [];
  List<Map<String, dynamic>> offers = [];
  final String offersurl =
      "https://garden-tunnel-tue-episodes.trycloudflare.com/offer/";

  var bogo;
  bool is_active = false;
  Future<void> fetchoffers() async {
    try {
      final response = await http.get(Uri.parse(offersurl));
      // print('Response:::::::::::::::::::::::::: ${response.body}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);

        List<Map<String, dynamic>> productsList = [];
        List<int> offerCategories = [];

        for (var productData in parsed) {
          if (productData['offer_active'] == true) {
            productsList.add({
              'id': productData['id'],
              'title': productData['name'],
              'buy': productData['buy'],
              'offer_type': productData['offer_type'],
              'get_option': productData['get_option'],
              'get_value': productData['get_value'],
              'method': productData['method'],
              'amount': productData['amount'],
              'is_active': productData['is_active'],
            });

            if (productData.containsKey('offer_products') &&
                productData['offer_products'].isNotEmpty) {
              offerProducts
                  .addAll(List<int>.from(productData['offer_products']));
            } else if (productData.containsKey('offer_category')) {
              offerCategories
                  .addAll(List<int>.from(productData['offer_category']));
            }
          }
        }

        setState(() {
          offers = productsList;
          // Store offerProducts and offerCategories in state variables if needed
          print('offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: $offers');
          // print('Offer Products: $offerProducts');
          // print('Offer Categories: $offerCategories');
          // for(int i=0;i<offers.length;i++){

          if (offers[0]['offer_type'] == "BUY") {
            print("*${offers[0]['get_option']}");
            if (offers[0]['get_option'] == 1) {
              bogo = "BUY 1 GET 1";
              // print("bogooooooooooooooooooooooooooo:::$bogo");
            } else if (offers[0]['get_option'] == 2) {
              bogo = "BUY 2 GET 1";
            }
            if (offers[0]['is_active'] == "true") {
              is_active = true;
              // print("is_activeeeeeeeeeeeeeeeeeeeee:::$is_active");
            } else {
              is_active = false;
              // print("is_activeeeeeeeeeeeeeeeeeeeee:::$is_active");
            }

            // }
          }
        });
      } else {
        throw Exception('Failed to load offer products');
      }
    } catch (error) {
      print('Error fetching offer products: $error');
    }
  }

  bool hasOfferAppliedNormalProduct = false;
  bool hasBothOfferAndDiscount = false;
  bool onlyDiscountAllowedAndNormal = true;
  bool offernotdiscount = false;
  bool notofferdiscount1 = false;
  bool notofferdiscount2 = false;

  int discount_product_quantity = 0;
  bool offeronly = true;

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    double? leastPrice;
    int offerProductCount = 0;
    int offeronlycount = 0;

    int quat = 0;
    setState(() {
      if (is_active == 'true') {
        for (int i = 0; i < cartProducts.length; i++) {
          double price = double.parse(cartProducts[i]['price']);
          int quantity = cartProducts[i]['quantity'] ?? 1;

          totalPrice += price * quantity;
        }
      } else {
        // print(is_active);
        for (int i = 0; i < cartProducts.length; i++) {
          double price = double.parse(cartProducts[i]['price']);
          int quantity = cartProducts[i]['quantity'] ?? 1;

          // Add price to total price
          totalPrice += price * quantity;

          // Check if this product has an offer
          String? discountapplicable = cartProducts[i]['discount_product'];
          String? has_offer = cartProducts[i]['has_offer'];
          if (has_offer == "Offer Applied") {
            // Count the offer products
            offerProductCount += quantity;
            print(
                "offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrproductttttttttttttCCCCCountTTTTTTTTTTT:$offerProductCount");
            offeronly = true;
            print("offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrr:$offeronly");
          } else {
            offeronly = false;
          }

          if (discountapplicable == "Discount Allowed") {
            // Determine the least priced offer product
            if (leastPrice == null || price < leastPrice!) {
              leastPrice = price;
              print(
                  "leastttttttttttttttttttttttttttttttttttttttttttttttttt$leastPrice");

              Dquantity = quantity;
              print("Quantity of least price product: $Dquantity");
            }
          }
        }
/////////////////////////////////////////////////

        // print(is_active);
        for (int i = 0; i < cartProducts.length; i++) {
          int quantity = cartProducts[i]['quantity'] ?? 1;

          // Check if this product has an offer
          String? discountapplicable = cartProducts[i]['discount_product'];
          String? has_offer = cartProducts[i]['has_offer'];
          if (has_offer == "Offer Applied" && discountapplicable == "normal") {
            // Count the offer products
            offeronlycount += quantity;
            print(
                "OOOOOOOONNNNNNNNNNNNLLLYYYYYYYYYYYrproductttttttttttttCCCCCountTTTTTTTTTTT:$offeronlycount");
            offeronly = true;
            print("offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrr:$offeronly");
          }
        }
// Adjust the total price based on the offer type
        if (leastPrice != null) {
          for (int i = 0; i < cartProducts.length; i++) {
            String? offerType = cartProducts[i]['offer_type'];

            if (bogo == "BUY 1 GET 1") {
              print(
                  "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
              int freeItems = 0; // Default calculation
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                if (has_offer == "Offer Applied" &&
                    discountapplicable == "normal") {
                  print(
                      "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
                  hasOfferAppliedNormalProduct = true;
                } else {
                  hasOfferAppliedNormalProduct = false;
                  break;
                }
              }
              print(
                  "hasBothOfferAndDiscounttttttttttttttttttttttttttttttttttttttttttt$hasBothOfferAndDiscount");
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];

                if (discountapplicable == "Discount Allowed") {
                  discount_product_quantity = cartProducts[i]['quantity'] ?? 0;
                  quat += discount_product_quantity;
                }
              }
              print("discount_product_quantity==================$quat");

              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                int discount_product_quantity =
                    cartProducts[i]['quantity'] ?? 0;

                if (has_offer == "Offer Not Applicable" &&
                    discountapplicable == "Discount Allowed") {
                  onlyDiscountAllowedAndNormal = true;
                } else {
                  onlyDiscountAllowedAndNormal = false;
                  break;
                }
              }
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                int discount_product_quantity =
                    cartProducts[i]['quantity'] ?? 0;
                if (has_offer == "Offer Applied" &&
                    discountapplicable == "normal") {
                  offernotdiscount = true;
                } else {
                  notofferdiscount1 = true;
                }
              }
// Determine free items based on the conditions
              if (hasOfferAppliedNormalProduct) {
                print("offeerrrrrrrrrrrrronnlyyyyyyy");
                freeItems = 0;
              } else if (onlyDiscountAllowedAndNormal) {
                print("discountnlyyyyyyyyyyyyyyyyyyyyy");
                freeItems = 0;
              } else if (offernotdiscount == true &&
                  notofferdiscount1 == true) {
                print("offernotdiscount$quat");
                if (quat < offerProductCount) {
                  freeItems = quat;
                  print(
                      "1111111===freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                } else if (offerProductCount <= quat) {
                  freeItems = offerProductCount;
                  print(
                      "22222222==============freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                } else {
                  print(
                      "freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                }
              } else {
                freeItems = offerProductCount ~/ 2;
              }

              print("Total free items: $freeItems");
              // For "BUY 1 GET 1", each pair gets one free
              while (freeItems > 0) {
                print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
                int dQuantity = Dquantity ?? 0;

                if (freeItems >= dQuantity) {
                  totalPrice -= (leastPrice! * dQuantity);
                  freeItems -= dQuantity;
                  print(
                      "Total after reduction: $totalPrice, remaining free items: $freeItems");

                  // Find the next least priced product with the same offer
                  double? nextLeastPrice;
                  int nextDquantity = 0;
                  for (int j = 0; j < cartProducts.length; j++) {
                    double price = double.parse(cartProducts[j]['price']);
                    // String? nextOfferType = cartProducts[j]['offer_type'];
                    if ((nextLeastPrice == null || price < nextLeastPrice) &&
                        (bogo == "BUY 1 GET 1" || bogo == "BUY 2 GET 1") &&
                        price > leastPrice!) {
                      nextLeastPrice = price;
                      nextDquantity = cartProducts[j]['quantity'] ?? 1;
                    }
                  }

                  if (nextLeastPrice == null)
                    break; // No more lower priced products

                  leastPrice = nextLeastPrice;
                  Dquantity = nextDquantity;
                } else {
                  totalPrice -= (leastPrice! * freeItems);
                  freeItems = 0;
                  print("Total after final reduction: $totalPrice");
                }
              }
              break; // Exit the loop after processing the first offer type "BUY 1 GET 1"
            } else if (bogo == "BUY 2 GET 1") {
              // For "BUY 2 GET 1", every three items, one is free
              var freeItems;

              print(
                  "2222222222222222222======================1111111111111111111111111111111");

              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                if (has_offer == "Offer Applied" &&
                    discountapplicable == "normal") {
                  print(
                      "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
                  hasOfferAppliedNormalProduct = true;
                } else {
                  hasOfferAppliedNormalProduct = false;
                  break;
                }
              }

              print(
                  "hasBothOfferAndDiscounttttttttttttttttttttttttttttttttttttttttttt$hasOfferAppliedNormalProduct");
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];

                if (discountapplicable == "Discount Allowed") {
                  discount_product_quantity = cartProducts[i]['quantity'] ?? 0;
                  quat += discount_product_quantity;
                }
              }
              print("discount_product_quantity==================$quat");

              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                int discount_product_quantity =
                    cartProducts[i]['quantity'] ?? 0;

                if (has_offer == "Offer Not Applicable" &&
                    discountapplicable == "Discount Allowed") {
                  onlyDiscountAllowedAndNormal = true;
                  print(
                      "discountonlyyyyyyyyyyyyyyyyyyyyyyiffffffffffffffffffffffffffffffff");
                } else {
                  onlyDiscountAllowedAndNormal = false;
                  print(
                      "discountonlyyyyyyyyyyyyyyyyyyyyyyiffffffffffffffffffffffffffffffff$onlyDiscountAllowedAndNormal");

                  break;
                }
              }
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
                String? has_offer = cartProducts[i]['has_offer'];
                int discount_product_quantity =
                    cartProducts[i]['quantity'] ?? 0;
                if (has_offer == "Offer Applied" &&
                    discountapplicable == "normal") {
                  offernotdiscount = true;
                } else if (has_offer == "Offer Not Applicable" &&
                    discountapplicable == "Discount Allowed") {
                  notofferdiscount1 = true;
                } else if (has_offer == "Offer Applied" &&
                    discountapplicable == "Discount Allowed") {
                  notofferdiscount2 = true;
                  print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$notofferdiscount2");
                }
              }

              if (hasOfferAppliedNormalProduct) {
                print("offeerrrrrrrrrrrrronnlyyyyyyy");
                freeItems = 0;
              } else if (onlyDiscountAllowedAndNormal) {
                print("discountnlyyyyyyyyyyyyyyyyyyyyy");
                freeItems = 0;
              } else if (offernotdiscount == true &&
                  notofferdiscount1 == true &&
                  notofferdiscount2 == false) {
                print(
                    "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
                print("offernotdiscount$quat");
                if (offerProductCount >= quat) {
                  print(
                      "offerProductCounttttttttttttttttttttttt$offerProductCount");
                  int f = offerProductCount ~/ 2;

                  print("fffffffffffffffffffffffffff$f");
                  if (quat < f) {
                    print("quatlessthannnfreeitemmmmmmmmmmmmmmmmmmmmmmmmm");
                    freeItems = quat;
                  } else {
                    freeItems = f;
                  }

                  print(
                      "1111111===freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                } else if (quat > offerProductCount) {
                  int f = offerProductCount ~/ 2;
                  freeItems = f;
                  print("fffffffffffffffffffffffffff$f");
                } else {
                  print(
                      "freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                }
              } 
              else if (offernotdiscount == false &&
                  notofferdiscount1 == false &&
                  notofferdiscount2 == true) {
                print(
                    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                print("offernotdiscount$quat");
                if(offerProductCount==1 || offerProductCount==2){
                  freeItems=0;
                }
                else if (offerProductCount >= quat) {
                  print(
                      "offerProductCounttttttttttttttttttttttt$offerProductCount");
                  int f = offerProductCount ~/ 3;

                  print("fffffffffffffffffffffffffff$f");
                  if (quat < f) {
                    print("quatlessthannnfreeitemmmmmmmmmmmmmmmmmmmmmmmmm");
                    freeItems = quat;
                  } else {
                    freeItems = f;
                  }

                  print(
                      "1111111===freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                } else if (quat > offerProductCount) {
                  int f = offerProductCount ~/ 2;
                  freeItems = f;
                  print("fffffffffffffffffffffffffff$f");
                } else {
                  print(
                      "freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                }
              } 
              
              
              else if (offernotdiscount == true &&
                  notofferdiscount1 == false &&
                  notofferdiscount2 == true) {
                print(
                    "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH$offerProductCount");
                print("offernotdiscount$quat");

                if (offerProductCount == 1 || offerProductCount == 2) {
                  freeItems = 0;
                  print(
                      "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
                  break;
                } else if (offerProductCount % 2 == 0) {
                  print(
                      "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNnn$offeronlycount");
                  int f = offeronlycount ~/ 2;
                  int f2 = offerProductCount ~/ 3;

                  if (offeronlycount == quat) {
                    freeItems = f2;
                  } else if (offeronlycount > quat) {
                    print(
                        "offerProductCounttttttttttttttttttttttt$offerProductCount");

                    print("fffffffffffffffffffffffffff$f");
                    if (quat < f) {
                      print("quatlessthannnfreeitemmmmmmmmmmmmmmmmmmmmmmmmm");
                      freeItems = quat;
                    } else {
                      freeItems = f;
                    }

                    print(
                        "1111111===freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                  } else if (quat > offeronlycount) {
                    freeItems = f2;
                    print("fffffffffffffffffffffffffff$f");
                  } else {
                    print(
                        "freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                  }
                }
//elseeeeeeeeeeeeeeeeeeeeeeeeeee
                else if (offerProductCount % 2 == 1) {
                  print(
                      "elseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");

                  if (offerProductCount >= quat) {
                    print(
                        "offerProductCounttttttttttttttttttttttt$offerProductCount");
                    int f = offerProductCount ~/ 3;

                    print("fffffffffffffffffffffffffff$f");
                    if (quat < f) {
                      print("quatlessthannnfreeitemmmmmmmmmmmmmmmmmmmmmmmmm");
                      freeItems = quat;
                    } else {
                      freeItems = f;
                    }

                    print(
                        "1111111===freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                  } else if (quat > offerProductCount) {
                    int f = offerProductCount ~/ 3;
                    freeItems = f;
                    print("fffffffffffffffffffffffffff$f");
                  } else {
                    print(
                        "freeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$freeItems");
                  }
                }
              }

              print("Total free items: $freeItems");

              while (freeItems > 0) {
                // print("gggggggggggggggggggggggggggggggggg");
                int dQuantity = Dquantity ?? 0;

                if (freeItems >= dQuantity) {
                  totalPrice -= (leastPrice! * dQuantity);
                  freeItems -= dQuantity;
                  print(
                      "Total after reduction: $totalPrice, remaining free items: $freeItems");

                  // Find the next least priced product with the same offer
                  double? nextLeastPrice;
                  int nextDquantity = 0;
                  for (int j = 0; j < cartProducts.length; j++) {
                    double price = double.parse(cartProducts[j]['price']);
                    // String? nextOfferType = cartProducts[j]['offer_type'];
                    if ((nextLeastPrice == null || price < nextLeastPrice) &&
                        (bogo == "BUY 1 GET 1" || bogo == "BUY 2 GET 1") &&
                        price > leastPrice!) {
                      nextLeastPrice = price;
                      nextDquantity = cartProducts[j]['quantity'] ?? 1;
                    }
                  }

                  if (nextLeastPrice == null)
                    break; // No more lower priced products

                  leastPrice = nextLeastPrice;
                  Dquantity = nextDquantity;
                } else {
                  totalPrice -= (leastPrice! * freeItems);
                  freeItems = 0;
                  print("Total after final reduction: $totalPrice");
                }
              }
              break; // Exit the loop after processing the first offer type "BUY 2 GET 1"
            }
          }
        }
      }
    });

    print("Total price after applying offers: $totalPrice");
    return totalPrice;
  }

  String? selectedOption = 'Option 1';
  var offerquantity;

  double? leastPrice = null;

  int offerProductCount = 0;

  int calculateOfferQuantity(String offerRType, int quantity) {
    if (bogo == 'BUY 1 GET 1') {
      return quantity * 2;
    } else if (bogo == 'BUY 2 GET 1') {
      return quantity + (quantity ~/ 2);
    }
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (tokenn == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login_Page()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wishlist()));
              }
            },
            icon: Image.asset(
              "lib/assets/heart.png",
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // if(bogo=="BUY 1 GET 1" || bogo=="BUY 2 GET 1" && is_active==false)

          //  Container(
          //   child: Row(
          //     children: [
          //       Text("add discount products to cart... get B1 G1 offer")
          //     ],
          //   ),
          // ),

          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                var stock = cartProducts[index]['stock'] ?? 0;
                var quantity = cartProducts[index]['quantity'] ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Product_big_View(
                          product_id: cartProducts[index]['productId'],
                          slug: cartProducts[index]['slug'],
                          Category_id:
                              int.parse(cartProducts[index]['mainCategory']),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 120,
                          width: 120,
                          child: Image.network(
                            cartProducts[index]['image'],
                            width: 120,
                            height: 120,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartProducts[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 5),
                                if (cartProducts[index]['actualprice'] != null)
                                  Text(
                                    '\$${cartProducts[index]['actualprice']}',
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${cartProducts[index]['price']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                if (cartProducts[index]['color'] != null &&
                                    cartProducts[index]['size'] != null)
                                  Row(
                                    children: [
                                      Text(
                                        '${cartProducts[index]['color']}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                              255, 115, 115, 115),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${cartProducts[index]['size']}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                              255, 115, 115, 115),
                                        ),
                                      ),
                                    ],
                                  ),
                                if ((cartProducts[index]['has_offer'] ==
                                            "Offer Applied" ||
                                        cartProducts[index]
                                                ['category_discount'] ==
                                            "Category Offer Applied") &&
                                    bogo != null)
                                  Text(
                                    '$bogo',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),

                                // Inside the ListView.builder itemBuilder method
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Decrementquantity(
                                              cartProducts[index]['id'],
                                              cartProducts[index]["quantity"] -
                                                  1);

                                          setState(() {
                                            calculateTotalPrice();
                                            fetchCartData();
                                          });
                                        },
                                        icon: Icon(Icons.remove),
                                        iconSize: 18,
                                      ),
                                      Text(
                                        '${cartProducts[index]["quantity"] ?? 1}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (stock > quantity) {
                                            incrementquantity(
                                                cartProducts[index]['id'],
                                                cartProducts[index]
                                                        ["quantity"] +
                                                    1);

                                            setState(() {
                                              fetchCartData();
                                              calculateTotalPrice();
                                              _initData();
                                            });
                                          } else {
                                            print("out of stockkk");
                                          }
                                        },
                                        icon: Icon(Icons.add),
                                        iconSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                if (selectedOption == 'Option 1' &&
                                    (cartProducts[index]['offer_type'] ==
                                            'BUY 1 GET 1' ||
                                        cartProducts[index]['offer_type'] ==
                                            'BUY 2 GET 1'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      cartProducts[index]['offer_type'] ==
                                              'BUY 2 GET 1'
                                          ? 'Special Offer: ${cartProducts[index]['offer_type']}'
                                          : 'Special Offer: ${cartProducts[index]['offer_type']} - Get ${calculateOfferQuantity(cartProducts[index]['offer_type'], cartProducts[index]['quantity'])} items',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 15),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(
                                      "iddddddddddddddddddddddddddddddddd${cartProducts[index]['id']}");
                                  deleteCartProduct(cartProducts[index]['id']);
                                  removeProduct(index);

                                  setState(() {
                                    fetchCartData();
                                    calculateTotalPrice();
                                  });
                                },
                                child: ImageIcon(
                                  AssetImage('lib/assets/close.png'),
                                  size: 24,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                total = calculateTotalPrice().toStringAsFixed(2);
                print(
                    "(((((((((((((((((((((((((((((((((((((((((((((((((((((((($total");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => order(total: selectedOption)));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => search()));
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }
}
