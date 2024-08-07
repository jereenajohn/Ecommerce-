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
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OfferProducts extends StatefulWidget {
  final String? user_id;
  OfferProducts({Key? key, this.user_id, required this.offerId})
      : super(key: key);
  final int offerId;

  @override
  State<OfferProducts> createState() => _OfferProductsState();
}

class _OfferProductsState extends State<OfferProducts> {
  String? userId;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> lowtohighresult = [];
  List<Map<String, dynamic>> hightolowresult = [];

  TextEditingController searchitem = TextEditingController();
  final String searchproducturl =
      "http://51.20.129.52/search-products/?q=";
  bool _isSearching = false;
  int _index = 0;
  int _selectedIndex = 0;
  List<bool> isFavorite = [];

  final String offerproductsurl =
      "http://51.20.129.52/offer-banner/";

  final String wishlisturl =
      "http://51.20.129.52/add-wishlist/";

  final String lowtohigh =
      "http://51.20.129.52/low-products/";
  final String hightolow =
      "http://51.20.129.52/high-products/";
  var tokenn;

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();

    fetchOfferProducts();
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    // Check if the product is being added or removed from the wishlist
    if (isFavorite[index]) {
      // If the product is being added to the wishlist
      addProductToWishlist(
        products[index]['id'],
      );
    } else {
      // If the product is being removed from the wishlist
      // You can implement this logic if needed
    }
  }

  Future<void> LowtoHigh(int subcategoryId) async {
    final token = await gettokenFromPrefs();
    try {
      final response = await http.post(
        Uri.parse('$lowtohigh$subcategoryId/'),
        headers: {
          'Authorization': '$token',
        },
        body: ({'pk': subcategoryId.toString()}),
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
          lowtohighresult = searchList;
        });
      } else {
      
      }
    } catch (error) {
    }
  }

  Future<void> HightoLow(int subcategoryId) async {
  
    final token = await gettokenFromPrefs();
    try {
      final response = await http.post(
        Uri.parse('$hightolow$subcategoryId/'),
        headers: {
          'Authorization': '$token',
        },
        body: ({'pk': subcategoryId.toString()}),
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
          hightolowresult = searchList;
        });
      } else {
        
      }
    } catch (error) {
    }
  }

  Future<void> addProductToWishlist(int productId) async {
    try {
      final token = await gettokenFromPrefs();

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


      if (response.statusCode == 201) {
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
       
      }
    } catch (error) {
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

  Future<void> fetchOfferProducts() async {
    final token = await gettokenFromPrefs();
  
    var response = await http.post(
      Uri.parse('$offerproductsurl${widget.offerId}/products/'),
      headers: {
        'Authorization': '$token',
      },
      body: {
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final List<dynamic> productsData = parsed['products'];

      List<Map<String, dynamic>> productsList = [];
      for (var productData in productsData) {
        productsList.add({
          'id': productData['id'],
          'mainCategory': productData['mainCategory'],
          'name': productData['name'],
          'image':
              "${productData['image']}",
          'price': productData['price'],
          'salePrice': productData['salePrice'],
        });
      }

      setState(() {
        products = productsList;
        isFavorite = List<bool>.filled(products.length, false);
      });
    } else {
    }
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
          'Offer Products',
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
            //    Row(
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
                itemCount: (products.length / 2).ceil(),
                itemBuilder: (BuildContext context, int index) {
                  int firstItemIndex = index * 2;
                  int secondItemIndex = firstItemIndex + 1;

                  // Check if this is the last row
                  bool isLastRow = index == (products.length / 2).ceil() - 1;

                  return Column(
                    children: [
                      Row(
                        children: [
                          if (firstItemIndex < products.length) ...[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Product_big_View(
                                          product_id: products[firstItemIndex]
                                              ['id'],
                                          slug: products[firstItemIndex]['slug'],
                                          Category_id: int.parse(
                                            products[firstItemIndex]
                                                ['mainCategory'],
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                  }
                                },
                                child: Container(
                                  height: 250,
                                  margin: EdgeInsets.only(
                                    right: (secondItemIndex < products.length ||
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                      products[firstItemIndex]
                                                          ['image'],
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
                                                products[firstItemIndex]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            if (products[firstItemIndex]
                                                    ['price'] !=
                                                null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  '\$${products[firstItemIndex]['price']}',
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
                                                'Sale Price: \$${products[firstItemIndex]['salePrice']}',
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
                          if (secondItemIndex < products.length) ...[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Product_big_View(
                                                product_id:
                                                    products[secondItemIndex]
                                                        ['id'],
                                              slug: products[secondItemIndex]['slug'],
                                                Category_id: int.parse(
                                                    products[secondItemIndex]
                                                        ['mainCategory']),
                                              )));
                                },
                                child: Container(
                                  height: 250,
                                  margin: EdgeInsets.only(
                                    left: (firstItemIndex < products.length ||
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                products[secondItemIndex]
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
                                                products[secondItemIndex]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            if (products[secondItemIndex]
                                                    ['price'] !=
                                                null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  '\$${products[secondItemIndex]['price']}',
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
                                                'Sale Price: \$${products[secondItemIndex]['salePrice']}',
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
