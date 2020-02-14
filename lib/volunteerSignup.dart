import 'package:flutter/material.dart';
import 'homePage.dart';

class VolunteerSignup extends StatefulWidget {
  VolunteerSignupState createState() => VolunteerSignupState();
}

class VolunteerSignupState extends State<VolunteerSignup> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, address, age, mobileNum, gender;
  final passwordController = TextEditingController();

  final double ratio = 0.9;
  final double gap = 20;

  bool male = false, female = false, other = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Widget genderCheck() {
    return Container(
        child: Row(
      children: [
        Row(
          children: <Widget>[
            Text("Male"),
            Checkbox(
              value: male,
              onChanged: (value) {
                setState(() {
                  male = value;
                });
              },
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text("Female"),
            Checkbox(
              value: female,
              onChanged: (value) {
                setState(() {
                  female = value;
                });
              },
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text("Other"),
            Checkbox(
              value: other,
              onChanged: (value) {
                setState(() {
                  other = value;
                });
              },
            )
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    ));
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
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    onSaved: (input) => _name = input,
                  ),
                  width: MediaQuery.of(context).size.width * ratio,
                ),
                SizedBox(
                  height: gap,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Address"),
                    onSaved: (input) => address = input,
                  ),
                  width: MediaQuery.of(context).size.width * ratio,
                ),
                SizedBox(
                  height: gap,
                ),
                Padding(
                  child: Align(
                    child: Text(
                      "Gender",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05, 10, 0, 0),
                ),
                genderCheck(),
                Container(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Email-ID"),
                      validator: (input) =>
                          !input.contains('@') ? "Not a valid email-ID" : null,
                      onSaved: (input) => _email = input,
                    ),
                    width: MediaQuery.of(context).size.width * ratio),
                SizedBox(
                  height: gap,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Mobile Number"),
                    validator: (input) =>
                        input.length != 10 ? "Invalid Mobile Number" : null,
                    onSaved: (input) => mobileNum = input,
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
                    controller: passwordController,
                  ),
                  width: MediaQuery.of(context).size.width * ratio,
                ),
                SizedBox(
                  height: gap,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Re-enter password"),
                    validator: (input) => input != passwordController.text
                        ? "Password re-entered incorrectly"
                        : null,
                  ),
                  width: MediaQuery.of(context).size.width * ratio,
                ),
                SizedBox(
                  height: 20,
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
                  minWidth: MediaQuery.of(context).size.width * 0.6,
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
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.1,
                  buttonColor: Colors.white,
                ),
              ],
            ),
          )
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
