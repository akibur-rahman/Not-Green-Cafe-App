import 'dart:convert';
import 'package:app/models/RegistedUser.dart';
import 'package:app/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:app/components/LoginRegisterButton.dart';
import 'package:app/components/loginRegisterTextField.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController(); // Added line
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _registerUser() async {
    final userRegistration = UserRegistration(
      user_id: '',
      name: '${firstNameController.text} ${lastNameController.text}',
      email: emailController.text,
      password: passwordController.text,
      sex: sexController.text,
      address: addressController.text,
      birthdate: selectedDate ?? DateTime.now(),
      userPhoto: profilePictureController.text, // Updated line
    );

    final response = await registerUserApiCall(userRegistration);

    if (response.statusCode == 200) {
      //show snakbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful, Please Login Now'),
        ),
      );
    } else {
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Failed'),
        ),
      );
    }
  }

  Future<http.Response> registerUserApiCall(UserRegistration user) async {
    final uri = Uri.parse('http://10.0.2.2:5000/register');

    final response = await http.post(
      uri, // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    //increase the size of logo
                    height: 200,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Let's Create an account for you!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25),
                  LoginRegisterTextField(
                      controller: firstNameController,
                      hintText: "First Name",
                      obscureText: false),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: lastNameController,
                      hintText: "Last Name",
                      obscureText: false),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Sex:"),
                      Radio(
                        value: 'Male',
                        groupValue: sexController.text,
                        onChanged: (value) {
                          setState(() {
                            sexController.text = value as String;
                          });
                        },
                      ),
                      Text('Male'),
                      Radio(
                        value: 'Female',
                        groupValue: sexController.text,
                        onChanged: (value) {
                          setState(() {
                            sexController.text = value as String;
                          });
                        },
                      ),
                      Text('Female'),
                      Radio(
                        value: 'Other',
                        groupValue: sexController.text,
                        onChanged: (value) {
                          setState(() {
                            sexController.text = value as String;
                          });
                        },
                      ),
                      Text('Other'),
                    ],
                  ),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: addressController,
                      hintText: "Address",
                      obscureText: false),
                  SizedBox(height: 10),
                  LoginRegisterTextField(
                      controller: profilePictureController, // Added line
                      hintText: "Profile Picture URL", // Added line
                      obscureText: false),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text("Birthdate:"),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff97CF6E),
                          ),
                          onPressed: () => _selectDate(context),
                          child: Text(
                            selectedDate != null
                                ? 'Selected Date: ${selectedDate!.toLocal()}'
                                : 'Select Birthdate',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  LoginRegisterButton(
                    onTap: _registerUser,
                    text: "Sign Up",
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already registered?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff97CF6E)),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
