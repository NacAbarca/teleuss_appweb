// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(TeleUSSApp());
}

class TeleUSSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleUSS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a TeleUSS'),
      ),
      body: Center(
        child: Text(
          'App para usuarios sordos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
