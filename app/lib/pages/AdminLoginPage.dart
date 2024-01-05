import 'package:app/components/LoginRegisterButton.dart';
import 'package:app/components/LoginRegisterTextField.dart';
import 'package:app/pages/AdminHomePage.dart';
import 'package:app/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final adminUsernameController = TextEditingController();
  final adminPasswordController = TextEditingController();

  Future<void> adminLogin() async {
    final String apiUrl =
        'http://10.0.2.2:5000/admin/login'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': adminUsernameController.text,
          'password': adminPasswordController.text,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['message'] == 'Admin login successful') {
        // Admin login successful
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
          (route) =>
              false, // This will remove all the routes below the new route
        );
      } else {
        // Invalid credentials or other errors
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid admin credentials'),
          ),
        );
      }
    } catch (e) {
      // Handle network or decoding errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[50],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Image.asset(
                "assets/images/logo.png",
                //increase the size of logo
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Welcome Admin!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              LoginRegisterTextField(
                controller: adminUsernameController,
                hintText: 'User Name',
                obscureText: false,
              ),
              const SizedBox(height: 16),
              LoginRegisterTextField(
                controller: adminPasswordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 16),
              LoginRegisterButton(onTap: adminLogin, text: 'Login'),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not an admin?"),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Login as user",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff97CF6E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
