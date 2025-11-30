import 'package:flutter/material.dart';

void main() {
  runApp(const PineappleFinanceApp());
}

class PineappleFinanceApp extends StatelessWidget {
  const PineappleFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pineapple Finance',
      home: Scaffold(
        body: Center(
          child: Text(
            "Pineapple Finance",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
