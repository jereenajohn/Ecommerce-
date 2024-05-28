import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Shipping_Policy_Details extends StatefulWidget {
  const Shipping_Policy_Details({super.key});

  @override
  State<Shipping_Policy_Details> createState() =>
      _Shipping_Policy_DetailsState();
}

class _Shipping_Policy_DetailsState extends State<Shipping_Policy_Details> {
  int _index = 0;

  bool _isSearching = false;

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
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                          });
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.clear),
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
        title: Text('Shipping Policy'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "SHIPPING POLICY",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5, // Adjust line spacing as needed
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Speed Delivery Duration: 3–5 days',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Normal Delivery Duration: 5-8 days [Free Shipping]',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'SHIPMENTS TO ALL OVER INDIA Orders INR 2000 and over qualify for our rapid, unfastened shipping offer. Please be aware that INR 100 is relevant for cash on delivery orders.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'We recognise that while you make an order, you need your equipment as quickly as possible, and we will do our best to make that appear! Most of the items we promote will ship quickly and be at your door. Additionally, we work intently with our providers as a way to have the product shipped immediately to you from their warehouse if that means you’ll get the product quicker. Items can have availability repute proven as soon as a size or shade is selected on the product web page; this availability repute will also be shown at the purchasing cart page and in your order confirmation email. Most products could be marked in stock and shipped within 24 hours. These merchandise will be delivered on the same or subsequent enterprise day. The earlier in the day the order is located, the higher the threat it’ll deliver that day.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'While we can do our exceptional to deliver from the distribution middle closest to you, naturally no longer all objects will continually be in stock in each area at all times! In a few instances, we will break up the order and ship each bundle out to you, in my view, and in other cases, we might also need to consolidate the items in a single region to ship out as one package deal. We make use of our high-quality judgment in an attempt to get the products to you as quickly as possible. Some items could be marked available; assume five–seven commercial enterprise days of lead time prior to cargo. These items cannot ship the same day and require a lead time prior to cargo.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'If you choose an expedited transport approach, please know that this may not reduce the lead time before the order is distributed! A delivery confirmation email along with provider-specific monitoring information will typically be dispatched within 24 hours of an object delivery. And you”ll get the product within three to five commercial enterprise days. For instance, if you place an order Monday night and it ships out Tuesday morning, you may get hold of your monitoring records either Wednesday evening or Thursday morning. Most orders might be shipped through our shipping partner, Delivery.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
            selectedIndex: _index,
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
                  // Show search dialog if tapped
                },
              ),
              GButton(
                icon: Icons.person,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfilePage ()));
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
