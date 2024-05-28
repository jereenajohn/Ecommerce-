import 'package:bepocart/cart.dart';
import 'package:bepocart/homepage.dart';
import 'package:bepocart/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/gestures.dart';

class Terms_and_conditions extends StatefulWidget {
  const Terms_and_conditions({super.key});

  @override
  State<Terms_and_conditions> createState() => _Terms_and_conditionsState();
}

class _Terms_and_conditionsState extends State<Terms_and_conditions> {
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
        title: Text("Terms & Conditions"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "TERMS AND CONDITIONS",
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'Introduction:',
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'Welcome to Bepocart, the e-commerce platform by bepositive. By accessing and using our website (www.bepocart.com and all its subdomains), you agree to be bound by the terms and conditions outlined below. If you do not agree, please refrain from using our site.',
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'Note: Our terms are subject to change without notice. Please review them periodically for updates.',
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'This site is owned and operated by Michael Export and Import Private Limited, based in Kochi. The laws of India shall apply, and courts in Kerala shall have jurisdiction over all terms, conditions, and disclaimers.',
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'Definitions:',
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
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align text to the left
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Agreement',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ': refers to the Terms and Conditions (T&C) under the Bepocart brand name, including any amendments.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align text to the left
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Site ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'www.Bepocart.com',
                                    style: TextStyle(
                                      color: Colors
                                          .blue, // Change color to blue for links
                                      decoration: TextDecoration
                                          .underline, // Add underline for links
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // You can provide a message to the user indicating it's a link
                                        print(
                                            'This is a link. Please open it in your browser.');
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        ' (and all its subdomains), owned and operated by Michael Export and Import Private Limited.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align text to the left
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'User/You',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ': Encompasses any person or legal entity accepting the sale offer by Bepocart through order placement.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align text to the left
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Products',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ': goods and services listed and promoted on the site.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'Online Purchases',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ), // Style for the text
                            // textAlign: TextAlign.justify, // No need to justify as there's no text after the bullet point
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: 8), // Adjust the spacing between bullet points
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'This website serves as a platform for users to engage in purchase transactions for sports goods and services. The commercial and contractual terms, including price, shipping, and warranties, are within our control.',
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
                        // Text(
                        //   '• ',
                        //   style: TextStyle(
                        //       color: Colors.grey), // Style for the bullet point
                        // ),
                        Expanded(
                          child: Text(
                            'The agreement between you and the site is subject to the following terms and conditions:',
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
                          child: Container(
                            alignment:
                                Alignment.topLeft, // Align text to the left
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Acceptance of Terms',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ': By using the shopping services on the site, you agree to these terms and conditions.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
                          child: RichText(
                            textAlign: TextAlign.justify, // Justify the text
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Price Clarification',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ': All prices are in Indian rupees. By accepting the purchase, you commit to completing the transaction.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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
                            'This site is a place where users consume purchases of sports goods and services. Commercial /Contract Terms include without limitation – warranty of goods and services including price, shipping charges, date, duration, method of delivery, after sale goods and services, etc., over which we own and may have sufficient full control to be subject to change.',
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
                            'The agreement between you and the Site is subject to the following terms and conditions:',
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
                            'User certifies that he/she is at least 18 (eighteen) years of age or has the consent of a parent or legal guardian. These terms and conditions supersede all prior terms, understandings, or agreements and notwithstanding any deviations from the other terms of any given order.',
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
                            'By the usage of the Shopping offerings on the Site you settle to be certain via the Terms and Conditions. All expenses, until indicated in any other case are in Indian Rupees.-',
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
                            'By indicating Users reputation to purchase any service or product presented at the Site, consumer is obligated to complete such transactions. Users shall limit from indicating its reputation to purchase products and services wherein it does not intend to finish such transactions.',
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
                            'Any order placed for a product that is indexed at an incorrect fee can be cancelled. This will be no matter whether the order has been showed and/or price levied. In the event the charge has been processed, the equal will be credited in your account and duly notified to you by means of email. In a credit score card transaction, you need to use your personal credit card Bepocart will no longer be responsible for any credit card fraud. The liability to apply a card fraudulently may be at the User and the onus to ‘prove in any other case’ will be completely at the User. In the event that a non-delivery happens as a consequence of a mistake with the aid of the User (i.E. Wrong call or deal with) any more cost in the direction of re-transport will be claimed from the User putting the order.',
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
                            'Payment gateway takes 24-48 hrs. To verify the payment to check for fraudulent transactions. Shipment/shipping time of order processing starts offevolved from the day of receipt of the fee showed in opposition to the order located on the Site. Usually all orders are processed and shipped within 7 operating days, once charge is confirmed. However, certain classes of products have specific lead-times for shipping because of the nature of the product. Do check the delivery timelines for every product at the same time as ordering. Bepocart. Shall now not be liable for any put off/non-delivery of bought goods in the occasion of flood, hearth, wars, acts of God or any cause that is beyond our manipulate.',
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
                            'The Products will be situation to manufacturer’s terms and situations for assurance, carrier and protection, and Company does not receive any duty for the same. The Company additionally does not accept any duty for using the Products with the aid of the User. The User consents to use the services provided by the Company, its affiliates, experts and gotten smaller corporations, for lawful purposes handiest. Company can also assign any or all of its rights under these Terms to its Affiliates with out consent of the User. Any strive with the aid of a User to intentionally harm the Site or undermine the legitimate operation of the Site is in violation of Criminal and Civil Laws and need to such an try be made, Company reserves the proper to are trying to find damages/injunction from any such User to the fullest extent authorized by using regulation.',
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
                            'The User has the same opinion to provide real and genuine information. We reserve the proper to confirm and validate the records and different details furnished by means of the User at any factor of time. If upon confirmation such User info are located no longer to be proper (entirely or partly), bepocart has the right in its sole discretion to reject the registration and debar the User from the usage of the Services available at this website, and /or different affiliated websites without earlier intimation whatsoever.',
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
                            'Partial transport of product wishes to be stated within 7 days of receipt of the product – In the occasion of non-delivery of the products to the clients, bepocart’s legal responsibility will be constrained simplest to the refund of the precise amount paid with the aid of the patron for the acquisition of the product. Bepocart’s liability for any claims will only be as much as and limited to the price of the product devices in query. Please be aware that there can be certain orders that we are unable to just accept and need to cancel. We reserve the proper, at our sole discretion, to refuse or cancel any order for any cause. Some situations that could result in your order being canceled include obstacles on portions to be had for purchase, inaccuracies or mistakes in product or pricing records, or troubles diagnosed by means of our credit and fraud avoidance department.',
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
                            'We can also require extra verifications or facts earlier than accepting any order. We will touch you if any or all portion of your order is cancelled or if extra facts is needed to accept your order. We have the total right to decide whether or not an order has been processed or not. The client consents no longer to dispute the selection made with the aid of us and accepts our selection concerning the cancellation. This person agreement shall be construed in accordance with the applicable legal guidelines of India. The Courts at Gurgaon shall have unique jurisdiction in any court cases springing up out of this agreement. Any dispute or distinction, either in interpretation or otherwise, of any phrases of this User Agreement among the parties hereto will be stated an unbiased arbitrator who will be appointed by Bepocart, and their decision shall be final and binding at the parties hereto. The above arbitration shall be according with the Arbitration and Conciliation Act, 1996, as amended sometimes. The arbitration shall be held in Gurgaon/Gurugram. The High Court of Judicature at Gurgaon/Gurugram by myself shall have the jurisdiction, and the Laws of India shall follow.',
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
                            'Contents Posted on Site bepocart expressly reserves all intellectual property rights in all text, applications, products, techniques, technology, content material, and other substances, which seem on this website. Access to this Site does not confer and shall not be considered as conferring upon each person any license below any of Bepocart’s or any 1/3 birthday party’s highbrow property rights. All rights, inclusive of copyright, on this internet site are owned by way of or licensed to Bepocart. Any use of this internet site or its contents, consisting of copying or storing them in entire or in part, aside from for your own personal, non-commercial use, is unlawful without the permission of Bepocart. You might not modify, distribute, or re-publish anything in this website for any purpose. The bepocart names and emblems and all associated product and provider names, layout marks, and slogans are the logos or provider marks of bepocart.Com. All different marks are the assets of their respective companies. No trademark or service mark license is granted in reference to the substances contained in this web site. Access to this website online does no longer authorize anyone to apply any call, logo, or mark in any manner. All substances, such as photos, textual content, illustrations, designs, icons, photos, programs, tune clips or downloads, video clips, and written and other substances which can be a part of this website (together, the &quot;Contents&quot;), are meant completely for personal, non-industrial use. You may also down load or replica the contents and different downloadable materials displayed at the website online for your private use only. No right, title, or hobby in any downloaded materials or software is transferred to you as a result of this sort of downloading or copying. You won’t reproduce (except as referred to above), publish, transmit, distribute, show, modify, create spinoff works from, promote, or take part in any sale of or exploit in any manner, in entire or in part, any of the contents, the site, or any related software program. All software used in this site is the assets of Bepocart and is protected by means of Indian and global copyright legal guidelines. Tcontentsnts and software on this website may be used simplest as a shopping aid. Any other use, consisting of the replica, modification, distribution, transmission, republication, show, or performance, of the Contents on this Site is strictly prohibited. Unless in any other case stated, all Contents are copyrights, logos, exchange dress and/or other highbrow assets owned, controlled or certified through bepocart. You understand that by means of using this Site or any services provided on the Site, you can come upon Content that may be deemed with the aid of some to be offensive, indecent, or objectionable, which Content may also or won’t be identified as such. You agree to apply the Site and any service at your sole danger and that to the fullest quantity permitted beneath applicable law, bepocart shall haven’t any legal responsibility to you for Content that can be deemed offensive, indecent, or objectionable to you.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 8, // Adjust the spacing between bullet points
                    ),
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
                            'You comply with guard, indemnify and preserve harmless Bepocart., its employees, directors, officers, dealers and their successors and assigns from and against any and all claims, liabilities, damages, losses, fees and prices, consisting of attorney’s charges, because of or springing up out of claims primarily based upon your moves or inactions, which may additionally bring about any loss or liability to Bepocart but no longer confined to breach of any warranties, representations or undertakings or in terms of the non-success of any of your duties under this User Agreement or arising out of your violation of any relevant laws, rules along with but no longer restricted to Intellectual Property Rights, payment of statutory dues and taxes, declare of libel, defamation, violation of rights of privacy or publicity, loss of service by way of other subscribers and infringement of intellectual assets or different rights. This clause shall live on the expiration or termination of this User Agreement.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
                            textAlign: TextAlign.justify, // Justify the text
                          ),
                        ),
                      ],
                    ),

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
                            'The users have read and agreed to the Bepocart Terms and Conditions and also agree to receive promotional e-mailers and SMS’s. Pricing error bepocart. shall have the right to rectify or cancel the order if there are any differences in pricing resulting from typographic errors with pricing or product information. Product Description We try to be as accurate as possible. However, we do not warrant that Product content on the Site is accurate, complete, reliable, current, or error-free. Jurisdictional Issues/Sale in India Only The material on the Site is presented for sale in India only. Those who choose to access the Site from locations other than India do so on their own initiative and we are not responsible for the supply of goods, refund’s and payments for the goods ordered. Cancellation of order We reserve the right to cancel any order at our sole discretion, when we are unable to meet the requirement of the order placed or for any other reason. However, we will communicate the cancellation of the order within appropriate time to the concerned person with the appropriate refunds. Limitation of Liability In no event shall bepocart.com. or bepocart be liable for any special, indirect, incidental or consequential damages of any kind in connection with this agreement even if Bepocart.com. or bepocart have been informed in advance of the possibility of such damages.',
                            style: TextStyle(
                              color: Colors.grey,
                            ), // Style for the text after the bullet point
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
