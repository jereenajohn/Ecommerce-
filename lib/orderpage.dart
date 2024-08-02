import 'dart:convert';

import 'package:bepocart/addaddress.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/ordersuccesspage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:razorpay_web/razorpay_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';

class order extends StatefulWidget {
  var total;
  order({super.key, required this.total});

  @override
  State<order> createState() => _orderState();
}

enum PaymentMethod { cod, razorpay }

class _orderState extends State<order> {
  var couponcode;
  String? userId;
  bool isCouponApplied = false;
  int? selectedAddressId;
  String fetchaddressurl =
      "https://spot-defence-womens-audit.trycloudflare.com/get-address/";
  String orderurl =
      "https://spot-defence-womens-audit.trycloudflare.com/order/create/";
  String cuponurl =
      "https://spot-defence-womens-audit.trycloudflare.com/cupons/";

  List<Map<String, dynamic>> addressList = [];
  int selectedAddressIndex = -1;
  TextEditingController coupon = TextEditingController();
  int CODAMOUNT = 50;
  late Razorpay razorpay;
  Map<String, dynamic>? selectedAddress;
  var hasAddresses;
  var tokenn;
  @override
  void initState() {
    super.initState();
    _initData();
    // print(widget.name);
    print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY${widget.total}");

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    userId = await getUserIdFromPrefs();
    fetchcupons();
    fetchoffers();

    fetchCartData();
    fetchAddress();
    // calculateTotalAmount();

    // calculateTotalPrice();
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  var Dquantity;
  var totalPrice = 0.0;
  double parsePrice(dynamic price) {
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else if (price is String) {
      return double.parse(price);
    } else {
      throw ArgumentError('Invalid price type');
    }
  }

  List<int> offerProducts = [];
  List<Map<String, dynamic>> offers = [];
  final String offersurl =
      "https://spot-defence-womens-audit.trycloudflare.com/offer/";

  var bogo;
  bool is_active = false;
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
            offerProducts.addAll(List<int>.from(productData['offer_products']));
          } else if (productData.containsKey('offer_category')) {
            offerCategories
                .addAll(List<int>.from(productData['offer_category']));
          }
        }

        setState(() {
          offers = productsList;
          // Store offerProducts and offerCategories in state variables if needed
          print('offerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: $offers');
          print('Offer Products: $offerProducts');
          print('Offer Categories: $offerCategories');
          // for(int i=0;i<offers.length;i++){
          if (offers[0]['offer_type'] == "BUY") {
            print(
                "***********************************************************************************${offers[0]['get_option']}");
            if (offers[0]['get_option'] == 1) {
              bogo = "BUY 1 GET 1";
              print("bogooooooooooooooooooooooooooo:::$bogo");
            } else if (offers[0]['get_option'] == 2) {
              bogo = "BUY 2 GET 1";
              print("bogooooooooooooooooooooooooooo:::$bogo");
            }
            if (offers[0]['is_active'] == "Allowed") {
              is_active = true;
              print("is_activeeeeeeeeeeeeeeeeeeeee:::$is_active");
            } else {
              is_active = false;
            }

            // }
          }
        });
        calculateTotalPrice();
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
  bool offeronly = false;

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    double? leastPrice;
    int offerProductCount = 0;
    int offeronlycount = 0;
    int quat = 0;
    setState(() {
      if (is_active == 'true') {
        for (int i = 0; i < cartProducts.length; i++) {
          double price = (cartProducts[i]['saleprice'] is int)
              ? (cartProducts[i]['saleprice'] as int).toDouble()
              : double.parse(cartProducts[i]['saleprice'].toString());
          int quantity = cartProducts[i]['quantity'] ?? 1;
          print("priceeeeeeeeeeeeeeeeeeeeeeoption11111111======$price");
          print("priceeeeeeeeeeeeeeeeeeeeeeoption11111111======$quantity");

          totalPrice += price * quantity;
          print(
              "Totallllllllllpriceeeeeeeeeeeeeeeeeeeeeeoption11111111======$totalPrice");
        }
      } else {
        for (int i = 0; i < cartProducts.length; i++) {
          double price = double.parse(cartProducts[i]['saleprice']);
          int quantity = cartProducts[i]['quantity'] ?? 1;

          // Add price to total price
          totalPrice += price * quantity;

          print("totallllllllllllelseeeeeeeeeeeeeeeee$totalPrice");
          String? discountapplicable = cartProducts[i]['discount_product'];
          String? has_offer = cartProducts[i]['has_offer'];

          if (has_offer == "Offer Applied") {
            // Count the offer products
            offerProductCount += quantity;
            offeronly = true;

            print("ofeerrrrrrcountttttttttttttttttttttttt$offerProductCount");
          }

          // Check if this product has an offer
          // String? offerType = cartProducts[i]['offer_type'];
          if (discountapplicable == "Discount Allowd") {
            print("ssssssssssssssssssssssssss");

            // Determine the least priced offer product
            if (leastPrice == null || price < leastPrice!) {
              leastPrice = price;
              print("leasttttttttttttttttttttttttt$leastPrice");
              Dquantity = quantity;
              print("Quantity of least price product: $Dquantity");
            }
          }
        }

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
            print("bogooooooooooooooooooooooooooooo$bogo");
            if (bogo == "BUY 1 GET 1") {
              // For "BUY 1 GET 1", each pair gets one free
              int freeItems = 0;
              print("Free itemsssssssssssssssssssssssssss: $freeItems");

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

                if (discountapplicable == "Discount Allowd") {
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
                    discountapplicable == "Discount Allowd") {
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

              while (freeItems > 0) {
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
                    double price = double.parse(cartProducts[j]['saleprice']);
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
                  "hasBothOfferAndDiscounttttttttttttttttttttttttttttttttttttttttttt$hasBothOfferAndDiscount");
              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];

                if (discountapplicable == "Discount Allowd") {
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
                    discountapplicable == "Discount Allowd") {
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
                } else {
                  notofferdiscount1 = true;
                }
              }

              for (int i = 0; i < cartProducts.length; i++) {
                String? discountapplicable =
                    cartProducts[i]['discount_product'];
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
                  print(
                      "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$notofferdiscount2");
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
              } else if (offernotdiscount == false &&
                  notofferdiscount1 == false &&
                  notofferdiscount2 == true) {
                print(
                    "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                print("offernotdiscount$quat");
                if (offerProductCount == 1 || offerProductCount == 2) {
                  freeItems = 0;
                } else if (offerProductCount >= quat) {
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
              } else if (offernotdiscount == true &&
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
                    double price = double.parse(cartProducts[j]['saleprice']);
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
              calculateTotalAmount();
              break; // Exit the loop after processing the first offer type "BUY 2 GET 1"
            }
          }
        }
      }
    });

    print("Total price after applying offers: $totalPrice");
    return totalPrice;
  }

  double? leastPrice = null;

  int offerProductCount = 0;

  Future<void> fetchAddress() async {
    final token = await gettokenFromPrefs();
    print("--------------------------------------------R$token");

    var response = await http.get(
      Uri.parse(fetchaddressurl),
      headers: {
        'Authorization': '$token',
      },
    );

    print("Fetch address: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['address'];

      print("Address: $data");

      setState(() {
        addressList = List<Map<String, dynamic>>.from(data);
        print("Address List: $addressList");
      });

      // Check if addressList is empty to indicate no addresses
      if (addressList.isEmpty) {
        hasAddresses = false; // Flag to indicate no addresses
      } else {
        hasAddresses = true; // Flag to indicate addresses are available
        // Set default selected address (if needed)
        // selectedAddress = addressList.first;
        // selectedAddressId = addressList.first['id'];
      }
    } else if (response.statusCode == 401) {
      print("session expireddd");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Page()));
    } else {
      print("Failed to fetch address data");
    }
  }

  var CartUrl =
      "https://spot-defence-womens-audit.trycloudflare.com/cart-products/";
  List<Map<String, dynamic>> cartProducts = [];
  var orginalprice;
  var sellingprice;
  var discount;
  var deliverycharge;
  PaymentMethod _selectedMethod = PaymentMethod.razorpay;
  var selectedpaymentmethod = 'razorpay';
  var cupondiscount;
  bool isButtonDisabled = false;

  void openCheckout() {
    var options = {
      "key": "rzp_test_m3k00iFqtte9HH",
      "amount": totalPrice * 100,
      "name": "Bepocart",
      "description": " this is the test payment",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "11111111111",
        "email": "test@abc.com",
      }
    };
    razorpay.open(options);
  }

  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  var id;

  void successHandler(PaymentSuccessResponse response) {
    id = response.paymentId;

    // Show an alert dialog with a "Done" button
    // showDialog(
    //   context: context,
    //   barrierDismissible: false, // Prevent dismissing by tapping outside
    //   builder: (BuildContext context) {
    //     return WillPopScope(
    //       onWillPop: () async => false, // Prevent dismissing by back button
    //       child: AlertDialog(
    //         title: Text("Payment Successful"),
    //         content: Text("Your payment ID is ${response.paymentId!}"),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               // orderpayment();
    //               Navigator.of(context).pop(); // Close the dialog
    //             },
    //             child: Text("Done"),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
    orderpayment();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  void showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Adjust bottom sheet height based on content
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.white, // Set the background color to white
              padding: EdgeInsets.all(16), // Padding for the content
              child: hasAddresses
                  ? Wrap(
                      children: addressList.map((address) {
                        return Column(
                          children: [
                            RadioListTile<Map<String, dynamic>>(
                              title: Text(address['address']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('City: ${address['city']}'),
                                  Text('State: ${address['state']}'),
                                  Text('Pincode: ${address['pincode']}'),
                                  Text('Phone: ${address['phone']}'),
                                  Text('Email: ${address['email']}'),
                                ],
                              ),
                              value: address,
                              groupValue: selectedAddress,
                              onChanged: (value) {
                                setState(() {
                                  selectedAddress = value;
                                  selectedAddressId = value?['id'];
                                });
                                // Optionally, close the bottom sheet immediately after selecting an address
                                Navigator.pop(context);
                              },
                            ),
                            Divider(), // Add a divider after each address
                          ],
                        );
                      }).toList(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize
                          .min, // Use minimum height for the content
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // 90% of screen width
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserAddress(), // Replace with your add address screen
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black, // Set button color to black
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Set button corners to square (0 radius)
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Add Address',
                                style: TextStyle(
                                  fontSize: 16, // Adjust font size if needed
                                  color: Colors.white, // Text color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

//coupons
  List<Map<String, dynamic>> cupondata = [];
  void fetchcupons() async {
    try {
      final response = await http.get(Uri.parse(cuponurl));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        List<Map<String, dynamic>> cuponList = [];

        for (var coupon in productsData) {
          cuponList.add({
            'id': coupon['id'],
            'code': coupon['code'],
            'coupon_type': coupon['coupon_type'],
            'discount': coupon['discount'],
          });
        }

        setState(() {
          cupondata = cuponList;
          print("cuponssssssssssssssssssssssssssssss$cupondata");
          // Initialize isFavorite list with the same length as products list
        });
      } else {
        throw Exception('Failed to load Buy One Get One products');
      }
    } catch (error) {
      print('Error fetching Buy One Get One products: $error');
    }
  }

//Order create

  Future<void> ordercreate() async {
    try {
      final token = await gettokenFromPrefs();

      print('**Coupon Code: $couponcode');
      print('**Payment Method: $selectedpaymentmethod');
      print(
          'ooooooooooooooooooorrrrrrrrrrrrrrdddddddddddeeeeeeeerrrrrrccccccccrrrrreeeeeaaaaatttteeeeeeee:$orderurl$selectedAddressId/');

      final url = Uri.parse(
          '$orderurl$selectedAddressId/'); // Use the selected address ID
      final headers = {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'coupon_code': couponcode,
        'payment_method': selectedpaymentmethod,
      });

      print('Request URL: $url');
      print('Request Headers: $headers');
      print('Request Body: $body');

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print(
          'Response BodyYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY: ${response.body}');

      if (response.statusCode == 201) {
        final recent = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(),
          ),
        );
        print(
            'Order created successfuLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLlly: $recent');
      } else {
        print('Failed to create order: ${response.statusCode}');
        print('Error Message: ${jsonDecode(response.body)['message']}');
      }
    } catch (error) {
      print('Error creating order: $error');
    }
  }

  Future<void> orderpayment() async {
    try {
      final token = await gettokenFromPrefs();

      print(
          "QWWWWWWWWWWWWWWWWWWWWEEEEEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRRRRRRRRRRRRRRR$token");
      print(
          '##################################################YYYYYYYYYYYYYYYYYYYYYYYYYY$orderurl$selectedAddressId/');
      print(
          '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@R@@@@@@@@@@Coupon Code: $couponcode');
      print(
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Payment Method: $selectedpaymentmethod');

      final url = Uri.parse('$orderurl$selectedAddressId/');
      final headers = {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'coupon_code': couponcode,
        'payment_method': selectedpaymentmethod,
        'id': id
      });

      print('Request URL: $url');
      print('Request Headers: $headers');
      print('Request Body: $body');

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final recent = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(),
          ),
        );
        print('Order created successfully: $recent');
      } else {
        print('Failed to create order: ${response.statusCode}');
        print('Error Message: ${jsonDecode(response.body)['message']}');
      }
    } catch (error) {
      print('Error creating order: $error');
    }
  }

  Future<void> fetchCartData() async {
    print("Fetching cart data...");
    try {
      final token = await gettokenFromPrefs();
      print("Token: $token");

      final response = await http.get(
        Uri.parse(CartUrl),
        headers: {
          'Authorization': '$token',
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        print("data: $data");

        List<Map<String, dynamic>> cartItems = [];

        for (var item in data) {
          String imageUrl =
              "https://spot-defence-womens-audit.trycloudflare.com/${item['image']}";

          // Check if item['price'] is null and assign zero if so
          var price = item['price'] != null ? item['price'] : 0;

          cartItems.add({
            'id': item['id'],
            'productId': item['product'],
            'mainCategory': item['mainCategory'],
            'quantity': item['quantity'],
            'saleprice': item['salePrice'],
            'price': price,
            'name': item['name'],
            'image': imageUrl,
            'color': item['color'],
            'size': item['size'],
            'offer_type': item['offer_type'],
            'has_offer': item['has_offer'],
            'discount_product': item['discount_product'],
          });
        }

        setState(() {
          cartProducts = cartItems;
          print(
              "Cart Productssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss: $cartProducts");

          orginalprice = calculateOriginalPrice();
          totalPrice = calculateTotalPrice();
          discount = orginalprice - totalPrice;
          print("Original Price: $orginalprice");
          print(
              "Selling Priceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee: $totalPrice");
          print("Discount: $discount");
          fetchoffers();
        });

        print(cartProducts.length);
      } else {
        print("Failed to fetch cart data");
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }


  double calculateOriginalPrice() {
    double totalPrice = 0.0;
    for (int i = 0; i < cartProducts.length; i++) {
      double price = cartProducts[i]['price'] is String
          ? double.parse(cartProducts[i]['price'])
          : cartProducts[i]['price'].toDouble();
      int quantity = cartProducts[i]['quantity'] ?? 1;

      // Check if price is zero, use selling price instead
      if (price == 0) {
        price = double.parse(cartProducts[i]['saleprice']);
      }

      totalPrice += price * quantity;
    }

    print("Total Original Price: $totalPrice");
    return totalPrice;
  }

  double calculateTotalAmount() {
    setState(() {
      print(
          "total::::::::::::::::::::::::::::::::::::::::::::::::::::::::::$totalPrice");

      if (totalPrice < 500) {
        deliverycharge = 60;
        totalPrice = totalPrice + deliverycharge;
      } else {
        deliverycharge = 0;
      }
    });
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => Select_Delivery_Address()),
            // );
          },
          child: Text(
            "Order Summary",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStep(1, "Address", currentStep >= 1),
                            _buildSeparator(currentStep >= 2),
                            _buildStep(2, "Order Summary", currentStep >= 2),
                            _buildSeparator(currentStep >= 3),
                            _buildStep(3, "Payment", currentStep >= 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the start (left)
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10), // Add padding of 10
                        child: SizedBox(
                          // width: 150, // Set the desired width if needed
                          // height: 50, // Set the desired height if needed
                          child: ElevatedButton(
                            onPressed: () {
                              fetchAddress();
                              showAddressBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Adjust the radius as needed
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add), // Plus icon
                                SizedBox(
                                    width: 5), // Space between icon and text
                                Text("Select Address"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: selectedAddress != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected Address:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${selectedAddress!['address']}, ${selectedAddress!['city']}, ${selectedAddress!['state']}, ${selectedAddress!['pincode']}, ${selectedAddress!['phone']}, ${selectedAddress!['email']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : Text(
                              'No address selected',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Color.fromARGB(255, 202, 201, 201)
                  //               .withOpacity(0.5),
                  //           spreadRadius: 2,
                  //           blurRadius: 5,
                  //           offset: Offset(0, 3),
                  //         ),
                  //       ],
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 10),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           SizedBox(height: 6),
                  //           Text(
                  //             widget.name,
                  //             style: TextStyle(
                  //               color: Color.fromARGB(255, 0, 0, 0),
                  //             ),
                  //           ),
                  //           Text(
                  //             "${widget.city}, ${widget.state}, ${widget.number.toString()}",
                  //             style: TextStyle(
                  //               color: Color.fromARGB(255, 0, 0, 0),
                  //             ),
                  //           ),
                  //           Text(
                  //             widget.email,
                  //             style: TextStyle(
                  //               color: Color.fromARGB(255, 0, 0, 0),
                  //             ),
                  //           ),
                  //           Text(
                  //             widget.pincode.toString(),
                  //             style: TextStyle(
                  //               color: Color.fromARGB(255, 0, 0, 0),
                  //             ),
                  //           ),
                  //           SizedBox(height: 6),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  _buildCartItems(),

                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio<PaymentMethod>(
                              value: PaymentMethod.razorpay,
                              groupValue: _selectedMethod,
                              onChanged: (PaymentMethod? value) {
                                setState(() {
                                  _selectedMethod = value!;
                                  print(_selectedMethod);
                                  selectedpaymentmethod = "razorpay";
                                  print(
                                      "selectedpaymentmethod:$selectedpaymentmethod");
                                  totalPrice = totalPrice - CODAMOUNT;
                                  print(
                                      "RTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR$sellingprice");
                                });
                              },
                              activeColor:
                                  Colors.black, // Set the active color to black
                            ),
                            const Text(
                              'Razorpay',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<PaymentMethod>(
                              value: PaymentMethod.cod,
                              groupValue: _selectedMethod,
                              onChanged: (PaymentMethod? value) {
                                setState(() {
                                  _selectedMethod = value!;
                                  print(_selectedMethod);
                                  selectedpaymentmethod = "COD";
                                  print(selectedpaymentmethod);
                                  totalPrice = totalPrice + CODAMOUNT;
                                  print(
                                      "CCCCCCCCCCCCOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDAAAAAAAAAAAMMMMMMMMMMMMMMMMMMMMM$sellingprice");
                                });
                              },
                              activeColor:
                                  Colors.black, // Set the active color to black
                            ),
                            const Text(
                              'Cash on Delivery (COD)',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: coupon,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: 'Enter Coupon Code',
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: isButtonDisabled
                              ? null
                              : () {
                                  setState(() {
                                    couponcode = coupon.text;
                                    print('Button Pressed $couponcode');
                                    for (int i = 0; i < cupondata.length; i++) {
                                      if (couponcode == cupondata[i]['code']) {
                                        if (cupondata[i]['coupon_type'] ==
                                            "Fixed Amount") {
                                          sellingprice = sellingprice -
                                              double.parse(
                                                  cupondata[i]['discount']);
                                          cupondiscount = double.parse(
                                              cupondata[i]['discount']);
                                          print(
                                              "After Apply coupon: $sellingprice");
                                        } else {
                                          sellingprice = sellingprice -
                                              (sellingprice *
                                                  double.parse(cupondata[i]
                                                      ['discount']) /
                                                  100);
                                          cupondiscount = (sellingprice *
                                              double.parse(
                                                  cupondata[i]['discount']) /
                                              100);
                                          print(
                                              "After Apply coupon percentage: $sellingprice");
                                        }
                                        isButtonDisabled = true;
                                        isCouponApplied = true;
                                        coupon.clear();
                                      }
                                    }
                                  });
                                },
                          child: Text(
                            isCouponApplied ? 'Applied' : 'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Rectangular shape
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 202, 201, 201)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Price Details",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Price",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                "₹${orginalprice}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Discount",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                "-₹${discount}",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _selectedMethod == PaymentMethod.cod,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Row(
                              children: [
                                Text(
                                  "COD Charge",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                                Text(
                                  "+₹${CODAMOUNT}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (cupondiscount != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Coupon Discount",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                                Text(
                                  "-₹${cupondiscount}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Delivery Charge",
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text(
                                deliverycharge != 60
                                    ? "Free Delivery"
                                    : "₹${deliverycharge}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: deliverycharge != 60
                                      ? Colors.green
                                      : Colors
                                          .black, // Change color if free delivery
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Spacer(),
                              Text(
                                "₹$totalPrice",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "You will save ₹${discount} on this order",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 70,
                          color: Color.fromARGB(255, 228, 227, 227),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                              ),
                              Image.asset(
                                "lib/assets/safe.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                  width:
                                      15), // Add some space between the image and text
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Safe and secure payment.Easy ",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            "\nreturns. 100% Authentic products.",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), // Display cart items here
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (selectedpaymentmethod == "COD") {
                  ordercreate();
                } else {
                  openCheckout();
                  orderpayment();
                }
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
                    _selectedMethod == PaymentMethod.cod
                        ? "Order Now"
                        : "Payment",
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
                  if (tokenn == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login_Page()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  }

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

  final int currentStep = 2; // Change this value to reflect the current step

  Widget _buildStep(int step, String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: isActive
              ? Text(
                  step.toString(),
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  step.toString(),
                  style: TextStyle(color: Colors.white),
                ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(bool isActive) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 202, 201, 201).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product['image'],
                height: 80.0,
                width: 80.0,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 5.0),
                    Text('Quantity: ${product['quantity']}'),
                    SizedBox(height: 5.0),
                    if (product['color'] != null)
                      Row(
                        children: [
                          Text(
                            '${product['color']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${product['size']}'),
                        ],
                      ),
                    SizedBox(height: 5.0),
                    Text('\₹${product['saleprice']}'),
                    Text(
                      '\₹${product['price'] != 0 ? product['price'] : 'No offer available'}',
                      style: TextStyle(
                        color: product['price'] != 0
                            ? Colors.grey
                            : Colors.green, // Text color change
                        decoration: product['price'] != 0
                            ? TextDecoration.lineThrough
                            : TextDecoration
                                .none, // Line-through effect if price is not zero
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
