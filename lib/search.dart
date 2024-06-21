import 'dart:convert';
import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String? user_id; // Receive user_id as a parameter
  final List<Map<String, dynamic>> searchresults;

  Search({Key? key, this.user_id, required this.searchresults})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? userId; // Declare userId variable to store user ID
  List<bool> isFavorite = [];
  int _selectedIndex = 0;
  List<Map<String, dynamic>> products = [];
  bool _isSearching = false;
  int _index = 0;
  TextEditingController searchitem = TextEditingController();
  final String wishlisturl =
      "https://lake-badge-stephen-proc.trycloudflare.com//whishlist/";
  final String searchproducturl =
      "https://lake-badge-stephen-proc.trycloudflare.com//search-products/?q=";

  List<Map<String, dynamic>> searchResults = [];
  var tokenn;
  @override
  void initState() {
    super.initState();
    _initData();
    isFavorite = List<bool>.filled(widget.searchresults.length, false);
    print(
        "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB${widget.searchresults}");
  }

   Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();

    print("--------------------------------------------R$userId");
    // Use userId after getting the value
  }


  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    // Check if the product is being added or removed from the wishlist
    if (isFavorite[index]) {
      // If the product is being added to the wishlist
      addProductToWishlist(
        widget.searchresults[index]['id'],
      );
    } else {
      // If the product is being removed from the wishlist
      // You can implement this logic if needed
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
          print(
              "cattttttttttttttttttttttttttttttttppppppppppppppppppppppp$productData");
          String imageUrl =
              "https://lake-badge-stephen-proc.trycloudflare.com/${productData['image']}";
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
          print(
              "5555555555555555555555555555555555555555555555555555555$searchResults");
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

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addProductToWishlist(int productId) async {
    try {
      final token = await gettokenFromPrefs();
      final response = await http.post(
        Uri.parse(wishlisturl),
        headers: {
          'Content-type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
        }),
      );

      if (response.statusCode == 200) {
        print('Product added to wishlist: $productId');
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

  Icon buildFavoriteIcon(int index) {
    return Icon(
      isFavorite[index] ? Icons.favorite : Icons.favorite_border,
      color: isFavorite[index] ? Colors.red : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: (widget.searchresults.length / 2).ceil(),
          itemBuilder: (context, index) {
            final productIndex1 = index * 2;
            final productIndex2 = productIndex1 + 1;

            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print(
                          "PROOOOOOOOOOOOOOOOOOOOOOOIIIIDDDDDDDDD${widget.searchresults[productIndex1]['id']}");
                      print(
                          "CATeeeeeeeeeegggggggooooooooooryiiiiiid${widget.searchresults[productIndex1]['category_id']}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Product_big_View(
                            product_id: widget.searchresults[productIndex1]
                                ['id'],
                            Category_id: widget.searchresults[productIndex1]
                                ['category_id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                widget.searchresults[productIndex1]['image'],
                                width: double.infinity,
                                height: 160,
                                // fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    toggleFavorite(productIndex1);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildFavoriteIcon(productIndex1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.searchresults[productIndex1]['name'] ??
                                      '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Text(
                                  '\$${widget.searchresults[productIndex1]['price'] ?? ''}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${widget.searchresults[productIndex1]['salePrice'] ?? ''}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: productIndex2 < widget.searchresults.length
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Product_big_View(
                                  product_id:
                                      widget.searchresults[productIndex2]['id'],
                                  Category_id:
                                      widget.searchresults[productIndex2]
                                          ['category_id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      widget.searchresults[productIndex2]
                                          ['image'],
                                      width: double.infinity,
                                      height: 160,
                                      // fit: BoxFit.cover,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          toggleFavorite(productIndex2);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              buildFavoriteIcon(productIndex2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.searchresults[productIndex2]
                                                ['name'] ??
                                            '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(
                                        '\$${widget.searchresults[productIndex2]['price'] ?? ''}',
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '\$${widget.searchresults[productIndex2]['salePrice'] ?? ''}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            );
          },
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
    });
  }
}
