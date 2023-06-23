import 'package:ecommerce_image_search/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Product Search',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'poppins',
      ),
      home: HomeScreen(),
    );
  }
}
