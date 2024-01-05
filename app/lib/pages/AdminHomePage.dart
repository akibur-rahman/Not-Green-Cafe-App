import 'dart:convert';

import 'package:app/components/MenuItemWidget.dart';
import 'package:app/models/menuItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
        title: const Text('Admin Home Page'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      drawer: Drawer(
        backgroundColor: Colors.green[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[300],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_home_outlined,
                          size: 100,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Administrator",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print('tapped');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      menuItems[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Row(
                    children: [
                      SizedBox(width: 40), // Add padding here
                      Expanded(
                        child: Text(
                          menuItems[index].name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ), // Add padding here
                      Expanded(
                        child: Text(
                          '\$${menuItems[index].price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green[500],
        child: const Icon(Icons.add),
      ),
    );
  }
}
