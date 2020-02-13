import 'package:flutter/material.dart';
import 'homePage.dart';

class VolunteerSignup extends StatefulWidget {
  VolunteerSignupState createState() => VolunteerSignupState();
}

class VolunteerSignupState extends State<VolunteerSignup> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, address, age, mobileNum, gender;
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Center(
            child: Image.asset("images/placeholder.jpg"),
          ),
          Form(
              key: formKey,
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Name"),
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Address"),
                      onSaved: (input) => address = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email-ID"),
                      validator: (input) =>
                          !input.contains('@') ? "Not a valid email-ID" : null,
                      onSaved: (input) => _email = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Mobile Number"),
                      validator: (input) =>
                          input.length != 10 ? "Invalid Mobile Number" : null,
                      onSaved: (input) => mobileNum = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      onSaved: (input) => _password = input,
                      controller: passwordController,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Re-enter password"),
                      validator: (input) => input != passwordController.text
                          ? "Password re-entered incorrectly"
                          : null,
                    ),
                    ButtonTheme(
                      child: RaisedButton(
                        child: Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          submit();
                        },
                      ),
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    ButtonTheme(
                      child: FlatButton(
                        child: Text(
                          "Already a member? Login",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext c) {
                            return HomePage();
                          }));
                        },
                      ),
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.1,
                      buttonColor: Colors.white,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ))
        ],
      ),
    );
  }

  void submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }
}
