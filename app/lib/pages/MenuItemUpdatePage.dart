import 'dart:convert';
import 'package:app/components/CustomTextFormField.dart';
import 'package:app/components/LoginRegisterButton.dart';
import 'package:app/models/menuItem.dart';
import 'package:app/pages/AdminHomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuItemUpdatePage extends StatefulWidget {
  final MenuItem menuItem;
  const MenuItemUpdatePage({Key? key, required this.menuItem})
      : super(key: key);

  @override
  State<MenuItemUpdatePage> createState() => _MenuItemUpdatePageState();
}

class _MenuItemUpdatePageState extends State<MenuItemUpdatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  CategoryEnum selectedCategory = CategoryEnum.Curry; // Default category
  TextEditingController imageUrlController = TextEditingController();

  Future<void> updateMenuItem({
    required String itemId,
    required String name,
    required String description,
    required double price,
    required CategoryEnum category,
    required String imageUrl,
  }) async {
    final apiUrl = 'http://10.0.2.2:5000/update_menu_items';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'item_id': itemId,
          'name': name,
          'description': description,
          'price': price,
          'category': category.toString().split('.').last,
          'image_url': imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu item updated successfully'),
          ),
        );
      } else {
        print('Error updating menu item: ${response.reasonPhrase}');
        // Handle API error
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or decoding errors
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with menu item data
    nameController.text = widget.menuItem.name;
    descriptionController.text = widget.menuItem.description;
    priceController.text = widget.menuItem.price.toString();
    selectedCategory = CategoryEnum.values.firstWhere(
      (category) =>
          category.toString() == 'CategoryEnum.${widget.menuItem.category}',
      orElse: () => CategoryEnum.Curry,
    );
    imageUrlController.text = widget.menuItem.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Update Menu Item'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: nameController,
                hintText: 'Name',
              ),
              CustomTextFormField(
                controller: descriptionController,
                hintText: 'Description',
              ),
              CustomTextFormField(
                controller: priceController,
                keyboardtype: TextInputType.number,
                hintText: 'Price',
              ),
              DropdownButton<CategoryEnum>(
                value: selectedCategory,
                onChanged: (CategoryEnum? value) {
                  setState(() {
                    selectedCategory = value ?? CategoryEnum.Curry;
                  });
                },
                items: CategoryEnum.values.map((CategoryEnum category) {
                  return DropdownMenuItem<CategoryEnum>(
                    value: category,
                    child: Text(category.toString().split('.').last),
                  );
                }).toList(),
              ),
              CustomTextFormField(
                controller: imageUrlController,
                hintText: 'Image URL',
              ),
              const SizedBox(height: 50),
              LoginRegisterButton(
                onTap: () {
                  updateMenuItem(
                    itemId: widget.menuItem.itemId,
                    name: nameController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    category: selectedCategory,
                    imageUrl: imageUrlController.text,
                  );
                },
                text: 'Update',
              ),
              SizedBox(
                height: 20,
              ),
              LoginRegisterButton(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  text: "Back to Admin Home Page")
            ],
          ),
        ),
      ),
    );
  }
}
