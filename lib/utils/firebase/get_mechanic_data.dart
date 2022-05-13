import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/abstract_classes/user.dart';
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
      await dbRef.child("users").child(id).get();

  // print(">>>>>>>${ds.value}");
  // print("saddddddde");
  return Mechanic(
      isCenter: false,
      avatar:
          "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png",
      phoneNumber: (ds.child("phoneNumber").value).toString(),
      id: id,
      name: (ds.child("name").value).toString(),
      type: Type.mechanic,
      email: (ds.child("email").value).toString(),
      rating: toDouble((ds.child("rating").value).toString()),
      address: "address");
}
