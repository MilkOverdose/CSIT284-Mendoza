import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(child: Center(child: Text("Hello World")), 
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.pink])),
        ),
      ),
    ),
  );
}
