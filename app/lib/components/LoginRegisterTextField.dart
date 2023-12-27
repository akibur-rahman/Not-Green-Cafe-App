import 'package:flutter/material.dart';

class LoginRegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const LoginRegisterTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff97CF6E)),
          ),
          fillColor: Colors.green[100],
          filled: true,
          hintStyle: TextStyle(color: Colors.grey)),
    );
  }
}
