import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'homePage.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final double ratio = 0.9;
  final double gap = 20;

  String _email, _password;

  bool isProcessing = false;

  Auth auth = new Auth();

  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      ListView(children: <Widget>[
        Center(
          child: Image.asset("images/placeholder.jpg"),
        ),
        Form(
            key: formKey,
            child: Column(children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Email-ID"),
                  onSaved: (input) => _email = input,
                ),
                width: MediaQuery.of(context).size.width * ratio,
              ),
              SizedBox(
                height: gap,
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  onSaved: (input) => _password = input,
                  obscureText: true,
                ),
                width: MediaQuery.of(context).size.width * ratio,
              ),
              SizedBox(
                height: gap,
              ),
              ButtonTheme(
                child: RaisedButton(
                  child: Text(
                    "LOG IN",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    saveAndLogin(context);
                  },
                ),
                minWidth: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                child: Text(
                  errorMsg,
                  style: TextStyle(color: Colors.red),
                ),
                alignment: Alignment.center,
              ),
            ]))
      ]),
      isProcessing
          ? Container(
              child: Center(child: CircularProgressIndicator()),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            )
          : SizedBox(
              height: 0,
              width: 0,
            )
    ]));
  }

  void saveAndLogin(BuildContext context) {
    setState(() {
      errorMsg = "";
      isProcessing = true;
    });
    formKey.currentState.save();

    auth.signIn(_email, _password).then((bool verified) {
      if (verified) {
        OpeningScreenState.authStatus = AuthStatus.LOGGED_IN;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext c) {
          return HomePage();
        }), (Route<dynamic> route) => false);
      } else {
        setState(() {
          errorMsg =
              "Youe Email-ID is not verified. A verification Emai has been sent to your Email-ID";
          isProcessing = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isProcessing = false;
        errorMsg = e.message;
      });
    });
  }
}
