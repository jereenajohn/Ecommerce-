import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
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
  var wishlisturl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/wishlist/";
  final String productsurl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/products/";

  final String deletewishlisturl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/wishlist-delete/";

  final String addtocarturl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/cart/";
  List<Map<String, dynamic>> products = [];
  List<dynamic> productIds = [];
  List<dynamic> WishlistIds = [];
  Map<int, int> productWishlistMap = {};

  int _selectedIndex = 0;
  var tokenn;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();

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

    var response = await http.get(
      Uri.parse(wishlisturl),
      headers: {
        'Authorization': '$token',
      },
    );

    print("FetchWishlistData status code: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      List<int> ids = [];
      List<int> wishlistIds = [];

      Map<int, int> localProductWishlistMap = {};

      for (var item in data) {
        int productId = item['product'];
        int wishlistItemId = item['id'];
        ids.add(productId);
        wishlistIds.add(wishlistItemId);
        localProductWishlistMap[productId] = wishlistItemId;

        print("Item::::::::::::::::::::::::::::::::::: $item");
      }

      setState(() {
        productIds = ids;
        wishlistIds = wishlistIds;
        productWishlistMap = localProductWishlistMap;
        print("Product IDs: $productIds");
        print("Wishlist IDs: $wishlistIds");
        print("Product-Wishlist Map: $productWishlistMap");
      });
    } else if (response.statusCode == 401) {
      print("session expired");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Page()));
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

        for (var productData in productsData) {
          var idd = productData['id'];

          if (productIds.contains(idd)) {
            String imageUrl =
                "https://denmark-eagle-house-wedding.trycloudflare.com/${productData['image']}";
            int? wishlistId = productWishlistMap[idd];
            print("Product ID: ${productData['id']}, Wishlist ID: $wishlistId");

            filteredProducts.add({
              'id': productData['id'],
              'name': productData['name'],
              'SalePrice': productData['salePrice'],
              'stock': productData['stock'],
              'image': imageUrl,
              'mainCategory': productData['mainCategory'],
              'wishlistId': wishlistId,
              'slug': productData['slug']
            });
          }
        }

        print("Filtered Products Before SetState: $filteredProducts");
        setState(() {
          products = filteredProducts;
          print("Filtered Products After SetState: $products");
        });

        print("-------------------------------$products");
      } else {
        throw Exception('Failed to load wishlist products');
      }
    } catch (error) {
      print('Error fetching wishlist products: $error');
    }
  }

  final imageurl =
      "https://denmark-eagle-house-wedding.trycloudflare.com/product/";

  List<Map<String, dynamic>> images = [];
  String? selectedColor;
  List<String> colors = [];
  List<String> sizeNames = [];
  String? selectedSize;
  var sizes;
  int? selectedstock;
  Future<void> sizecolor(var slug) async {
    print('======================$imageurl${slug}/r');
    Set<String> colorsSet = {};
    try {
      final response = await http.get(Uri.parse('$imageurl${slug}/'));
      print("statussssssssssssssssssssssssss${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> imageData = data['images'];
        final List<dynamic> variantsData = data['variants'];
        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$imageData");

        List<Map<String, dynamic>> productsList = [];

        for (var imageData in imageData) {
          String imageUrl1 =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${imageData['image1']}";
          String imageUrl2 =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${imageData['image2']}";
          String imageUrl3 =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${imageData['image3']}";
          String imageUrl4 =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${imageData['image4']}";
          String imageUrl5 =
              "https://denmark-eagle-house-wedding.trycloudflare.com/${imageData['image5']}";

          List<Map<String, dynamic>> sizes = variantsData
              .where((variant) => variant['color'] == imageData['id'])
              .map<Map<String, dynamic>>((variant) =>
                  {'size': variant['size'], 'stock': variant['stock']})
              .toList();
          print("sizeeeeee${sizes}");

          productsList.add({
            'id': imageData['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': imageData['color'],
            'sizes': sizes,
          });
          colorsSet.add(imageData['color']);
        }

        setState(() {
          images = productsList;
          colors = colorsSet.toList();

          print("COLORSSSSSSSSSSSSSSSSSSSS$colors");
          selectedColor = colors.isNotEmpty ? colors[0] : null;
          sizes = images.firstWhere(
                  (image) => image['color'] == selectedColor)['sizes'] ??
              [];
          selectedSize = sizes.isNotEmpty ? sizes[0]['size'] : null;
          selectedstock = sizes.isNotEmpty ? sizes[0]['stock'] : null;
        });
      } else {
        throw Exception('Error fetching product image');
      }
    } catch (error) {
      print('Error fetching product image : $error');
    }
  }

  void showBottomSheet(
    int id,
    var slug,
    var name,
    var price,
    BuildContext context,
    List<String> colors,
    List<Map<String, dynamic>> images,
    String? selectedColor,
    List<Map<String, dynamic>> sizes,
    String? selectedSize,
    int? selectedStock,
    Function(String color, List<Map<String, dynamic>> sizeList, String? size,
            int? stock)
        onColorSizeChanged,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be scrollable
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (colors.isNotEmpty)
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Wrap(
                                spacing: 8.0,
                                children: colors.map<Widget>((color) {
                                  return OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: selectedColor == color
                                          ? Color.fromARGB(255, 1, 80, 12)
                                          : Colors.black,
                                      side: BorderSide(
                                        color: selectedColor == color
                                            ? Color.fromARGB(255, 28, 146, 1)
                                            : Colors.black,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setModalState(() {
                                        selectedColor = color;
                                        print("selectedcolorrrr$selectedColor");
                                        sizes = images.firstWhere((image) =>
                                                image['color'] ==
                                                selectedColor)['sizes'] ??
                                            [];
                                        selectedSize = sizes.isNotEmpty
                                            ? sizes[0]['size']
                                            : null;
                                        selectedStock = sizes.isNotEmpty
                                            ? sizes[0]['stock']
                                            : null;
                                        onColorSizeChanged(selectedColor!,
                                            sizes, selectedSize, selectedStock);
                                      });
                                    },
                                    child: Text(color.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (selectedColor != null && sizes.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Wrap(
                                spacing: 8.0,
                                children: sizes.map<Widget>((sizeData) {
                                  return Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        foregroundColor:
                                            selectedSize == sizeData['size']
                                                ? Color.fromARGB(255, 1, 80, 12)
                                                : Colors.black,
                                        side: BorderSide(
                                          color: selectedSize ==
                                                  sizeData['size']
                                              ? Color.fromARGB(255, 28, 146, 1)
                                              : Colors.black,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: sizeData['stock'] > 0
                                          ? () {
                                              setModalState(() {
                                                selectedSize = sizeData['size'];
                                                selectedStock =
                                                    sizeData['stock'];
                                                print(
                                                    "selectedcolorrrr$selectedSize");
                                                print(
                                                    "selectedcolorrrr$selectedStock");
                                                onColorSizeChanged(
                                                    selectedColor!,
                                                    sizes,
                                                    selectedSize,
                                                    selectedStock);
                                              });
                                            }
                                          : null,
                                      child: Center(
                                        child: Text(
                                          sizeData['size'].toUpperCase(),
                                          style: TextStyle(
                                            decoration: sizeData['stock'] == 0
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (selectedStock ?? 0) > 0
                                  ? () {
                                      addProductToCart(id, name, price);
                                      Navigator.pop(context);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: (selectedStock ?? 0) > 0
                                    ? Colors.black
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("ADD TO CART"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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

      if (response.statusCode == 200) {
        print('Wishlist ID deleted successfully: $wishlistId');
      } else {
        throw Exception('Failed to delete wishlist ID: $wishlistId');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addProductToCart(int productId, var name, var price) async {
    print(productId);
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
          'price': price,
          'color': selectedColor,
          'size': selectedSize,
        }),
      );
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        print('Product added to cart: $productId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Product added to Cart'),
          ),
        );
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
              if (tokenn == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login_Page()));
              }
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
                    slug: products[index]['slug'],
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
                    height: 120,
                    width: 120,
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
                              fontSize: 10, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 5), // Add spacing between name and price
                          Text(
                            '\$${products[index]['SalePrice']}',
                            style: TextStyle(
                              fontSize: 12, // Adjust font size as needed
                            ),
                          ),
                          SizedBox(height: 5),
                          // Add spacing between name and price
                          // if (products[index]['stock'] != null &&
                          //     products[index]['stock'] > 0)
                          //   Text(
                          //     "stock ${products[index]['stock']}",
                          //     style: TextStyle(
                          //       fontSize: 10,
                          //       color: Color.fromARGB(255, 217, 29, 29),
                          //     ),
                          //   )
                          // else
                          //   Text(
                          //     "Out of Stock",
                          //     style: TextStyle(
                          //       fontSize: 10,
                          //       color: Color.fromARGB(255, 217, 29, 29),
                          //     ),
                          //   ),
                          SizedBox(
                            height: 5,
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              await sizecolor(products[index]['slug']);
                              if (colors.isNotEmpty) {
                                showBottomSheet(
                                  products[index]['id'],
                                  products[index]['slug'],
                                  products[index]['name'],
                                  products[index]['SalePrice'],
                                  context,
                                  colors,
                                  images,
                                  selectedColor,
                                  sizes,
                                  selectedSize,
                                  selectedstock,
                                  (color, sizeList, size, stock) {
                                    setState(() {
                                      selectedColor = color;
                                      sizes = sizeList;
                                      selectedSize = size;
                                      selectedstock = stock;
                                    });
                                  },
                                );
                              } else {
                                await sizecolor(products[index][
                                    'slug']); // Add await here to ensure the async call is completed
                                addProductToCart(
                                  products[index]['id'],
                                  products[index]['name'],
                                  products[index]['price'],
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(double.infinity,
                                  20), // Adjust the width and height as needed
                            ),
                            child: Text(
                              "ADD TO CART",
                              style:
                                  TextStyle(fontSize: 7, color: Colors.white),
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
                            print(
                                "delettttttttttttttttttttttttttttttttttttttiddd${products[index]['wishlistId']}");
                            deleteWishlistProduct(
                                products[index]['wishlistId']);
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
