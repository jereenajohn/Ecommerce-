import 'dart:async';
import 'dart:convert';
import 'package:bepocart/bestsaleproducts.dart';
import 'package:bepocart/buyonegetone.dart';
import 'package:bepocart/buytwogetone.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/discountproducts.dart';
import 'package:bepocart/flashsaleproducts.dart';
import 'package:bepocart/halfrateproducts.dart';
import 'package:bepocart/offerproducts.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/recommendedproducts.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/subcategories.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/waitingpagebeforelogin.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  final String? user_id; // Receive user_id as a parameter

  const HomePage({Key? key, this.user_id}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId; // Declare userId variable to store user ID

  int _selectedIndex = 0; // Index of the selected tab
  PageController _pageController = PageController();
  late Timer _timer;
  List<Map<String, dynamic>> banners = [];
  List<String> offerbannerImageBase64Strings = [];
  List<Map<String, dynamic>> recenlyviewd = [];

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> discountproducts = [];
  List<Map<String, dynamic>> recommendedproducts = [];

  List<Map<String, dynamic>> buyonegetoneproducts = [];
  List<Map<String, dynamic>> bestsaleproducts = [];
  List<Map<String, dynamic>> flashsaleproducts = [];
  List<Map<String, dynamic>> buytwogetoneproducts = [];
  List<Map<String, dynamic>> halfrateproducts = [];
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchitem = TextEditingController();

  List<Map<String, dynamic>> offers = [];

  final String bannerurl = "https://303c-59-92-204-108.ngrok-free.app//banners/";
  final String baseUrl = "https://303c-59-92-204-108.ngrok-free.app/";
  final String categoryUrl =
      "https://303c-59-92-204-108.ngrok-free.app//category/";
  final String productsurl =
      "https://303c-59-92-204-108.ngrok-free.app//products/";
  final String offersurl =
      "https://303c-59-92-204-108.ngrok-free.app//offer-banner/";

  final String discountsurl =
      "https://303c-59-92-204-108.ngrok-free.app//discount-sale/";
  final String buyonegetoneurl =
      "https://303c-59-92-204-108.ngrok-free.app//buy-1-get-1/";

  final String bestsaleurl =
      "https://303c-59-92-204-108.ngrok-free.app//best-sale-products/";

  final String flashsaleurl =
      "https://303c-59-92-204-108.ngrok-free.app//flash-sale/";

  final String buytwogetoneurl =
      "https://303c-59-92-204-108.ngrok-free.app//buy-2-get-1/";

  final String halfrateproductsurl =
      "https://303c-59-92-204-108.ngrok-free.app//offers/";

  final String searchproducturl =
      "https://303c-59-92-204-108.ngrok-free.app//search-products/?q=";

  final String recommendedproductsurl =
      "https://303c-59-92-204-108.ngrok-free.app//recommended/";

  var recentlyviewedurl =
      "https://303c-59-92-204-108.ngrok-free.app//recently-viewed/";

  bool _isSearching = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchCategories();
    fetchProducts();
    _startTimer();
    fetchOffers();
    fetchDiscountProducts();
    fetchbuyonegetoneProducts();
    fetchBestSaleProducts();
    fetchFlashSaleProducts();
    fetchbuytwogetoneProducts();
    halfratedProducts();
    fetchRecommendedProducts();
    recentlyviewed();

    // Call getUserIdFromPrefs when the widget initializes
    getUserIdFromPrefs().then((value) {
      setState(() {
        userId = value;
        print("555555555555555R5555555555555555555555555$userId");
      });
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Clear user ID from shared preferences
    Navigator.pop(
        context); // Navigate back to the previous screen (login or wherever you came from)
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const Duration duration =
        Duration(seconds: 5); // Adjust the duration as needed
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.hasClients) {
        if (_pageController.page == banners.length - 1) {
          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        } else {
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      }
    });
  }

  Future<void> recentlyviewed() async {
    try {
      final token = await gettokenFromPrefs();

      var response = await http.post(
        Uri.parse('$recentlyviewedurl'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      print(
          "viewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww ${response.body}");

      if (response.statusCode == 200) {
        final recent = jsonDecode(response.body);

        final List<dynamic> recentproductsData = recent['data'];
        List<Map<String, dynamic>> Recentlylist = [];

        print(
            "RRRRRRRRRRREEEEEEEEECCCCCCCCCCCCEEEEEEEEENNNNNNNTTTTTTTTTTTT$recentproductsData");

        for (var recentproductsData in recentproductsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${recentproductsData['image']}";
          Recentlylist.add({
            'id': recentproductsData['id'],
            'mainCategory': recentproductsData['mainCategory'],
            'name': recentproductsData['name'],
            'salePrice': recentproductsData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          recenlyviewd = Recentlylist;

          print(
              "RRRRRRRRRRRRRRRRRRTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT$recenlyviewd");
        });

        print('Profile data fetched successfully');
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  Future<void> searchproduct() async {
    print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    try {
      print('$searchproducturl${searchitem.text}');
      final response = await http.post(
        Uri.parse('$searchproducturl${searchitem.text}'),
        body: ({'q': searchitem.text}),
      );
      print("==============hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh${response.body}");
      print(
          "==============JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ${response.statusCode}");

      if (response.statusCode == 200) {
        print("=========KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");

        final List<dynamic> searchData = jsonDecode(response.body);
        List<Map<String, dynamic>> searchList = [];
        print("=========KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK${searchData}");

        for (var productData in searchData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          searchList.add({
            'id': productData['id'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
            'category_id': productData['mainCategory'],
          });
        }
        setState(() {
          searchResults = searchList;
          print("8888888888888888888$searchResults");
        });
      } else {
        print('Failed to search item: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching product: $error');
    }
  }

  Future<void> fetchOffers() async {
    try {
      final response = await http.get(Uri.parse(offersurl));
      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> offersData = parsed['banner'];
        List<Map<String, dynamic>> offersList = [];

        for (var offerData in offersData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${offerData['image']}";
          offersList.add({
            'id': offerData['id'],
            'name': offerData['name'],
            'image': imageUrl,
          });
        }

        setState(() {
          offers = offersList;
        });
      } else {
        throw Exception('Failed to load offers');
      }
    } catch (error) {
      print('Error fetching offers: $error');
    }
  }

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
              "https://303c-59-92-204-108.ngrok-free.app${productData['image']}";
          productsList.add({
            'id': productData['id'],
            'name': productData['name'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          products = productsList;
        });
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      print('Error fetching wishlist products: $error');
    }
  }

  Future<void> fetchDiscountProducts() async {
    try {
      final response = await http.get(Uri.parse(discountsurl));
      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed;

        List<Map<String, dynamic>> productDiscountList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productDiscountList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          discountproducts = productDiscountList;
          print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$discountproducts");
        });
      } else {
        throw Exception('Failed to load discount products');
      }
    } catch (error) {
      print('Error fetching discount products: $error');
    }
  }

  Future<void> fetchBestSaleProducts() async {
    try {
      final response = await http.get(Uri.parse(bestsaleurl));
      print('Response: ${response.statusCode}');
      print(
          "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT${response.body}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed;

        List<Map<String, dynamic>> productBestSaleList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productBestSaleList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          bestsaleproducts = productBestSaleList;
          print(
              "YYYYYYYYYYYYYYYYYYYYUUUUUUUUUUUUIIIIIIIIIIIIIIIIIIIIII$bestsaleproducts");
        });
      } else {
        throw Exception('Failed to load discount products');
      }
    } catch (error) {
      print('Error fetching discount products: $error');
    }
  }

  Future<void> fetchFlashSaleProducts() async {
    try {
      final response = await http.get(Uri.parse(flashsaleurl));
      print('Response: ${response.statusCode}');
      print(
          "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT${response.body}");

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed;

        List<Map<String, dynamic>> productFlashSaleList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productFlashSaleList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          flashsaleproducts = productFlashSaleList;
          print(
              "YYYYYYYYYYYYYYYYYYYYUUUUUUUUUUUUIIIIIIIIIIIIIIIIIIIIII$flashsaleproducts");
        });
      } else {
        throw Exception('Failed to load discount products');
      }
    } catch (error) {
      print('Error fetching discount products: $error');
    }
  }

  Future<void> fetchbuyonegetoneProducts() async {
    try {
      final response = await http.get(Uri.parse(buyonegetoneurl));

      print(
          "ressssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        List<Map<String, dynamic>> productbuyonegetoneList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productbuyonegetoneList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          buyonegetoneproducts = productbuyonegetoneList;
          print(
              "HELLLLLLLLLLOOOOOOOOOOOOOOOOOOOOOOOOOOOO$buyonegetoneproducts");
        });
      } else {
        throw Exception('Failed to load Buy One Get One products');
      }
    } catch (error) {
      print('Error fetching Buy One Get One products: $error');
    }
  }

  void fetchbuytwogetoneProducts() async {
    try {
      final response = await http.get(Uri.parse(buytwogetoneurl));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        List<Map<String, dynamic>> productbuytwogetoneList = [];

        print(
            "JJJJJJJJJJJJJJJJJJUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU$productsData");

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productbuytwogetoneList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          buytwogetoneproducts = productbuytwogetoneList;
          print(
              "AAAAAAUUUUUUUUUUUYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY$buytwogetoneproducts");
        });
      } else {
        throw Exception('Failed to load Buy One Get One products');
      }
    } catch (error) {
      print('Error fetching Buy One Get One products: $error');
    }
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchRecommendedProducts() async {
    try {
      final token = await gettokenFromPrefs();

      print("TTTTTTTTTTTTTOOOOOOOOOOOOOOOOOOOOOOOKKKKKKKKKKKKKKKKKKKKK$token");

      final response = await http.post(
        Uri.parse(recommendedproductsurl),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
        body: jsonEncode({
          'token': token,
        }),
      );
      print(
          "77777777777777777777777777777777777766666666666666666666666666666666666${response.body}");
      print(
          "55555555555555555555544444444444444444444444444443333333333333333333333${response.statusCode}");
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['data'];

        print("WWWWWWWWWWWqqqqqqqqqwwwwwwwwwwwweeeeeeeeeeeeeeee$productsData");

        List<Map<String, dynamic>> productRecommendedList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          productRecommendedList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          recommendedproducts = productRecommendedList;
          print(
              "Recommended Productsssssssssssssssssssssssssssssssssssssss: $recommendedproducts");
        });
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (error) {
      print('Error fetching recommended products: $error');
    }
  }

  void halfratedProducts() async {
    try {
      final response = await http.get(Uri.parse(halfrateproductsurl));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        List<Map<String, dynamic>> halfratedList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
          halfratedList.add({
            'id': productData['id'],
            'mainCategory': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'offer_type': productData['offer_type'],
            'image': imageUrl,
          });
        }

        setState(() {
          halfrateproducts = halfratedList;
          // Initialize isFavorite list with the same length as products list
        });
      } else {
        throw Exception('Failed to load Buy One Get One products');
      }
    } catch (error) {
      print('Error fetching Buy One Get One products: $error');
    }
  }

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(Uri.parse(bannerurl));
      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> bannersData = parsed['banner'];
        List<Map<String, dynamic>> bannerList = [];

        for (var bannerData in bannersData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${bannerData['image']}";
          bannerList.add({
            'image': imageUrl,
          });
        }

        setState(() {
          banners = bannerList;
        });
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      print('Error fetching wishlist products: $error');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));
      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> categorysData = parsed['data'];
        List<Map<String, dynamic>> categoryList = [];

        for (var categoryData in categorysData) {
          String imageUrl =
              "https://303c-59-92-204-108.ngrok-free.app/${categoryData['image']}";
          categoryList.add({
            'id': categoryData['id'],
            'name': categoryData['name'],
            'image': imageUrl,
          });
        }

        setState(() {
          categories = categoryList;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  void _showSearchDialog(BuildContext context) {
    setState(() {
      _isSearching = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchitem,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await searchproduct();

                          setState(() {
                            _isSearching = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Search(searchresults: searchResults)));
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                // Add search results here
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselWidth = screenWidth * 0.9;

    return RefreshIndicator(
      onRefresh: () async {
        fetchBanners();
        fetchCategories();
        fetchProducts();
        _startTimer();
        fetchOffers();
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // color: Color.fromARGB(255, 235, 232, 232),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.scale(
                    scale: 1.2, // Adjust the scale factor as needed
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 7),
                      child: Image.asset(
                        "lib/assets/logo.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 170),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wishlist()));
                      },
                      icon: Image.asset(
                        "lib/assets/heart.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     logout();

                  //     // Add your logout functionality here
                  //   },
                  //   icon: Image.asset(
                  //     "lib/assets/logout.png",
                  //     width: 25,
                  //     height: 25,
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    banners.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 240,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: banners.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: carouselWidth,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      banners[index]['image'],
                                      // Assuming banners[index] contains the URL of the image
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Make the ListView scroll horizontally
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubcategoriesPage(
                                    categoryId: categories[index]['id'],
                                    // userid: widget.userid,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    categories[index]['image'],
                                    width: 70,
                                    height: 70,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    categories[index]['name'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (recenlyviewd.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Recently Viewed",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                height:
                                    220, // Adjusted height to accommodate the images
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: SizedBox(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recenlyviewd.length >= 5
                                          ? 5
                                          : recenlyviewd.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final product = recenlyviewd[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Product_big_View(
                                                  product_id: product['id'],
                                                  Category_id:
                                                      product['mainCategory'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 173, 173, 173),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height:
                                                      160, // Adjusted height to accommodate the images
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          recenlyviewd[index][
                                                              'image']), // Using NetworkImage directly
                                                      // fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    recenlyviewd[index]['name'],
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        '\₹${recenlyviewd[index]['salePrice']}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (discountproducts.isNotEmpty)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: const Color.fromARGB(255, 237, 232, 217),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("Discounts for you",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Discount_Products(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .white, // Set white background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      child: Text(
                                        'See More',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: (discountproducts.length > 4)
                                    ? 4
                                    : discountproducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final product = discountproducts[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Product_big_View(
                                              product_id: product['id'],
                                              Category_id:
                                                  product['mainCategory'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 211, 211, 211),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Image.network(
                                              product['image'],
                                              width: 100,
                                              height: 100,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                product['name'],
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                ' \₹${product['price']}',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                ' \₹${product['salePrice']}',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            if (product['discount'] != null)
                                              Text(
                                                  'Discount: ${product['discount']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (products.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Best Sellers",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: SizedBox(
                                height:
                                    220, // Adjusted height to accommodate the images
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: 150, // Adjust the width as needed
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        // color: Color.fromARGB(255, 244, 238, 238),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 173, 173, 173)),

                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black.withOpacity(0.1),
                                        //     blurRadius: 3,
                                        //     spreadRadius: 2,
                                        //     offset: Offset(0, 2),
                                        //   ),
                                        // ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height:
                                                160, // Adjusted height to accommodate the images
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(products[
                                                        index][
                                                    'image']), // Using NetworkImage directly
                                                // fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              products[index]['name'],
                                              style: TextStyle(fontSize: 12),
                                              // maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              '\₹${products[index]['salePrice']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        if (buyonegetoneproducts.isNotEmpty)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Color.fromARGB(255, 254, 229, 153),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text("Buy 1 Get 1 Free",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Buyone_Getone_Products(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors
                                                .white, // Set white background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          child: Text(
                                            'See More',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    children: List.generate(
                                      (buyonegetoneproducts.length > 4)
                                          ? 4
                                          : buyonegetoneproducts.length,
                                      (index) {
                                        final product =
                                            buyonegetoneproducts[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Product_big_View(
                                                    product_id: product['id'],
                                                    Category_id:
                                                        product['mainCategory'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 211, 211, 211),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    product['image'],
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: Text(
                                                      product['name'],
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: Text(
                                                      '\₹${product['price']}',
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: Text(
                                                      '\₹${product['salePrice']}',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                  if (product['discount'] !=
                                                      null)
                                                    Text(
                                                        'Discount: ${product['discount']}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (offers.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "All Offers",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: SizedBox(
                                height: 240,
                                child: Container(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: offers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: 220,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 219, 217, 217)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 3,
                                              spreadRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Container(
                                                height:
                                                    140, // Adjusted height to accommodate the images
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(offers[
                                                            index][
                                                        'image']), // Using NetworkImage directly
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Center(
                                              child: Text(
                                                offers[index]['name'],
                                                style: TextStyle(fontSize: 12),
                                                // maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OfferProducts(
                                                                  offerId: offers[
                                                                          index]
                                                                      ['id'])));
                                                  // Add your onPressed function here
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Collect Now",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        if (bestsaleproducts.isNotEmpty)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                // color: Color.fromARGB(255, 205, 205, 196),
                                child: Column(
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Text("Discounts for you",
                                //   style: TextStyle(fontWeight: FontWeight.bold)),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("Best Sale",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Bestsale_Products(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .white, // Set white background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                        child: Text(
                                          'See More',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: ((bestsaleproducts.length > 6)
                                          ? 6
                                          : bestsaleproducts.length) ~/
                                      3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int startIndex = index * 3;
                                    final int endIndex = startIndex + 3;

                                    return Row(
                                      children: List.generate(
                                        endIndex - startIndex,
                                        (i) {
                                          final productIndex = startIndex + i;
                                          final product =
                                              bestsaleproducts[productIndex];
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Product_big_View(
                                                        product_id:
                                                            product['id'],
                                                        Category_id: product[
                                                            'mainCategory'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 211, 211, 211),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Image.network(
                                                        product['image'],
                                                        width: 90,
                                                        height: 90,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          product['name'],
                                                          style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(left: 10, right: 10),
                                                      //   child: Text(
                                                      //     '\₹${product['price']}',
                                                      //     style: TextStyle(decoration: TextDecoration.lineThrough),
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          '\₹${product['salePrice']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      if (product['discount'] !=
                                                          null)
                                                        Text(
                                                            'Discount: ${product['discount']}'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (flashsaleproducts.isNotEmpty)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                color: Color.fromARGB(255, 196, 220, 193),
                                child: Column(
                                  children: [
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     Text("Discounts for you",
                                    //   style: TextStyle(fontWeight: FontWeight.bold)),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text("Flash Deals",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FlashSaleProducts(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .white, // Set white background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            child: Text(
                                              'See More',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      children: List.generate(
                                        (flashsaleproducts.length > 4)
                                            ? 4
                                            : flashsaleproducts.length,
                                        (index) {
                                          final product =
                                              flashsaleproducts[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product_big_View(
                                                      product_id: product['id'],
                                                      Category_id: product[
                                                          'mainCategory'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 211, 211, 211),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      product['image'],
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        product['name'],
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        '\₹${product['price']}',
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        ' \₹${product['salePrice']}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    if (product['discount'] !=
                                                        null)
                                                      Text(
                                                          'Discount: ${product['discount']}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (buytwogetoneproducts.isNotEmpty)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              // color: Color.fromARGB(255, 205, 205, 196),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Buy Two Get One",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Buytwo_Getone_Products(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors
                                                .white, // Set white background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          child: Text(
                                            'See More',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      double itemWidth =
                                          (constraints.maxWidth - 32) / 3;
                                      double itemHeight = itemWidth + 60;

                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            (buytwogetoneproducts.length > 6)
                                                ? 6
                                                : buytwogetoneproducts.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 8.0,
                                          crossAxisSpacing: 8.0,
                                          childAspectRatio:
                                              itemWidth / itemHeight,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final product =
                                              buytwogetoneproducts[index];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Product_big_View(
                                                    product_id: product['id'],
                                                    Category_id:
                                                        product['mainCategory'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: itemWidth,
                                              height: itemHeight,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 211, 211, 211),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    product['image'],
                                                    width: itemWidth * 0.6,
                                                    height: itemWidth * 0.6,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      product['name'],
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      '\₹${product['price']}',
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      '\₹${product['salePrice']}',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  if (product['discount'] !=
                                                      null)
                                                    Text(
                                                        'Discount: ${product['discount']}'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        if (recommendedproducts.isNotEmpty)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                color: Color.fromARGB(255, 217, 219, 221),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text("Recommended Products",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Recommended_products(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .white, // Set white background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            child: Text(
                                              'See More',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      children: List.generate(
                                        (recommendedproducts.length > 4)
                                            ? 4
                                            : recommendedproducts.length,
                                        (index) {
                                          final product =
                                              recommendedproducts[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product_big_View(
                                                      product_id: product['id'],
                                                      Category_id: product[
                                                          'mainCategory'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 211, 211, 211),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      recommendedproducts[index]
                                                          ['image'],
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        recommendedproducts[
                                                            index]['name'],
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                    if (recommendedproducts[
                                                            index]['price'] !=
                                                        null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          '\₹${recommendedproducts[index]['price']}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        ' \₹${recommendedproducts[index]['salePrice']}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    if (product['discount'] !=
                                                        null)
                                                      Text(
                                                          'Discount: ${recommendedproducts[index]['discount']}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (halfrateproducts.isNotEmpty)
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Offer Products",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(), // This will push the ElevatedButton to the right end
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HalfRate_Products(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .white, // Set white background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      child: Text(
                                        'See More',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: SizedBox(
                                height:
                                    220, // Adjusted height to accommodate the images
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: halfrateproducts.length >= 4
                                      ? 4
                                      : halfrateproducts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final product = halfrateproducts[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Product_big_View(
                                              product_id: product['id'],
                                              Category_id:
                                                  product['mainCategory'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            150, // Adjust the width as needed
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 173, 173, 173),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height:
                                                      160, // Adjusted height to accommodate the images
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          product['image']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    product['name'],
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    '\₹${product['price']}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    '\₹${product['salePrice']}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (product['offer_type'] != null)
                                              Positioned(
                                                top: 5,
                                                left: 5,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    '${product['offer_type']} OFF',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
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
                  _index = index;
                  if (index == 2) {
                    _showSearchDialog(context);
                  }
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                    // Navigate to Cart page
                  },
                ),
                GButton(
                  icon: Icons.search,
                  onPressed: () {
                    //  Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => search()));
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
