import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';

Future getProviderData(String id) async {
  // FirebaseEmulatorScreen().readmsg();
  DataSnapshot ds =
  await dbRef.child("users").child("providers").child(id).get();

  return TowProvider(
      id: id,
      name: (ds.child("name").value).toString(),
      email: (ds.child("email").value).toString(),
      rating: toDouble((ds.child("rating").value).toString()),
      isCenter: toBoolean((ds.child("isCenter").value).toString()),
      nationalID: (ds.child("nationalID").value).toString());
}