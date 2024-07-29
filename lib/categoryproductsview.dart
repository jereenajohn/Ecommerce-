import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/filterhightolow.dart';
import 'package:bepocart/filterlowtohigh.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProductView extends StatefulWidget {
  const CategoryProductView({required this.categoryId});
  final int categoryId;

  @override
  State<CategoryProductView> createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  final String productsurl =
      "http://51.20.129.52/category/";
  List<Map<String, dynamic>> categoryProducts = [];
  List<bool> isFavorite = [];

  int _selectedIndex = 0; // Index of the selected tab
  List<Map<String, dynamic>> searchResults = [];

  TextEditingController searchitem = TextEditingController();
  final String searchproducturl =
      "http://51.20.129.52/search-products/?q=";
  final String lowtohigh =
      "http://51.20.129.52/products/filter/";
  final String hightolow =
      "http://51.20.129.52/products/filtering/";
  bool _isSearching = false;
  int _index = 0;
  List<Map<String, dynamic>> lowtohighresult = [];
  List<Map<String, dynamic>> hightolowresult = [];
  var tokenn;
  @override
  void initState() {
    super.initState();
    fetchCatProducts();
    _initData();
  }

  Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

 

  Future<void> searchproduct() async {
    try {
      final response = await http.get(
        Uri.parse('$searchproducturl${searchitem.text}'),
      );
     

      if (response.statusCode == 200) {

        final List<dynamic> searchData = jsonDecode(response.body);
        List<Map<String, dynamic>> searchList = [];

        for (var productData in searchData) {
          String imageUrl =
              "${productData['image']}";
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
        });
      } else {
      
      }
    } catch (error) {
    }
  }

  Future<void> fetchCatProducts() async {
    try {
      final response = await http.get(
          Uri.parse('$productsurl${widget.categoryId.toString()}/products/'));
     
      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        List<Map<String, dynamic>> productsList = [];
        List<bool> favoritesList = [];
        for (var productData in productsData) {
          // Fetch image URL
          // ignore: prefer_interpolation_to_compose_strings
          String imageUrl =
              "${productData['image']}";
          // Convert image to base64
          productsList.add({
            'id': productData['id'],
            'category_id': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
          favoritesList.add(false);
        }
        setState(() {
          categoryProducts = productsList;
          isFavorite = favoritesList;
        });
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (error) {
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });
  }

  Icon buildFavoriteIcon(int index) {
    return Icon(
      isFavorite[index] ? Icons.favorite : Icons.favorite_border,
      color: isFavorite[index] ? Colors.red : Colors.black,
    );
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
                          // Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
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
      body: SingleChildScrollView(
          child: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (categoryProducts.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                int firstItemIndex = index * 2;
                int secondItemIndex = firstItemIndex + 1;

                // Check if this is the last row
                bool isLastRow =
                    index == (categoryProducts.length / 2).ceil() - 1;

                return Column(
                  children: [
                    Row(
                      children: [
                        if (firstItemIndex < categoryProducts.length) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                try {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Product_big_View(
                                        product_id:
                                            categoryProducts[firstItemIndex]
                                                ['id'],
                                        slug: categoryProducts[firstItemIndex]
                                            ['slug'],
                                        Category_id: int.parse(
                                            categoryProducts[firstItemIndex]
                                                ['category_id']),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                }
                              },
                              child: Container(
                                height: 250,
                                margin: EdgeInsets.only(
                                  right: (secondItemIndex <
                                              categoryProducts.length ||
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
                                                    categoryProducts[
                                                            firstItemIndex]
                                                        ['image'],
                                                  ),
                                                  // fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              toggleFavorite(firstItemIndex);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              categoryProducts[firstItemIndex]
                                                  ['name'],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          if (categoryProducts[firstItemIndex]
                                                  ['price'] !=
                                              null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                '\$${categoryProducts[firstItemIndex]['price']}',
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
                                              'Sale Price: \$${categoryProducts[firstItemIndex]['salePrice']}',
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
                        if (secondItemIndex < categoryProducts.length) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Product_big_View(
                                              product_id: categoryProducts[
                                                  secondItemIndex]['id'],
                                              slug: categoryProducts[
                                                  firstItemIndex]['slug'],
                                              Category_id: int.parse(
                                                  categoryProducts[
                                                          secondItemIndex]
                                                      ['category_id']),
                                            )));
                              },
                              child: Container(
                                height: 250,
                                margin: EdgeInsets.only(
                                  left: (firstItemIndex <
                                              categoryProducts.length ||
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
                                              categoryProducts[secondItemIndex]
                                                  ['image'],
                                              width: 150,
                                              height: 150,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              toggleFavorite(secondItemIndex);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              categoryProducts[secondItemIndex]
                                                  ['name'],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          if (categoryProducts[secondItemIndex]
                                                  ['price'] !=
                                              null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                '\$${categoryProducts[secondItemIndex]['price']}',
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
                                              'Sale Price: \$${categoryProducts[firstItemIndex]['salePrice']}',
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
        ],
      )),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
