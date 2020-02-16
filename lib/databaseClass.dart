import 'package:firebase_database/firebase_database.dart';

class DatabaseClass
{
  DatabaseReference ref;

  Future<void> pushDataWithoutKey(String path, dynamic val) async
  {
    ref = FirebaseDatabase.instance.reference().child(path);
    await ref.set(val);
  }
}