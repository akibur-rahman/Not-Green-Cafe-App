import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:app/models/menuItem.dart';

class ProductDetailsPage extends StatefulWidget {
  final MenuItem menuItem;
  final String userId;

  const ProductDetailsPage(
      {Key? key, required this.menuItem, required this.userId})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedQuantity = 1;

  Future<void> buyNow(String customerId, String itemId, int quantity) async {
    if (widget.userId == null) {
      print('UserId is null');
      return;
    }

    final apiUrl = 'http://10.0.2.2:5000/place_order';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'customer_id': widget.userId,
          'item_id': widget.menuItem.itemId,
          'quantity': selectedQuantity,
        }),
      );

      if (response.statusCode == 201) {
        //show snakbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Placed Successfully'),
          ),
        );
      } else {
        //show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Failed'),
          ),
        );
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    widget.menuItem.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${widget.menuItem.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.menuItem.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (selectedQuantity > 1) {
                          setState(() {
                            selectedQuantity--;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 16),
                    Text(
                      selectedQuantity.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // You can replace 10 with your own maximum quantity
                        if (selectedQuantity < 10) {
                          setState(() {
                            selectedQuantity++;
                          });
                        }
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    buyNow(widget.userId, widget.menuItem.itemId,
                        selectedQuantity);
                  },
                  child: Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
