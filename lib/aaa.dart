import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  final imageurl = "https://sr-shaped-exports-toolbar.trycloudflare.com/product/";
  List<Map<String, dynamic>> images = [];
  String? selectedColor;
  List<String> colors = [];
  List<Map<String, dynamic>> sizes = [];
  String? selectedSize;
  int? selectedStock;

  @override
  void initState() {
    super.initState();
    sizecolor(1);  // Example ID, you can set this as per your requirement
  }

  Future<void> sizecolor(int id) async {
    print('======================$imageurl${id}/');
    Set<String> colorsSet = {};
    try {
      final response = await http.get(Uri.parse('$imageurl${id}/'));
      print("statussssssssssssssssssssssssss${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> imageData = data['images'];
        final List<dynamic> variantsData = data['variants'];
        print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$imageData");

        List<Map<String, dynamic>> productsList = [];

        for (var imageData in imageData) {
          String imageUrl1 = "https://sr-shaped-exports-toolbar.trycloudflare.com/${imageData['image1']}";
          String imageUrl2 = "https://sr-shaped-exports-toolbar.trycloudflare.com/${imageData['image2']}";
          String imageUrl3 = "https://sr-shaped-exports-toolbar.trycloudflare.com/${imageData['image3']}";
          String imageUrl4 = "https://sr-shaped-exports-toolbar.trycloudflare.com/${imageData['image4']}";
          String imageUrl5 = "https://sr-shaped-exports-toolbar.trycloudflare.com/${imageData['image5']}";

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
                  (image) => image['color'] == selectedColor)['sizes'] ?? [];
          selectedSize = sizes.isNotEmpty ? sizes[0]['size'] : null;
          selectedStock = sizes.isNotEmpty ? sizes[0]['stock'] : null;
        });
      } else {
        throw Exception('Error fetching product image');
      }
    } catch (error) {
      print('Error fetching product image : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parent Widget")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showBottomSheet(
              context,
              colors,
              images,
              selectedColor,
              sizes,
              selectedSize,
              selectedStock,
              (color, sizeList, size, stock) {
                setState(() {
                  selectedColor = color;
                  sizes = sizeList;
                  selectedSize = size;
                  selectedStock = stock;
                });
              },
            );
          },
          child: Text("Show Bottom Sheet"),
        ),
      ),
    );
  }
}

void showBottomSheet(
  BuildContext context,
  List<String> colors,
  List<Map<String, dynamic>> images,
  String? selectedColor,
  List<Map<String, dynamic>> sizes,
  String? selectedSize,
  int? selectedStock,
  Function(String color, List<Map<String, dynamic>> sizeList, String? size, int? stock) onColorSizeChanged,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (colors.isNotEmpty)
                  Container(
                    height: 70,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    selectedColor = color;
                                    sizes = images.firstWhere(
                                        (image) => image['color'] == selectedColor)['sizes'] ?? [];
                                    selectedSize = sizes.isNotEmpty ? sizes[0]['size'] : null;
                                    selectedStock = sizes.isNotEmpty ? sizes[0]['stock'] : null;
                                    onColorSizeChanged(selectedColor!, sizes, selectedSize, selectedStock);
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
                  Container(
                    height: 80,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: sizes.map<Widget>((sizeData) {
                          return Container(
                            width: 40.0,
                            height: 40.0,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: selectedSize == sizeData['size']
                                    ? Color.fromARGB(255, 1, 80, 12)
                                    : Colors.black,
                                side: BorderSide(
                                  color: selectedSize == sizeData['size']
                                      ? Color.fromARGB(255, 28, 146, 1)
                                      : Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: sizeData['stock'] > 0
                                  ? () {
                                      setModalState(() {
                                        selectedSize = sizeData['size'];
                                        selectedStock = sizeData['stock'];
                                        onColorSizeChanged(selectedColor!, sizes, selectedSize, selectedStock);
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
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: (selectedStock ?? 0) > 0
                              ? () {
                                  // addProductToCart(id, name, price);
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
            );
          },
        ),
      );
    },
  );
}
