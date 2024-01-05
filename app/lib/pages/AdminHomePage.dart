import 'dart:convert';

import 'package:app/models/menuItem.dart';
import 'package:app/pages/AdminLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum CategoryEnum {
  Curry,
  Snacks,
  Drinks,
  SetMenu,
  Rice,
  Combo,
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<MenuItem> menuItems = [];
  CategoryEnum? selectedCategory;

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

  void _showAddItemDialog(BuildContext context) {
    String itemName = '';
    String itemDescription = '';
    double itemPrice = 0.0;
    String itemImageUrl = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    itemName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    itemDescription = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    itemPrice = double.tryParse(value) ?? 0.0;
                  },
                ),
                // Dropdown for Category
                DropdownButton<CategoryEnum>(
                  hint: Text(
                    'Select Category',
                    style: TextStyle(color: Colors.black),
                  ),
                  value: selectedCategory,
                  onChanged: (CategoryEnum? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: CategoryEnum.values.map((CategoryEnum category) {
                    return DropdownMenuItem<CategoryEnum>(
                      value: category,
                      child: Text(category.toString().split('.').last),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) {
                    itemImageUrl = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addItem(
                  itemName: itemName,
                  itemDescription: itemDescription,
                  itemPrice: itemPrice,
                  itemCategory:
                      selectedCategory?.toString().split('.').last ?? '',
                  itemImageUrl: itemImageUrl,
                );
                Navigator.pop(context);
              },
              child: Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  void _addItem({
    required String itemName,
    required String itemDescription,
    required double itemPrice,
    required String itemCategory,
    required String itemImageUrl,
  }) async {
    final apiUrl = 'http://10.0.2.2:5000/add_menu_items';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': itemName,
          'description': itemDescription,
          'price': itemPrice,
          'category': itemCategory,
          'image_url': itemImageUrl,
        }),
      );

      if (response.statusCode == 201) {
        print('Item added successfully');
        fetchMenuItems(); // Refresh the list after adding a new item
      } else {
        print('Error adding new item: ${response.reasonPhrase}');
      }
    } catch (e) {
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings_rounded,
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
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()));
              },
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
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      menuItems[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Row(
                    children: [
                      const SizedBox(width: 40), // Add padding here
                      Expanded(
                        child: Text(
                          menuItems[index].name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ), // Add padding here
                      Expanded(
                        child: Text(
                          '\৳${menuItems[index].price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.green),
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
        onPressed: () {
          _showAddItemDialog(context);
        },
        backgroundColor: Colors.green[500],
        child: const Icon(Icons.add),
      ),
    );
  }
}
