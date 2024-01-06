import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final keyboardtype;
  final TextEditingController controller;
  final String hintText;
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardtype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[300]!),
          ),
          fillColor: Colors.green[100],
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
