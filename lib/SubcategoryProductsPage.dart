import 'dart:convert';

import 'package:bepocart/cart.dart';
import 'package:bepocart/filterhightolow.dart';
import 'package:bepocart/filterlowtohigh.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/pricefilter.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/waitingpagebeforelogin.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoryProductsPage extends StatefulWidget {
  final String? user_id; // Receive user_id as a parameter

  const SubcategoryProductsPage(
      {Key? key, this.user_id, required this.slug, required this.subcategoryId})
      : super(key: key);
  final int subcategoryId;
  final slug;

  @override
  State<SubcategoryProductsPage> createState() =>
      _SubcategoryProductsPageState();
}

class _SubcategoryProductsPageState extends State<SubcategoryProductsPage> {
  String? userId; // Declare userId variable to store user ID
  List<Map<String, dynamic>> lowtohighresult = [];
  List<Map<String, dynamic>> hightolowresult = [];
  List<bool> isFavorite = [];
  List<Map<String, dynamic>> searchResults = [];
  bool loading = true;
  RangeValues _priceFilter = RangeValues(20.0, 80.0);

  TextEditingController searchitem = TextEditingController();

  final String productsUrl = "http://51.20.129.52/subcategory/";
  final String wishlisturl = "http://51.20.129.52/add-wishlist/";

  final String searchproducturl = "http://51.20.129.52/search-products/?q=";
  final String lowtohigh = "http://51.20.129.52/low-products/";
  final String hightolow = "http://51.20.129.52/high-products/";

  final String pricefilter = "http://51.20.129.52/filtered-products/";

  List<Map<String, dynamic>> products = [];
  int _selectedIndex = 0;
  var tokenn;
  var start;
  var end;

  bool _isSearching = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();

