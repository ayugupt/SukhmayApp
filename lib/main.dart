import 'dart:async';
import 'package:flutter/material.dart';
import 'userChoice.dart';
import 'homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpeningScreen(),
    );
  }
}

class OpeningScreen extends StatefulWidget {
  OpeningScreenState createState() => OpeningScreenState();
}

class OpeningScreenState extends State<OpeningScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) {
        return UserChoice();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Image.asset("images/placeholder.jpg")),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue[500], Colors.blue[200]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
      ),
    );
  }
}
