import 'package:flutter/material.dart';
import 'authentication.dart';
import 'homePage.dart';
import 'main.dart';
import 'volunteerSignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'modalWidget.dart';
import 'codeInput.dart';
import 'databaseClass.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final double ratio = 0.9;
  final double gap = 20;

  String _email, _password;
  String mobNum;

  static String code;

  bool isProcessing = false;

  Auth auth = new Auth();

  String errorMsg = "";

  bool phoneAuth = false;
  String logInChoice = "Log In using Mobile Number";
  String emailOrNum = "Email-ID";

  FirebaseAuth autho = FirebaseAuth.instance;

  DatabaseClass database = new DatabaseClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      ListView(children: <Widget>[
        Center(
          child:Container(
            color: Colors.white,
            child: Image.asset("images/safesis_logo.png"),
          ),
        ),
        Form(
            key: formKey,
            child: Column(children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: emailOrNum),
                  onSaved: (input) {
                    if (phoneAuth) {
                      mobNum = input;
                    } else if (!phoneAuth) {
                      _email = input;
                    }
                  },
                ),
                width: MediaQuery.of(context).size.width * ratio,
              ),
              SizedBox(
                height: gap,
              ),
              !phoneAuth
                  ? Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Password"),
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                      width: MediaQuery.of(context).size.width * ratio,
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
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
                    if (!phoneAuth) {
                      saveAndLoginEmail(context);
                    } else {
                      saveAndLoginMobile();
                    }
                  },
                ),
                minWidth: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              FlatButton(
                child: Text(logInChoice),
                onPressed: () {
                  setState(() {
                    phoneAuth = !phoneAuth;
                    if (phoneAuth == true) {
                      logInChoice = "Log In using Email-ID";
                      emailOrNum = "Mobile Number";
                    } else {
                      logInChoice = "Log In using Mobile Number";
                      emailOrNum = "Email-ID";
                    }
                  });
                },
              ),
              FlatButton(
                child: Text("Don't have an Account? Sign Up!"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext c) {
                    return VolunteerSignup();
                  }));
                },
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                child: Text(
                  errorMsg,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
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

  void saveAndLoginEmail(BuildContext context) {
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
              "You're Email-ID is not verified. A verification Email has been sent to your Email-ID";
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

  void saveAndLoginMobile() async {
    formKey.currentState.save();
    setState(() {
      isProcessing = true;
    });

    try {
      bool user = await database.checkNumber("Users", "+91" + mobNum);
      if (user == true) {
        await autho.verifyPhoneNumber(
            phoneNumber: "+91" + mobNum,
            verificationCompleted: (credential) async {
              print("done");
              await autho.signInWithCredential(credential);
              OpeningScreenState.authStatus = AuthStatus.LOGGED_IN;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (cntxt) {
                return HomePage();
              }), (Route<dynamic> route) => false);
            },
            verificationFailed: (e) {
              setState(() {
                isProcessing = false;
                errorMsg = e.message;
              });
            },
            codeSent: (id, [a]) {
              Navigator.push(
                      context,
                      PopupLayout(
                          left: 20,
                          right: 20,
                          top: 100,
                          bottom: 250,
                          child: CodeInput()))
                  .then((_) {
                autho
                    .signInWithCredential(PhoneAuthProvider.getCredential(
                        verificationId: id, smsCode: code))
                    .then((result) {
                  OpeningScreenState.authStatus = AuthStatus.LOGGED_IN;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (cnt) {
                    return HomePage();
                  }), (Route<dynamic> route) => false);
                }).catchError((e) {
                  setState(() {
                    isProcessing = false;
                    errorMsg = e.message;
                  });
                });
              });
              print("sent");
            },
            codeAutoRetrievalTimeout: (id) {
              print(id);
            },
            timeout: Duration(seconds: 20));
      } else {
        setState(() {
          isProcessing = false;
          errorMsg =
              "Your Mobile number is not registered. Please Sign Up using Mobile number";
        });
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
        errorMsg = e.message;
      });
    }
  }
}
