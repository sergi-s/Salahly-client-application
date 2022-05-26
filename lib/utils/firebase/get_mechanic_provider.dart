import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';
import 'package:slahly/abstract_classes/user.dart';

Future getMechanicOrProviderData(String id) async {
  DataSnapshot ds = await dbRef.child("users").child(id).get();
  print("Ana waslt hena1${ds.child("name").value.toString()}");

  String avatar =
      "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
  if ((ds.child("avatar").value) != null) {
    avatar = (ds.child("avatar").value).toString();
  }
  //
  // String address = "address";
  // if ((ds.child("address").value) != null) {
  //   address = (ds.child("address").value).toString();
  // }

  if (ds.child("type").value.toString() == "mechanic") {
    print("Ana waslt hena2${ds.child("name").value.toString()}");
    return Mechanic(
        isCenter: false,
        avatar: avatar,
        phoneNumber: (ds.child("phoneNumber").value).toString(),
        id: id,
        name: (ds.child("name").value).toString(),
        type: Type.mechanic,
        email: (ds.child("email").value).toString(),
        rating: toDouble((ds.child("rating").value).toString()),
        address: "address");
  } else {
    return TowProvider(
        isCenter: toBoolean((ds.child("isCenter").value).toString()),
        avatar: "",
        phoneNumber: (ds.child("phoneNumber").value).toString(),
        id: id,
        type: Type.provider,
        name: (ds.child("name").value).toString(),
        email: (ds.child("email").value).toString(),
        rating: toDouble((ds.child("rating").value).toString()),
        address: "address");
  }
}
