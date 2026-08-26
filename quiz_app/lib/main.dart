import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(decoration: BoxDecoration(color: const Color.fromARGB(255, 83, 42, 155)),
        child: Center(child: Column( mainAxisSize: MainAxisSize.min, children: [Image.asset(width:200, "assets/logo.png"),
        SizedBox(height:50),
        Text( style: TextStyle(fontSize: 20, color: Colors.white70),"Learn Flutter the fun way!"),
        SizedBox(height:20),
        TextButton(onPressed: () {  },
        style: TextButton.styleFrom(shape:RoundedRectangleBorder()),
        child: Text(style: TextStyle(fontSize: 15, color: Colors.white70, ),"Start Quiz"))
        ],
      ),
      )
      ),
      ),
    ),
  );
}