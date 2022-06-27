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

  DataSnapshot ds = await dbRef.child("users").child(id).get();

  // print(">>>>>>>${ds.value}");
  // print("saddddddde");
  String avatar =
      "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
  if ((ds.child("avatar").value) != null) {
    avatar = (ds.child("avatar").value).toString();
  }

  double? rating = 1;
  if (ds.child("rating").value != null) {
    double count =
        toDouble((ds.child("rating").child("count").value).toString());
    if (count == 0) count = 1;
    rating =
        toDouble((ds.child("rating").child("sum").value).toString()) / count;
  }

  String address = "address";
  if ((ds.child("address").value) != null) {
    address = (ds.child("address").value).toString();
  }
  return Mechanic(
      isCenter: false,
      avatar: avatar,
      phoneNumber: (ds.child("phoneNumber").value).toString(),
      id: id,
      name: (ds.child("name").value).toString(),
      type: Type.mechanic,
      email: (ds.child("email").value).toString(),
      rating: rating,
      address: address);
}
