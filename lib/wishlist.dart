import 'dart:convert';
import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Wishlist extends StatefulWidget {
  final String? user_id;

  const Wishlist({Key? key, this.user_id}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  String? userId;
  var wishlisturl = "https://303c-59-92-204-108.ngrok-free.app/wishlist/";
  final String productsurl =
      "https://303c-59-92-204-108.ngrok-free.app/products/";

  final String deletewishlisturl =
      "https://303c-59-92-204-108.ngrok-free.app/wishlist-delete/";

  final String addtocarturl =
      "https://303c-59-92-204-108.ngrok-free.app/cart/";
  List<Map<String, dynamic>> products = [];
  List<dynamic> productIds = [];
  List<dynamic> WishlistIds = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    print("--------------------------------------------R$userId");
    FetchWishlistData();
    fetchProducts();
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> FetchWishlistData() async {
    final token = await gettokenFromPrefs();
    print("--------------------------------------------R$token");

    var response = await http.post(Uri.parse(wishlisturl), headers: {
      'Authorization': '$token',
    }, body: {
      'token': token,
    });

    print("FetchWishlistData status code: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      List<int> ids = [];
      List<int> wishlistId = [];

      for (var item in data) {
        ids.add(item['product']);
        wishlistId.add(item['id']);
      }

      setState(() {
        productIds = ids;
        WishlistIds = wishlistId;
        print(productIds);
        print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm$WishlistIds");
      });
    } else {
      print("Failed to fetch wishlist data");
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsurl));
      print('fetchProducts Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> productsData = parsed['products'];
        List<Map<String, dynamic>> filteredProducts = [];

        print(
            "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYUUUUUUUUUUUUUUUUUUUUUIIIIIIIIIIIIIIIIIIIIIIII$productsData");
        for (var productData in productsData) {
          print(productIds);

          if (productIds.contains(productData['id'])) {
            String imageUrl =
                "https://303c-59-92-204-108.ngrok-free.app/${productData['image']}";
            filteredProducts.add({
              'id': productData['id'],
              'name': productData['name'],
              'SalePrice': productData['salePrice'],
              'image': imageUrl,
              'mainCategory': productData['mainCategory']
            });
          }
        }

        setState(() {
          products = filteredProducts;
          print("EWWWWWWWWWWWWWWWWWWWWWWWWWWWEEEEEEEEEEEEEEEEEEEEEE$products");
        });

        print("-------------------------------$products");
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      print('Error fetching wishlist products: $error');
    }
  }

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> deleteWishlistProduct(int wishlistId) async {
    print("fvvvvvvvvvvvvvvvvvvvvvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjv$wishlistId");
    try {
      print('$deletewishlisturl$wishlistId/');
      final response = await http.delete(
        Uri.parse('$deletewishlisturl$wishlistId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print("uuuuuuuuuuuuuuuuuuuuuuuuuu");
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 204) {
        print('Wishlist ID deleted successfully: $wishlistId');
      } else {
        throw Exception('Failed to delete wishlist ID: $wishlistId');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addProductToCart(int productId, var name, var price) async {
    try {
      print('AAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL$addtocarturl$productId/');
      final token = await gettokenFromPrefs();

      final response = await http.post(
        Uri.parse('$addtocarturl$productId/'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': ' $token',
        },
        body: jsonEncode({
          'token': token,
          'product': productId,
          'name': name,
          'price': price
        }),
      );

      if (response.statusCode == 201) {
        print('Product added to cart: $productId');
      } else if (response.statusCode == 400) {
        // Product already in cart, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already in Cart'),
          ),
        );
      } else {
        print('Failed to add product to cart: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error adding product to cart: $error');
    }
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
            icon: Image.asset(
              "lib/assets/bag.png",
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print(
                  "iddddddddddddddddddddddddddddddddddd${products[index]['id']}");
              print(
                  "iddddddddddddddddddddddddddddduuuuuuuuuuuu${products[index]['mainCategory']}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Product_big_View(
                    product_id: products[index]['id'],
                    Category_id: products[index]['mainCategory'],
                  ),
                ),
              );
            },
            child: Container(
              height: 150,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: 150,
                    width: 150,
                    child: Image.network(
                      products[index]['image'],
                      width: 150, // Specific width for the image
                      height: 150, // Maintain aspect ratio
                      // fit: BoxFit.cover, // Adjust the BoxFit property as needed
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between image and text
                  Expanded(
                    // Use Expanded for flexible width
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index]['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 5), // Add spacing between name and price
                          Text(
                            '\$${products[index]['SalePrice']}',
                            style: TextStyle(
                              fontSize: 14, // Adjust font size as needed
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          ElevatedButton(
                            onPressed: () {
                              addProductToCart(
                                  products[index]['id'],
                                  products[index]['name'],
                                  products[index]['price']);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(double.infinity,
                                  20), // Adjust the width and height as needed
                            ),
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between text and icon
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("delettttttttttttttttttttttttttttttttttttttiddd${WishlistIds[index]}");
                            deleteWishlistProduct(WishlistIds[index]);
                            removeProduct(index);
                          },
                          child: ImageIcon(
                            AssetImage('lib/assets/hert.png'),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // child: ListTile(
              //   title: Text(products[index]['name']),
              //   subtitle: Text('\$${products[index]['price']}'),
              //   leading: Container(
              //     width: 100, // Adjust the width as needed
              //     height: 190, // Adjust the height to match ListTile height
              //     child: Image.network(
              //       products[index]['image'],
              //       fit: BoxFit.cover, // Adjust the BoxFit property as needed
              //     ),
              //   ),
              //   trailing: GestureDetector(
              //     onTap: () {
              //       deleteWishlistProduct(WishlistIds[index]);
              //       removeProduct(index);
              //     },
              //     child: Icon(Icons.close),
              //   ),
              // ),
            ),
          );
        },
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
    });
  }
}
