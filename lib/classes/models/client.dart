import 'package:flutter/cupertino.dart';
import 'package:slahly/abstract_classes/user.dart';

class Client extends UserType {
  int subscription;

  Client({
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
    required this.subscription,
  }) : super(name: name, email: email, id: id);

  @override
  set setPassword(String value) {
    super.setPassword = value;
  }

  @override
  bool isValid() {
    return (super.isValid() && subscriptionValidate(subscription));
  }
  // Validation
  bool subscriptionValidate(int subscription) {
    return subscription > 0;
  }
}
