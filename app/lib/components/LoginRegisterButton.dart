import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const LoginRegisterButton(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff97CF6E),
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.all(25),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ));
  }
}
