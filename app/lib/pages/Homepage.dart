import 'dart:convert';
import 'package:app/models/LoggedInUser.dart';
import 'package:app/components/MenuItemWidget.dart';
import 'package:app/models/menuItem.dart';
import 'package:app/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final UserData userData; // Add this line

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> menuItems = [];

  Future<void> fetchMenuItems() async {
    const apiUrl = 'http://10.0.2.2:5000/menu_items';

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
        //show snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load menu items'),
          ),
        );
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

  Future<void> logout() async {
    const apiUrl =
        'http://10.0.2.2:5000/logout'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': widget.userData.userId,
        }),
      );

      if (response.statusCode == 200) {
        // Navigate to the login page after successful logout
        // ignore: use_build_context_synchronously

        //show popup to confirm user logout and then navigate to login page
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(
                          onTap: null,
                        ),
                      ),
                    );
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      } else {
        //shackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout Failed'),
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
        title: const Text(
          'Delicious Dishes',
        ),
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
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.userData.profilePictureUrl),
                          radius: 50,
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.userData.name,
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
              title: Text('Logout'),
              onTap: logout, // Call the logout method on tap
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return MenuItemWidget(
            menuItem: menuItems[index],
            userId: widget.userData.userId,
          );
        },
      ),
    );
  }
}
