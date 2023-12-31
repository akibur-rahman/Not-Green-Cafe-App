import 'package:app/models/LoggedInUser.dart';
import 'package:app/pages/AdminLoginPage.dart';
import 'package:app/pages/Homepage.dart';
import 'package:app/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:app/components/LoginRegisterButton.dart';
import 'package:app/components/LoginRegisterTextField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String apiUrl = 'http://10.0.2.2:5000/login';

    try {
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

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData != null && responseData['userData'] != null) {
          final Map<String, dynamic> userDataMap = responseData['userData'];

          final UserData userData = UserData.fromJson(userDataMap);

          // Use the userData object as needed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userData: userData),
            ),
          );
        } else {
          //show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password'),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        // Invalid email or password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
      } else {
        // Other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.reasonPhrase}'),
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
                  //add logo.png form assets
                  Image.asset(
                    "assets/images/logo.png",
                    //increase the size of logo
                    height: 200,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Welcome back. You've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
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
                      Text("Are you an admin?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminLoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff97CF6E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff97CF6E),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
