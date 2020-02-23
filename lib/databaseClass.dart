import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class DatabaseClass {
  DatabaseReference ref;

  Future<void> pushDataWithoutKey(String path, dynamic val) async {
    ref = FirebaseDatabase.instance.reference().child(path);
    await ref.set(val);
  }

  Future<bool> checkNumber(String path, String number) async {
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child(path)
        .orderByChild("MobileNumber")
        .equalTo(number)
        .once();

    if (snap.value == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> pushNumber(String path, String number) async {
    ref = FirebaseDatabase.instance.reference().child(path);
    Map<String, dynamic> phoneMap = new Map<String, dynamic>();
    phoneMap["MobileNumber"] = number;
    await ref.set(phoneMap);
  }
}
