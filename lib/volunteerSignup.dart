import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'databaseClass.dart';
import 'JsonClass.dart';
import 'dart:io';

class VolunteerSignup extends StatefulWidget {
  VolunteerSignupState createState() => VolunteerSignupState();
}

class VolunteerSignupState extends State<VolunteerSignup> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, address, age, mobileNum, gender;
  final passwordController = TextEditingController();

  String path;

  Future<void> _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    final File file = File('${directory.path}/data.json');
    print("${directory.path}");
    await file.writeAsString(text);
    /*
    final dir = Directory(directory.path);
    await dir.delete();*/
  }

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://swaraksha-3abd1.appspot.com");

  StorageUploadTask _uploadTask;
  String bucketFilePath;

  DatabaseClass dataBase = new DatabaseClass();
  DatabaseJson jsonData = new DatabaseJson();

  Future<void> _startUpload(String uid) async {
    bucketFilePath = '$uid/$uid.json';

    _uploadTask =
        _storage.ref().child(bucketFilePath).putFile(File("$path/data.json"));

    await _uploadTask.onComplete;
  }

  String errorMsg = "";

  final double ratio = 0.9;
  final double gap = 20;

  bool male = false, female = false, other = false;
  bool isProcessing = false;

  Auth auth = new Auth();

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
                  female = false;
                  other = false;
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
                  male = false;
                  other = false;
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
                  male = false;
                  female = false;
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
        body: Stack(children: <Widget>[
      ListView(
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
                    validator: (input) =>
                        input.length > 0 ? null : "Please enter name",
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
                    validator: (input) =>
                        input.length > 0 ? null : "Please enter address",
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
                          !input.contains('@') ? "Invalid email-ID" : null,
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
                    validator: (input) => input.length > 5
                        ? null
                        : "Password should contain more than 5 letters",
                    controller: passwordController,
                    obscureText: true,
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
                    obscureText: true,
                  ),
                  width: MediaQuery.of(context).size.width * ratio,
                ),
                SizedBox(
                  height: 20,
                ),
                Builder(builder: (BuildContext c) {
                  return ButtonTheme(
                    child: RaisedButton(
                      child: Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        submit(c);
                      },
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.1,
                  );
                }),
                Align(
                  child: Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                  alignment: Alignment.center,
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
                        return LoginPage();
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

  void submit(BuildContext context) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        errorMsg = "";
        isProcessing = true;
      });
      auth.signUp(_email, _password).then((String id) {
        String data;
        if (male == true) {
          data =
              "{\n\"Name\":\"$_name\",\n\"Address\":\"$address\",\n\"MobileNo\":\"$mobileNum\",\n\"Email-ID\":\"$_email\",\n\"Gender\":\"Male\"\n}";
        } else if (female == true) {
          data =
              "{\n\"Name\":\"$_name\",\n\"Address\":\"$address\",\n\"MobileNo\":\"$mobileNum\",\n\"Email-ID\":\"$_email\",\n\"Gender\":\"Female\"\n}";
        } else if (other == true) {
          data =
              "{\n\"Name\":\"$_name\",\n\"Address\":\"$address\",\n\"MobileNo\":\"$mobileNum\",\n\"Email-ID\":\"$_email\",\n\"Gender\":\"Other\"\n}";
        }

        _write(data).then((_) {
          _startUpload(id).then((_) {
            final dir = Directory(path);
            dir.deleteSync(recursive: true);
          });
        });

       jsonData.sos = false;
       jsonData.lat = null;
       jsonData.long = null;

       dataBase.pushDataWithoutKey("Citizen/$id", jsonData.toJson());

        setState(() {
          isProcessing = false;
          errorMsg = "";
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("A verification email has been sent to your Email-ID"),
        ));
      }).catchError((e) {
        setState(() {
          isProcessing = false;
          errorMsg = e.message;
        });
      });
    }
  }
}
