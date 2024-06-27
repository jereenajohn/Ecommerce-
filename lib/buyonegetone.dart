import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Buyone_Getone_Products extends StatefulWidget {
  final String? user_id; // Receive user_id as a parameter

  const Buyone_Getone_Products({Key? key, this.user_id}) : super(key: key);

  @override
  State<Buyone_Getone_Products> createState() => _Buyone_Getone_ProductsState();
}

class _Buyone_Getone_ProductsState extends State<Buyone_Getone_Products> {
  String? userId; // Declare userId variable to store user ID
  int _selectedIndex = 0; // Index of the selected tab
  List<bool> isFavorite = [];
  var tokenn;

  final String buyonegetoneurl =
      "https://michelle-miniature-depot-studied.trycloudflare.com/buy-1-get-1/";
  List<Map<String, dynamic>> buyonegetoneproducts = [];
  TextEditingController searchitem = TextEditingController();
  final String searchproducturl =
      "https://michelle-miniature-depot-studied.trycloudflare.com/products/search/?q=";

  final String wishlisturl =
      "https://michelle-miniature-depot-studied.trycloudflare.com/add-wishlist/";

  List<Map<String, dynamic>> products = [];

  bool _isSearching = false;
  int _index = 0;
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    _initData();
    fetchbuyonegetoneProducts();
  }

   Future<void> _initData() async {
        tokenn = await gettokenFromPrefs();

  }

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    // Check if the product is being added or removed from the wishlist
    if (isFavorite[index]) {
      // If the product is being added to the wishlist
      addProductToWishlist(
        buyonegetoneproducts[index]['id'],
      );
    } else {
      // If the product is being removed from the wishlist
      // You can implement this logic if needed
    }
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Icon buildFavoriteIcon(int index) {
    if (index < isFavorite.length) {
      return Icon(
        isFavorite[index] ? Icons.favorite : Icons.favorite_border,
        color: isFavorite[index] ? Colors.red : Colors.black,
      );
    }
    return Icon(Icons.favorite_border, color: Colors.black);
  }

  Future<void> addProductToWishlist(int productId) async {
    try {
      final token = await gettokenFromPrefs();

      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB$token");
      final response = await http.post(
        Uri.parse('${wishlisturl}${productId}/'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
        }),
      );

      print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ$response");

      if (response.statusCode == 201) {
        print('Product added to wishlist: $productId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to wishlist'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 400) {
        // Product already in wishlist, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already in wishlist'),
          ),
        );
      } else {
        print('Failed to add product to wishlist: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error adding product to wishlist: $error');
    }
  }

  Future<void> searchproduct() async {
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
              "https://michelle-miniature-depot-studied.trycloudflare.com${productData['image']}";
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Search(searchresults: searchResults)));
                          });
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

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void fetchbuyonegetoneProducts() async {
    try {
      final response = await http.get(Uri.parse(buyonegetoneurl));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        List<Map<String, dynamic>> productbuyonegetoneList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://michelle-miniature-depot-studied.trycloudflare.com/${productData['image']}";
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
          // Initialize isFavorite list with the same length as products list
          isFavorite =
              List.generate(buyonegetoneproducts.length, (index) => false);
        });
      } else {
        throw Exception('Failed to load Buy One Get One products');
      }
    } catch (error) {
      print('Error fetching Buy One Get One products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buy One Get One',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
               if (tokenn == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login_Page()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wishlist()));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (buyonegetoneproducts.length / 2).ceil(),
            itemBuilder: (BuildContext context, int index) {
              int firstItemIndex = index * 2;
              int secondItemIndex = firstItemIndex + 1;

              // Check if this is the last row
              bool isLastRow =
                  index == (buyonegetoneproducts.length / 2).ceil() - 1;

              return Column(
                children: [
                  Row(
                    children: [
                      if (firstItemIndex < buyonegetoneproducts.length) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              try {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Product_big_View(
                                          product_id:
                                              buyonegetoneproducts[firstItemIndex]
                                                  ['id'],
                                          Category_id:
                                              buyonegetoneproducts[firstItemIndex]
                                                  ['mainCategory'])));
                              } catch (e) {
                                print('Error navigating: $e');
                              }
                            },
                            child: Container(
                              height: 250,
                              margin: EdgeInsets.only(
                                right: (secondItemIndex <
                                            buyonegetoneproducts.length ||
                                        isLastRow)
                                    ? 5
                                    : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  buyonegetoneproducts[
                                                      firstItemIndex]['image'],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            toggleFavorite(firstItemIndex);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: buildFavoriteIcon(
                                                firstItemIndex),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            buyonegetoneproducts[firstItemIndex]
                                                ['name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            '\$${buyonegetoneproducts[firstItemIndex]['price']}',
                                            style: TextStyle(
                                              decoration: TextDecoration
                                                  .lineThrough, // Add strikethrough decoration
                                              color: Colors
                                                  .grey, // You can adjust the color according to your design
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            'Sale Price: \$${buyonegetoneproducts[firstItemIndex]['salePrice']}',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (secondItemIndex < buyonegetoneproducts.length) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Product_big_View(
                                          product_id:
                                              buyonegetoneproducts[secondItemIndex]
                                                  ['id'],
                                          Category_id:
                                              buyonegetoneproducts[secondItemIndex]
                                                  ['mainCategory'])));
                            },
                            child: Container(
                              height: 250,
                              margin: EdgeInsets.only(
                                left: (firstItemIndex <
                                            buyonegetoneproducts.length ||
                                        isLastRow)
                                    ? 5
                                    : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            buyonegetoneproducts[
                                                secondItemIndex]['image'],
                                            width: 150,
                                            height: 150,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            toggleFavorite(secondItemIndex);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: buildFavoriteIcon(
                                                secondItemIndex),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            buyonegetoneproducts[
                                                secondItemIndex]['name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            '\$${buyonegetoneproducts[secondItemIndex]['price']}',
                                            style: TextStyle(
                                              decoration: TextDecoration
                                                  .lineThrough, // Add strikethrough decoration
                                              color: Colors
                                                  .grey, // You can adjust the color according to your design
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            'Sale Price: \$${buyonegetoneproducts[secondItemIndex]['salePrice']}',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
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
                    if (tokenn == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_Page()));
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
    );
  }
}
