import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> itemWidgets = <Widget>[
    Builder(
      builder: (BuildContext c) {
        return Center(
          child: Container(
            child: InkWell(
              child: Image.asset(
                "images/sos.png",
                fit: BoxFit.fill,
              ),
              onTap: () {},
            ),
            decoration: BoxDecoration(color: Colors.black),
            width: MediaQuery.of(c).size.width * 0.7,
            height: MediaQuery.of(c).size.height * 0.5,
          ),
        );
      },
    ),
    Icon(Icons.remove_red_eye),
    Icon(Icons.reorder)
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: itemWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Profile")),
          BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye), title: Text("Random")),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
