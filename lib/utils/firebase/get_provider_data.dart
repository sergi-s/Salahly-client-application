import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

Future getProviderData(String id, {String? rsaID}) async {
  // FirebaseEmulatorScreen().readmsg();
  DataSnapshot ds = await dbRef.child("users").child(id).get();
  String name = "name";
  if (ds.child("name").value != null) {
    name = (ds.child("name").value).toString();
  }
  String avatar =
      "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
  if ((ds.child("avatar").value) != null && (ds.child("avatar").value) != '') {
    avatar = (ds.child("avatar").value).toString();
  }

  double rating = 1;
  if (ds.child("rating").value != null) {
    double count =
        toDouble((ds.child("rating").child("count").value).toString());
    if (count == 0) count = 1;
    rating =
        toDouble((ds.child("rating").child("sum").value).toString()) / count;
    rating = roundDouble(rating, 2);
  }
  String address = "address_";
  if ((ds.child("address").value) != null) {
    address = (ds.child("address").value).toString();
  }
  String? estimatedTime;
  print("estimatedTime");
  if(rsaID!=null){
    DataSnapshot tp =
    await dbRef.child("providersRequests").child(id).child(rsaID).get();
    if (tp.value != null) {
      estimatedTime = tp.child("estimatedTime").value.toString();
      print(tp.value);
    }
  }

  return TowProvider(
      isCenter: toBoolean((ds.child("isCenter").value).toString()),
      avatar: avatar,
      phoneNumber: (ds.child("phoneNumber").value).toString(),
      id: id,
      type: Type.provider,
      name: name,
      email: (ds.child("email").value).toString(),
      rating: rating,
      address: address,
      nationalID: (ds.child("nationalID").value).toString(),
      estimatedTime: estimatedTime);
}
