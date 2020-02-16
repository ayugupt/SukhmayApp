import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GetUserData {
  FirebaseStorage store =
      FirebaseStorage(storageBucket: "gs://swaraksha-3abd1.appspot.com");
  FirebaseUser currentUser;

  Response response;
  List<dynamic> userInfo = new List<dynamic>();
  //String name, address, mobileNo, email, gender;

  Future<List<dynamic>> fetchData() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    String url = await store
        .ref()
        .child("${currentUser.uid}/${currentUser.uid}.json")
        .getDownloadURL();
    response = await get(url);
    Map<String, dynamic> userData = jsonDecode(response.body);
    userInfo = userData.values.toList();
    return userInfo;
  }
}
