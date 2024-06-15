import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/filterhightolow.dart';
import 'package:bepocart/filterlowtohigh.dart';
import 'package:bepocart/homepage.dart';
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
      "https://varied-assured-rt-hearing.trycloudflare.com/category/";
  List<Map<String, dynamic>> categoryProducts = [];
  List<bool> isFavorite = [];

  int _selectedIndex = 0; // Index of the selected tab
  List<Map<String, dynamic>> searchResults = [];

  TextEditingController searchitem = TextEditingController();
  final String searchproducturl =
      "https://varied-assured-rt-hearing.trycloudflare.com/search-products/?q=";
  final String lowtohigh =
      "https://varied-assured-rt-hearing.trycloudflare.com/products/filter/";
  final String hightolow =
      "https://varied-assured-rt-hearing.trycloudflare.com/products/filtering/";
  bool _isSearching = false;
  int _index = 0;
  List<Map<String, dynamic>> lowtohighresult = [];
  List<Map<String, dynamic>> hightolowresult = [];
  @override
  void initState() {
    super.initState();
    fetchCatProducts();
    bbb();
  }

  void bbb() {
    print(
        "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu${widget.categoryId}");
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
              "https://varied-assured-rt-hearing.trycloudflare.com/${productData['image']}";
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

  Future<void> fetchCatProducts() async {
    try {
      final response = await http.get(
          Uri.parse('$productsurl${widget.categoryId.toString()}/products/'));
      print('$productsurl${widget.categoryId}');
      print("QQQQQQQQQQQQQQQQQQQQQQQQQ$response");
      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO$productsData");
        List<Map<String, dynamic>> productsList = [];
        List<bool> favoritesList = [];
        for (var productData in productsData) {
          // Fetch image URL
          // ignore: prefer_interpolation_to_compose_strings
          String imageUrl =
              "https://varied-assured-rt-hearing.trycloudflare.com/${productData['image']}";
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
      print('Error fetching category products: $error');
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

  // Future<void> LowtoHigh(int subcategoryId) async {
  //   print(subcategoryId);
  //   final token = await gettokenFromPrefs();
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$lowtohigh$subcategoryId/'),
  //       headers: {
  //         'Authorization': '$token',
  //       },
  //       body: ({'pk': subcategoryId.toString()}),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> searchData = jsonDecode(response.body);
  //       List<Map<String, dynamic>> searchList = [];

  //       for (var productData in searchData) {
  //         String imageUrl =
  //             "https://varied-assured-rt-hearing.trycloudflare.com//${productData['image']}";
  //         searchList.add({
  //           'id': productData['id'],
  //           'name': productData['name'],
  //           'price': productData['price'],
  //           'salePrice': productData['salePrice'],
  //           'image': imageUrl,
  //           'category_id': productData['mainCategory'],
  //         });
  //       }
  //       setState(() {
  //         lowtohighresult = searchList;
  //         print('llllllllllllllllll22222222hhhhhhhhhhhhhhhh$lowtohighresult');
  //       });
  //     } else {
  //       print('Failed to search item: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error fetching product: $error');
  //   }
  // }

  // Future<String?> gettokenFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }

  // Future<void> HightoLow(int subcategoryId) async {
  //   print(subcategoryId);
  //   final token = await gettokenFromPrefs();
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$hightolow$subcategoryId/'),
  //       headers: {
  //         'Authorization': '$token',
  //       },
  //       body: ({'pk': subcategoryId.toString()}),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> searchData = jsonDecode(response.body);
  //       List<Map<String, dynamic>> searchList = [];

  //       for (var productData in searchData) {
  //         String imageUrl =
  //             "https://varied-assured-rt-hearing.trycloudflare.com//${productData['image']}";
  //         searchList.add({
  //           'id': productData['id'],
  //           'name': productData['name'],
  //           'price': productData['price'],
  //           'salePrice': productData['salePrice'],
  //           'image': imageUrl,
  //           'category_id': productData['mainCategory'],
  //         });
  //       }
  //       setState(() {
  //         hightolowresult = searchList;
  //         print('hhhhhhhhhh222222222lllllllllllllll$hightolowresult');
  //       });
  //     } else {
  //       print('Failed to search item: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error fetching product: $error');
  //   }
  // }

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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wishlist()));
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
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 10,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         showModalBottomSheet(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return Container(
          //               height: 130,
          //               child: Column(
          //                 children: [
          //                   ListTile(
          //                     title: Text('High to Low'),
          //                     onTap: () async {
          //                       await HightoLow(widget.subcategoryId);
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => hightolowpage(
          //                                   result: hightolowresult,
          //                                   SubcatId: widget.subcategoryId)));
          //                     },
          //                   ),
          //                   ListTile(
          //                     title: Text('Low to High'),
          //                     onTap: () async {
          //                       await LowtoHigh(widget.subcategoryId);
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => lowtohighpage(
          //                                   result: lowtohighresult,
          //                                   SubcatId: widget.subcategoryId)));
          //                     },
          //                   ),
          //                 ],
          //               ),
          //             );
          //           },
          //         );
          //       },
          //       child: Container(
          //         width: 100,
          //         height: 40,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10.0),
          //           border: Border.all(
          //             color:
          //                 Colors.black, // Specify the color of the border here
          //             width: 1.0, // Specify the width of the border here
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.1),
          //               blurRadius: 3,
          //               spreadRadius: 2,
          //               offset: Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment
          //               .center, // Center the text horizontally
          //           children: [
          //             Text("Sort By"),
          //             SizedBox(width: 5),
          //             Image.asset(
          //               "lib/assets/sort.png",
          //               width: 24,
          //               height: 24,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 20,
          //     ),
          //     Container(
          //       width: 100,
          //       height: 40,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(10.0),
          //         border: Border.all(
          //           color: Colors.black, // Specify the color of the border here
          //           width: 1.0, // Specify the width of the border here
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.1),
          //             blurRadius: 3,
          //             spreadRadius: 2,
          //             offset: Offset(0, 2),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         mainAxisAlignment:
          //             MainAxisAlignment.center, // Center the text horizontally
          //         children: [
          //           Text("Filter"),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           Image.asset(
          //             "lib/assets/filter.png",
          //             width: 24,
          //             height: 24,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
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
                                        Category_id: int.parse(
                                            categoryProducts[firstItemIndex]
                                                ['category_id']),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error navigating: $e');
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
