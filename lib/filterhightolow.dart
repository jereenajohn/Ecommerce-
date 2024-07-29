import 'dart:convert';
import 'package:bepocart/cart.dart';
import 'package:bepocart/filterlowtohigh.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class hightolowpage extends StatefulWidget {
  final List<Map<String, dynamic>> result;
  final int SubcatId;

  hightolowpage({Key? key, required this.result, required this.SubcatId}) : super(key: key);

  @override
  State<hightolowpage> createState() => _hightolowpageState();
}

class _hightolowpageState extends State<hightolowpage> {
  List<bool> isFavorite = [];
    List<Map<String, dynamic>> searchResults = [];
      TextEditingController searchitem = TextEditingController();

      final String searchproducturl =
      "http://51.20.129.52/products/search/?q=";
  bool _isSearching = false;
    int _index = 0;
      int _selectedIndex = 0;
      var tokenn;





  @override
  void initState() {
    super.initState();
     _initData();
    isFavorite = List<bool>.filled(widget.result.length, false);
   
  }

   Future<void> _initData() async {
    tokenn = await gettokenFromPrefs();

    // Use userId after getting the value
  }


  final String lowtohigh = "http://51.20.129.52/low-products/";
  List<Map<String, dynamic>> lowtohighresult = [];

  Future<void> LowtoHigh(int subcategoryId) async {
    final token = await gettokenFromPrefs();
    try {
      final response = await http.get(
        Uri.parse('$lowtohigh$subcategoryId/'),
        headers: {
          'Authorization': '$token',
        },
       
      );

      if (response.statusCode == 200) {
        final List<dynamic> searchData = jsonDecode(response.body);
        List<Map<String, dynamic>> searchList = [];

        for (var productData in searchData) {
          String imageUrl = "http://51.20.129.52/${productData['image']}";
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

  final String wishlisturl = "http://51.20.129.52/whishlist/";

  void toggleFavorite(int index) {
    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    if (isFavorite[index]) {
      addProductToWishlist(widget.result[index]['id']);
    }
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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
      } else if (response.statusCode == 400) {
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

  Icon buildFavoriteIcon(int index) {
    return Icon(
      isFavorite[index] ? Icons.favorite : Icons.favorite_border,
      color: isFavorite[index] ? Colors.red : Colors.black,
    );
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
                         
                          await  searchproduct();

                          setState(() {
                            _isSearching = false;

                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search(searchresults:searchResults)));
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
        title: Text('High to Low Price'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 130,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('High to Low'),
                              onTap: () {
                                // Implement High to Low sorting if needed
                              },
                            ),
                            ListTile(
                              title: Text('Low to High'),
                              onTap: () async {
                                await LowtoHigh(widget.SubcatId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => lowtohighpage(
                                      result: lowtohighresult,
                                      SubcatId: widget.SubcatId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sort By"),
                      SizedBox(width: 5),
                      Image.asset(
                        "lib/assets/sort.png",
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Filter"),
                    SizedBox(width: 5),
                    Image.asset(
                      "lib/assets/filter.png",
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: (widget.result.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final productIndex1 = index * 2;
                  final productIndex2 = productIndex1 + 1;

                  return Row(
                    children: [
                      Expanded(
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
                                    widget.result[productIndex1]['image'],
                                    width: double.infinity,
                                    height: 160,
                                    // fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
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
                                      widget.result[productIndex1]['name'] ?? '',
                                      style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      '\$${widget.result[productIndex1]['price'] ?? ''}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '\$${widget.result[productIndex1]['salePrice'] ?? ''}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: productIndex2 < widget.result.length
                            ? Container(
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
                                          widget.result[productIndex2]['image'],
                                          width: double.infinity,
                                          height: 160,
                                          // fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              toggleFavorite(productIndex2);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: buildFavoriteIcon(productIndex2),
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
                                            widget.result[productIndex2]['name'] ?? '',
                                            style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            '\$${widget.result[productIndex2]['price'] ?? ''}',
                                            style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '\$${widget.result[productIndex2]['salePrice'] ?? ''}',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  );
                },
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
