import 'dart:convert';
import 'package:bepocart/SubcategoryProductsPage.dart';
import 'package:bepocart/cart.dart';
import 'package:bepocart/categoryproductsview.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/loginpage.dart';
import 'package:bepocart/productbigview.dart';
import 'package:bepocart/search.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:bepocart/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoriesPage extends StatefulWidget {
    final String? user_id; // Receive user_id as a parameter

    const SubcategoriesPage({Key? key, this.user_id,required this.categoryId}) : super(key: key);


  final int categoryId;

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  List<Map<String, dynamic>> subcategories = [];
  List<Map<String, dynamic>> categoryProducts = [];
    String? userId; // Declare userId variable to store user ID


  void aa() {
    print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii${widget.categoryId}");
  }

  final String subcategoriesurl =
      "https://michelle-miniature-depot-studied.trycloudflare.com//category/";
  final String productsurl =
      "https://michelle-miniature-depot-studied.trycloudflare.com//category/";
  final String searchproducturl =
      "https://michelle-miniature-depot-studied.trycloudflare.com//search-products/?q=";

  int _selectedIndex = 0;
  bool _isSearching = false;
  int _index = 0;
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchitem = TextEditingController();
  var tokenn;

  @override
  void initState() {
    super.initState();
    _initData();
    fetchSubcategories();
    fetchCategoryProducts();
    aa();
  }

   Future<void> _initData() async {
    userId = await getUserIdFromPrefs();
    tokenn = await gettokenFromPrefs();

    print("--------------------------------------------R$tokenn");
    // Use userId after getting the value
  }

   Future<String?> gettokenFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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

  Future<void> fetchCategoryProducts() async {
    try {
      print('$productsurl${widget.categoryId.toString()}/products/');
      final response = await http.get(
          Uri.parse('$productsurl${widget.categoryId.toString()}/products/'));
      print('Responseeee: ${response.statusCode}');
      print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL$response");
      print(widget.categoryId);

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$parsed");
        final List<dynamic> productsData = parsed['products'];
        List<Map<String, dynamic>> ProductsList = [];

        for (var productData in productsData) {
          String imageUrl =
              "https://michelle-miniature-depot-studied.trycloudflare.com/${productData['image']}";
          ProductsList.add({
            'id': productData['id'],
            'category_id': productData['mainCategory'],
            'name': productData['name'],
            'price': productData['price'],
            'salePrice': productData['salePrice'],
            'image': imageUrl,
          });
        }

        setState(() {
          categoryProducts = ProductsList;
        });

        print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD$categoryProducts");
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (error) {
      print('Error fetching product: $error');
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
              "https://michelle-miniature-depot-studied.trycloudflare.com/${productData['image']}";
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

  Future<void> fetchSubcategories() async {
    print("dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    print(subcategoriesurl + widget.categoryId.toString());
    try {
      final response = await http.get(
          Uri.parse(subcategoriesurl + widget.categoryId.toString() + "/"));
      print('Response: ${response.statusCode}');
      print(widget.categoryId);

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<dynamic> subcategoriessData = parsed['data'];
        List<Map<String, dynamic>> subcategoryList = [];

        for (var subcategoryData in subcategoriessData) {
          String imageUrl =
              "https://michelle-miniature-depot-studied.trycloudflare.com/${subcategoryData['image']}";
          subcategoryList.add({
            'id': subcategoryData['id'],
            'name': subcategoryData['name'],
            'image': imageUrl,
          });
        }

        setState(() {
          subcategories = subcategoryList;
        });
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (error) {
      print('Error fetching subcategories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop By Category',
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
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subcategories.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (subcategories.length / 2).ceil(),
                      itemBuilder: (BuildContext context, int index) {
                        int firstItemIndex = index * 2;
                        int secondItemIndex = firstItemIndex + 1;

                        return Column(
                          children: [
                            Row(
                              children: [
                                if (firstItemIndex < subcategories.length) ...[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubcategoryProductsPage(
                                                      subcategoryId:
                                                          subcategories[
                                                                  firstItemIndex]
                                                              ['id'],
                                                    )));
                                      },
                                      child: Container(
                                        height: 100,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 173, 173, 173)),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    subcategories[
                                                        firstItemIndex]['name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Image.network(
                                              subcategories[firstItemIndex]
                                                  ['image'],
                                              width: 50,
                                              height: 50,
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                if (secondItemIndex < subcategories.length) ...[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubcategoryProductsPage(
                                                      subcategoryId:
                                                          subcategories[
                                                                  secondItemIndex]
                                                              ['id'],
                                                    )));
                                      },
                                      child: Container(
                                        height: 100,
                                        margin: EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 173, 173, 173)),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    subcategories[
                                                            secondItemIndex]
                                                        ['name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Image.network(
                                              subcategories[secondItemIndex]
                                                  ['image'],
                                              width: 50,
                                              height: 50,
                                            ),
                                            SizedBox(width: 10),
                                          ],
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
!categoryProducts.isEmpty
    ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductView(
                          categoryId: widget.categoryId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(
                    'See More',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryProducts.length > 5
                    ? 5
                    : categoryProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = categoryProducts[index];
                  try {
                    final imageData = product['image'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Product_big_View(
                              product_id: product['id'],
                              Category_id: product['category_id']
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          product['name'],
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product['price'] != null)
                              Text(
                                '\$${product['price']}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            Text(
                              'Sale Price: \$${product['salePrice']}',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        leading: Image.network(
                          imageData,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error decoding image: $e');
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('\$${product['price']}'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      )
    : Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Center(child: Text('No products available',style:TextStyle(color: Colors.grey))),
    )

             
          ],
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