    // Use userId after getting the value
    subcategoryproducts();
    searchproduct();
  }

  Future<void> pricefilterr() async {
    try {
      final token = await gettokenFromPrefs();

      final url = Uri.parse('$pricefilter${widget.subcategoryId}/');
      final headers = {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'min_price': start, 'max_price': end});

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final filter = jsonDecode(response.body);
        final List<dynamic> pfill = filter['data'];

        List<Map<String, dynamic>> offersList = [];

        for (var pfilter in pfill) {
          String imageUrl = "${pfilter['image']}";
          offersList.add({
            'id': pfilter['id'],
            'name': pfilter['name'],
            'salePrice': pfilter['salePrice'],
            'image': imageUrl,
            'slug':pfilter['slug']
          });
        }

        setState(() {
          pricefilterresult = offersList;
        });

        // Assuming you have a context variable available
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                pricefilterpage(filterresult: pricefilterresult),
          ),
        );
      } else {}
    } catch (error) {}
  }

  List<Map<String, dynamic>> pricefilterresult = [];

  Future<void> LowtoHigh(int subcategoryId) async {
    final token = await gettokenFromPrefs();
    try {
      final response = await http.get(
        Uri.parse('$lowtohigh$subcategoryId/'),
        headers: {
          'Authorization': '$token',
        },
        // body: ({'pk': subcategoryId.toString()}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> searchData = jsonDecode(response.body);
        List<Map<String, dynamic>> searchList = [];

        for (var productData in searchData) {
          String imageUrl = "${productData['image']}";
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
      } else {}
    } catch (error) {}
  }

  Future<void> HightoLow(int subcategoryId) async {
    final token = await gettokenFromPrefs();
    try {
      final response = await http.get(
        Uri.parse('$hightolow$subcategoryId/'),
        headers: {
          'Authorization': '$token',
        },
        // body: ({'pk': subcategoryId.toString()}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> searchData = jsonDecode(response.body);
        List<Map<String, dynamic>> searchList = [];

        for (var productData in searchData) {
          String imageUrl = "${productData['image']}";
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
      } else {}
    } catch (error) {}
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

  Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<dynamic> subcategoryproducts() async {
    try {
      final response = await http.get(Uri.parse('$productsUrl${widget.slug}/'));
      if (response.statusCode == 200) {
        final List<dynamic> productsData =
            jsonDecode(response.body)['products'];
        List<Map<String, dynamic>> productsList = [];
        List<bool> favoritesList = [];

        for (var productData in productsData) {
          String imageUrl = "${productData['image']}";
          productsList.add({
            'id': productData['id'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
            'category_id': productData['mainCategory'],
            'slug': productData['slug']
          });
          favoritesList.add(false);
        }
        setState(() {
          products = productsList;
          isFavorite = favoritesList;
          loading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {}
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
      } else {}
    } catch (error) {}
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
          String imageUrl = "${productData['image']}";
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
      } else {}
    } catch (error) {}
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
          'Subcategory Products',
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
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
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
                              onTap: () async {
                                await HightoLow(widget.subcategoryId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => hightolowpage(
                                            result: hightolowresult,
                                            SubcatId: widget.subcategoryId)));
                              },
                            ),
                            ListTile(
                              title: Text('Low to High'),
                              onTap: () async {
                                await LowtoHigh(widget.subcategoryId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => lowtohighpage(
                                            result: lowtohighresult,
                                            SubcatId: widget.subcategoryId)));
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
                      color:
                          Colors.black, // Specify the color of the border here
                      width: 1.0, // Specify the width of the border here
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
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the text horizontally
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
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            height: 170,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price Filter',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                RangeSlider(
                                  values: _priceFilter,
                                  min: 0,
                                  max: 5000,
                                  divisions: 5000,
                                  labels: RangeLabels(
                                    '\$${_priceFilter.start.toStringAsFixed(0)}',
                                    '\$${_priceFilter.end.toStringAsFixed(0)}',
                                  ),
                                  activeColor: Colors.black,
                                  inactiveColor: Colors.black38,
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _priceFilter = values;
                                      start =
                                          _priceFilter.start.toStringAsFixed(0);
                                      end = _priceFilter.end.toStringAsFixed(0);
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      child: TextButton(
                                        onPressed: () async {
                                          pricefilterr();
                                        },
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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
                      color:
                          Colors.black, // Specify the color of the border here
                      width: 1.0, // Specify the width of the border here
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
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the text horizontally
                    children: [
                      Text("Filter"),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "lib/assets/filter.png",
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: loading
                ? Center(child: CircularProgressIndicator())
                : products.isNotEmpty
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (products.length / 2).ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            int firstItemIndex = index * 2;
                            int secondItemIndex = firstItemIndex + 1;

                            // Check if this is the last row
                            bool isLastRow =
                                index == (products.length / 2).ceil() - 1;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    if (firstItemIndex < products.length) ...[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Product_big_View(
                                                        product_id: products[
                                                                firstItemIndex]
                                                            ['id'],
                                                        Category_id: products[
                                                                firstItemIndex]
                                                            ['category_id'],
                                                        slug: products[
                                                                firstItemIndex]
                                                            ['slug']),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 250,
                                            margin: EdgeInsets.only(
                                              right: (secondItemIndex <
                                                          products.length ||
                                                      isLastRow)
                                                  ? 5
                                                  : 0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 3,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Container(
                                                          width: 150,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  products[
                                                                          firstItemIndex]
                                                                      [
                                                                      'image']),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (tokenn == null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Login_Page()));
                                                          } else {
                                                            toggleFavorite(
                                                                firstItemIndex);
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              buildFavoriteIcon(
                                                                  firstItemIndex),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          products[
                                                                  firstItemIndex]
                                                              ['name'],
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      if (products[
                                                                  firstItemIndex]
                                                              ['price'] !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Text(
                                                            '\$${products[firstItemIndex]['price']}',
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
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
                                                  Category_id:
                                                      products[secondItemIndex]
                                                          ['category_id'],
                                                  slug:
                                                      products[secondItemIndex]
                                                          ['slug'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 250,
                                            margin: EdgeInsets.only(
                                              left: (firstItemIndex <
                                                          products.length ||
                                                      isLastRow)
                                                  ? 5
                                                  : 0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 3,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.network(
                                                          products[
                                                                  secondItemIndex]
                                                              ['image'],
                                                          width: 150,
                                                          height: 150,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (tokenn == null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Login_Page()));
                                                          } else {
                                                            toggleFavorite(
                                                                secondItemIndex);
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: buildFavoriteIcon(
                                                              secondItemIndex),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          products[
                                                                  secondItemIndex]
                                                              ['name'],
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      if (products[
                                                                  secondItemIndex]
                                                              ['price'] !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Text(
                                                            '\$${products[secondItemIndex]['price']}',
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
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
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 250),
                            child: Text(
                              'No products found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ],
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
