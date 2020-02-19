import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthResult result;
  FirebaseUser user;

  Future<String> signUp(String email, String password) async {
    result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    await user.sendEmailVerification();
    return user.uid;
  }

  Future<bool> signIn(String email, String password) async {
    result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    user = result.user;
    if (!user.isEmailVerified) {
      await user.sendEmailVerification();
      return false;
    } else {
      return true;
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }

  Future<String> returnUid() async {
    user = await auth.currentUser();
    return user.uid;
  }

  Future<String> verifyThroughPhone(String number) async {
    String error = "";
    String verificationID = "";
    await auth.verifyPhoneNumber(
        phoneNumber: "+91" + number,
        timeout: Duration(seconds: 20),
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          error = e.message;
        },
        codeAutoRetrievalTimeout: (id) {
          verificationID = id;
        },
        codeSent: (id, [a]) {
          verificationID = id;
        });
    if (error == "") {
      return verificationID;
    } else {
      return error;
    }
  }
}
