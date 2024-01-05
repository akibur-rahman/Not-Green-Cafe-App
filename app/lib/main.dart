import 'package:app/pages/LoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        hintColor: Colors
            .greenAccent, // Set the background color to a light green shade
        scaffoldBackgroundColor: Colors.green[
            100], // Set the scaffold background color to a slightly darker green shade
        textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.green[
                  900]), // Set the default text color to a dark green shade
          // Add more text styles as needed
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: Colors.green[50]),
      ),
      home: LoginPage(),
    );
  }
}
