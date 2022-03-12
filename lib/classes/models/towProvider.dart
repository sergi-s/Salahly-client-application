import 'package:flutter/cupertino.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';

class TowProvider extends UserType {
  String? nationalID;
  bool? isCenter;
  bool? isAccepted;

  List<TowDriver> towDriver = [];

  TowProvider({
    required String? name,
    required String? email,
    String? id,
    String? birthDay,
    String? createdDate,
    AccountState? userState,
    Sex? sex,
    Type? type,
    String? avatar,
    String? address,
    String? phoneNumber,
    Location? loc,
    this.isAccepted,
    required this.isCenter,
    required this.nationalID,
  }) : super(
            name: name,
            email: email,
            id: id,
            birthDay: birthDay,
            createdDate: createdDate,
            state: userState,
            sex: sex,
            type: type,
            avatar: avatar,
            loc: loc,
            phoneNumber: phoneNumber);

  @override
  set setPassword(String value) {
    super.setPassword = value;
  }

  @override
  bool isValid() {
    return (super.isValid() && nationalIDValidate(nationalID!));
  }

  // Validation
  bool nationalIDValidate(String id) {
    return id.length > 0;
  }
}

class TowDriver {
  String nationalID;
  bool isCenter;
  bool isAccepted;
  String name;
  String hireDate;

  TowDriver(this.nationalID, this.isCenter, this.isAccepted, this.name,
      this.hireDate);
}
