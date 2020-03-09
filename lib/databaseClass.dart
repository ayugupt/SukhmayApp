import 'dart:async';
import 'dart:developer';
import 'authentication.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseClass {
  DatabaseReference ref;
  Auth auth = new Auth();
  //StreamSubscription stream;

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

  Future<Stream<Event>> sosAlert() async {
    String uid = await auth.returnUid();
    Stream<Event> alert = FirebaseDatabase.instance
        .reference()
        .child("Users/$uid/helping")
        .onChildAdded;
    return alert;
  }

  Stream<Event> getVictimsLocation(String uid) {
    Stream<Event> stream = FirebaseDatabase.instance
        .reference()
        .child("Users/$uid")
        .onChildChanged;
    return stream;
  }

  Future<void> removeFromSos() async {
    String uid = await auth.returnUid();
    ref = FirebaseDatabase.instance.reference().child("SOS/$uid");
    await ref.remove();
  }

  Stream<Event> deleteHelping(String id) {
    return FirebaseDatabase.instance
        .reference()
        .child("SOS/$id")
        .onChildRemoved;
  }
}
