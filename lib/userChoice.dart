import 'package:flutter/material.dart';
import 'volunteerSignup.dart';

class UserChoice extends StatefulWidget {
  UserChoiceState createState() => UserChoiceState();
}

class UserChoiceState extends State<UserChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Text(
              "Are you a Volunteer or a Citizen?",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ButtonTheme(
              child: RaisedButton(
                child: Text("VOLUNTEER"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return VolunteerSignup();
                  }));
                },
              ),
              minWidth: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ButtonTheme(
              child: RaisedButton(
                child: Text("CITIZEN"),
                onPressed: () {},
              ),
              minWidth: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue[500], Colors.blue[200]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
      ),
    ));
  }
}
