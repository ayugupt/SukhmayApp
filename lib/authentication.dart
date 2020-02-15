import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthResult result;
  FirebaseUser user;

  Future<void> signUp(String email, String password) async {
    result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    user = result.user;
    await user.sendEmailVerification();
  }

  Future<bool> signIn(String email, String password) async {
    result = await auth.signInWithEmailAndPassword(email: email, password: password);
    user = result.user;
    if(!user.isEmailVerified){
      await user.sendEmailVerification();
      return false;
    }
    else{
      return true;
    }
  }

  Future<void> logOut()async{
    await auth.signOut();
  }
}
