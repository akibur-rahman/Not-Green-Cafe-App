import 'dart:convert';
import 'package:app/components/MenuItemWidget.dart';
import 'package:app/models/menuItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> menuItems = [];

  Future<void> fetchMenuItems() async {
    final apiUrl = 'http://10.0.2.2:5000/menu_items';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          menuItems = responseData.map((item) {
            return MenuItem(
              itemId: item['item_id'],
              name: item['name'],
              description: item['description'],
              price: double.tryParse(item['price'].toString()) ?? 0.0,
              category: item['category'],
              imageUrl: item['image_url'],
            );
          }).toList();
        });
      } else {
        // Handle API error
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return MenuItemWidget(menuItem: menuItems[index]);
        },
      ),
    );
  }
}
