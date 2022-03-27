import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';

Future getMechanicOrProviderData(String id) async {
  DataSnapshot ds = await dbRef.child("users").child(id).get();
  if(ds.child("type").value.toString() == "mechanic") {
    return Mechanic(
      isCenter: false,
      avatar: "",
      phoneNumber: "1231231234",
      id: id,
      name: (ds.child("name").value).toString(),
      email: (ds.child("email").value).toString(),
      rating: toDouble((ds.child("rating").value).toString()));
  }else {
    return TowProvider(
        isCenter: toBoolean((ds.child("name").value).toString()),
        avatar: "",
        phoneNumber: "1231231234",
        id: id,
        name: (ds.child("name").value).toString(),
        email: (ds.child("email").value).toString(),
        rating: toDouble((ds.child("rating").value).toString()));
  }
}