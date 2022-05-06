import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';

Future getProviderData(String id) async {
  // FirebaseEmulatorScreen().readmsg();
  DataSnapshot ds =
      await dbRef.child("users").child(id).get();

  return TowProvider(
      isCenter: toBoolean((ds.child("isCenter").value).toString()),
      avatar: "",
      phoneNumber: (ds.child("phoneNumber").value).toString(),
      id: id,
      type: Type.provider,
      name: (ds.child("name").value).toString(),
      email: (ds.child("email").value).toString(),
      rating: toDouble((ds.child("rating").value).toString()),
      address: "address",
      nationalID: (ds.child("nationalID").value).toString());
}
