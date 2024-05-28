import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Return_Refund_Details extends StatefulWidget {
  const Return_Refund_Details({super.key});

  @override
  State<Return_Refund_Details> createState() => _Return_Refund_DetailsState();
}

class _Return_Refund_DetailsState extends State<Return_Refund_Details> {
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
        title: Text('Return and Refunds'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "POLICY",
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'We support cyclists with a friendly return policy and try to help you in all cases.',
                            style: TextStyle(
                                color: Colors
                                    .grey), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'If you receive a product with damaged packaging from a courier partner, DO NOT ACCEPT the package, so that the liability does not shift to you. We will handle returns and exchanges for all items that come to you with intact packaging.',
                            style: TextStyle(
                                color: Colors
                                    .grey), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Please note all the bicycles purchased from bepocart are to be assembled at an authorized store to avail warranty.',
                            style: TextStyle(
                                color: Colors
                                    .grey), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'RETURNS & EXCHANGES',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight
                                    .bold), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'In case of functioning defect(eg -pump not working),email us with 7 days and get exchange.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Wrong item received, email us within 48 hrs and get a exchange.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Damaged item (missing/broken part), email us within 48 hrs and get a exchange.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Size issue for apparels, email us within 48 hours and get an exchange. If the desired size is not available then get store credit. Size is considered wrong if it does not match the description on the site. Read the size chart carefully before ordering.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Cancellation, you may do so if it is not shipped yet and get store credit.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Shipped Items cannot be returned unless they meet the condition below',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'CONDITION',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight
                                    .bold), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Item sent back must',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Have the tags still attached to the product as before',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Have original, unripped packaging (the courier bag may be ripped)',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Be in resellable condition',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Unused, unworn, unwashed',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'NOT VALID FOR RETURNS/EXCHANGES',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight
                                    .bold), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Products bought during SALE are not eligible for exchange/returns.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Intimate-use items like cycling shorts, socks',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Shimano products unless damaged or wrong item',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Bicycles',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Nutrition items',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Tires',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Trainers',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Oakley',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'HOW TO PROCESS A RETURN',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'All exchanges/store credit etc will be processed after the item is received by us, If the issue is seen as valid and the product is deemed to be in a resellable condition.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'To return your product, you should send your product to:',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Michael export and import pvt ltd , GV Ayyer Road, Willingdon Island , PIN: :682003, Kochi, Kerala, India',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Phone: +91- 6235 402 223',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Note: In cases of return or exchange, shipping charges are to be borne by the customer.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                            'WARRANTY',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                            'If you report an issue after 7 days of receiving the item, it will be treated as a warranty issue. Our team will help facilitate genuine warranty cases with our suppliers or help you connect with their official representatives in India for direct resolution of the problem if required. For any dispute with warranty resolution we recommend contacting the brand directly. Our support team can help with the contact details wherever possible.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'REFUND',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'REFUND PROCESS',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'In the event that a refund is approved, the mode of processing your refund depends on your original payment method. If you have paid by credit, debit card, or internet banking refund will be sent to the respective recipient within 5 to 7 business days',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Gifts',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'If the item was marked as a gift when purchased and shipped directly to you, you’ll receive a gift credit for the value of your return. Once the returned item is received, a gift certificate will be mailed to you.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'If the item wasn’t marked as a gift when purchased or the gift giver had the order shipped to themselves to give to you later, we will send a refund to the gift giver, and they will find out about your return.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Refunds',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'The refund process is dependent on your original payment method. If your payment was made using a credit or debit card or internet banking, the refund will be processed back to the respective bank within 5 to 7 business days. This means that the refund amount should appear in your bank account within that timeframe.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'It’s important to note that the actual time it takes for the refund to be reflected in your account may vary depending on the policies and processing times of your bank. Some banks may credit the refund amount sooner, while others may take slightly longer.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'If you have any specific concerns or questions regarding the status of your refund, it’s recommended that you reach out to the customer service or support team of the company from which you made the purchase. They will be able to provide you with more specific information regarding the refund process and address any concerns you may have.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                              color: Colors.grey), // Style for the bullet point
                        ),
                        Expanded(
                          child: Text(
                            'Remember to keep track of any communication or reference numbers related to your refund, as it can be helpful in resolving any issues or inquiries that may arise.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
                        Expanded(
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align the text to the left
                            child: Text(
                              'FAQ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.justify, // Justify the text
                            ),
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
                            'Q: I want to cancel my order',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
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
                            'A: If the product has not been shipped, you may cancel the order (after deduction of payment processing charges, if any). However, once the order has been shipped, any request for cancellation shall incur a two-way return shipping cost, which shall be additionally borne by you.',
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
                            'Q: Once I place an order, can I get the size or color changed?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
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
                            'A: Yes, if your order has not been shipped, you may request a change in size or color without any charges. However, once the order has been shipped, any request for changes shall incur a return and replacement shipping cost, which shall be borne by you, and we will not refund it.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),
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
                      MaterialPageRoute(builder: (context) => UserProfilePage()));
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
