import 'package:flutter/cupertino.dart';
import 'package:slahly/abstract_classes/user.dart';

class Mechanic extends UserType {
  String? nationalID;
  bool? isCenter;
  bool? isAccepted;

  Mechanic({
    required String? name,
    required String? email,
    String? id,
    String? birthDay,
    String? createdDate,
    State? state,
    Sex? sex,
    Type? type,
    String? avatar,
    String? address,
    String? phoneNumber,
    this.isAccepted,
    this.isCenter,
    this.nationalID,
  }) : super(name: name, email: email, id: id);

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
