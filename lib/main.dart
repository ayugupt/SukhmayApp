import 'dart:async';
import 'package:flutter/material.dart';
import 'userChoice.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swaraksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OpeningScreen(),
    );
  }
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class OpeningScreen extends StatefulWidget {
  OpeningScreenState createState() => OpeningScreenState();
}

class OpeningScreenState extends State<OpeningScreen> {
  static AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user == null) {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      } else {
        if (user.isEmailVerified) {
          authStatus = AuthStatus.LOGGED_IN;
        } else {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      }
    });
    Timer(Duration(seconds: 3), () {
      print(authStatus);
      if (authStatus == AuthStatus.NOT_LOGGED_IN) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext c) {
          return UserChoice();
        }));
      } else if (authStatus == AuthStatus.LOGGED_IN) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext c) {
          return HomePage();
        }));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Center
          (child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    Text(
                    'Made with ',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                    Text(
                    '\u{2665} ',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.red[700],
                    ),
                  ),
                    Text(
                    'at',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Image.asset("images/innomages_logo.png"
                    ),
                  Text(
                    ' and ',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset("images/s_logo.png"
                  ),
                ],
              ),
            ],
          ),
        ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepOrange[700],Colors.white10,Colors.lightGreen[800],],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }
}
