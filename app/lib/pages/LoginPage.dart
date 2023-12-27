import 'package:app/pages/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:app/components/LoginRegisterButton.dart';
import 'package:app/components/LoginRegisterTextField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String apiUrl = 'http://10.0.2.2:5000/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful, navigate to the Homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage()), // Replace HomePage with your actual HomePage widget
      );
    } else if (response.statusCode == 401) {
      // Invalid email or password, show a popup or any other indication
      print('Invalid email or password');
    } else {
      // Other errors, handle accordingly
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    Icons.message,
                    size: 100,
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Welcome back. You've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 25),
                  LoginRegisterTextField(
                    controller: emailController,
                    hintText: "email",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                    controller: passwordController,
                    hintText: "password",
                    obscureText: true,
                  ),
                  SizedBox(height: 25),
                  LoginRegisterButton(
                    onTap: () {
                      loginUser();
                    },
                    text: "Sign In",
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff97CF6E),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
