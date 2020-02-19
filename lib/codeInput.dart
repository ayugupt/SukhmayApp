import 'package:flutter/material.dart';
import 'volunteerSignup.dart';
import 'login.dart';

class CodeInput extends StatefulWidget {
  CodeInputState createState() => CodeInputState();
}

class CodeInputState extends State<CodeInput> {
  TextEditingController textFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ClipRRect(
        child: Container(
          child: Column(children: <Widget>[
            Align(
              child: Text(
                "Enter the OTP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topCenter,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: TextFormField(
                controller: textFieldController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "OTP",
                    filled: true,
                    fillColor: Colors.white),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Done"),
                  onPressed: () {
                    VolunteerSignupState.code = textFieldController.text;
                    LoginPageState.code = textFieldController.text;
                    Navigator.pop(context);
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ]),
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
              color: Colors.grey),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      onWillPop: () async => false,
    );
  }
}
