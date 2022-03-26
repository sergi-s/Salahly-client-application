import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';

Future getMechanicData(String id) async {
  // FirebaseEmulatorScreen().readmsg();

  // dbRef.child("users").child(id).get().then((value) {
  //   print(value.value);
  //
  //   Mechanic me = Mechanic(name: value.value, email: "");
  // });

  DataSnapshot ds =
  await dbRef.child("users").child("mechanics").child(id).get();
  print("saddddddde");
  return Mechanic(
      isCenter: false,
      avatar: "",
      phoneNumber: "1231231234",
      id: id,
      name: (ds.child("name").value).toString(),
      email: (ds.child("email").value).toString(),
      rating: toDouble((ds.child("rating").value).toString()));
}