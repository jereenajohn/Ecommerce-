import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final multipleimageurl =
      "https://talent-johnston-murray-bone.trycloudflare.com/product-images/";
  List<Map<String, dynamic>> images = [];
  String? selectedColor;
  List<String> colors = [];
  List<String> sizeNames = [];
  String? selectedSize;
  bool isLoading = false;

  Future<void> multipleimage(int id) async {
    setState(() {
      isLoading = true; // Set loading state
    });

    print('======================$multipleimageurl${id}/r');
    Set<String> colorsSet = {};
    try {
      final response = await http.get(Uri.parse('$multipleimageurl${id}/'));
      print("statussssssssssssssssssssssssss${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> imageData = jsonDecode(response.body)['product'];
        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$imageData");

        List<Map<String, dynamic>> productsList = [];

        for (var imageData in imageData) {
          String imageUrl1 =
              "https://talent-johnston-murray-bone.trycloudflare.com/${imageData['image1']}";
          String imageUrl2 =
              "https://talent-johnston-murray-bone.trycloudflare.com/${imageData['image2']}";
          String imageUrl3 =
              "https://talent-johnston-murray-bone.trycloudflare.com/${imageData['image3']}";
          String imageUrl4 =
              "https://talent-johnston-murray-bone.trycloudflare.com/${imageData['image4']}";
          String imageUrl5 =
              "https://talent-johnston-murray-bone.trycloudflare.com/${imageData['image5']}";
          productsList.add({
            'id': imageData['id'],
            'image1': imageUrl1,
            'image2': imageUrl2,
            'image3': imageUrl3,
            'image4': imageUrl4,
            'image5': imageUrl5,
            'color': imageData['color'],
            'size_names': List<String>.from(
                imageData['size_names']), // Cast to List<String>
          });
          colorsSet.add(imageData['color']);
        }

        setState(() {
          images = productsList;
          colors = colorsSet.toList();
          selectedColor = colors.isNotEmpty ? colors[0] : null;
          sizeNames = images.firstWhere(
                  (image) => image['color'] == selectedColor)['size_names'] ??
              [];
          selectedSize = sizeNames.isNotEmpty ? sizeNames[0] : null;
          isLoading = false; // Set loading state
        });
        print("dddddddddddddddddddddddddddddddddddddd$sizeNames");
      } else {
        throw Exception('Error fetching product image');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading state
      });
      print('Error fetching product image : $error');
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.3, // Adjust the height as needed
          widthFactor: 0.99, // Set the width to 95% of the screen
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                               Text(
                        'Select Color',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: colors.map((color) {
                          return ChoiceChip(
                            label: Text(color),
                            selected: selectedColor == color,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedColor = selected ? color : null;
                                sizeNames = images.firstWhere(
                                        (image) => image['color'] == selectedColor)['size_names'] ??
                                    [];
                                selectedSize = sizeNames.isNotEmpty ? sizeNames[0] : null;
                                print(selectedColor);
                              });
                            },
                          );
                        }).toList(),
                      ),

                            ],
                          )
                        ],
                      ),
                     
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                               Text(
                        'Select Size',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: sizeNames.map((size) {
                          return ChoiceChip(
                            label: Text(size),
                            selected: selectedSize == size,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedSize = selected ? size : null;
                                print(selectedSize);
                              });
                            },
                          );
                        }).toList(),
                      ),

                            ],
                          )
                        ],
                      ),
                     
                      SizedBox(height: 16.0),
                      ElevatedButton(
  onPressed: () {
    // Handle button press
    Navigator.pop(context); // Close the bottom sheet
    print('Selected Color: $selectedColor');
    print('Selected Size: $selectedSize');
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)), // Background color
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0), // Border radius
        side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)), // Border color
      ),
    ),
  ),
  child: Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 12.0), // Adjust padding as needed
    child: Text(
      'Confirm',
      style: TextStyle(
        color: Colors.white, // Text color
        fontSize: 16.0, // Adjust font size as needed
      ),
    ),
  ),
),

                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await multipleimage(8); // Ensure data is fetched before showing bottom sheet
            _showBottomSheet(context);
          },
          child: Text('Show Options'),
        ),
      ),
    );
  }
}
