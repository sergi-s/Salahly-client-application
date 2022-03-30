import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';

class Mechanic extends UserType {
  String? nationalID;
  bool? isCenter;
  bool? isAccepted;
  double? rating;

  Mechanic({
    required String? name,
    required String? email,
    this.rating,
    String? id,
    String? birthDay,
    String? createdDate,
    AccountState? userState,
    Gender? gender,
    Type? type,
    String? avatar,
    CustomLocation? loc,
    String? phoneNumber,
    this.isAccepted,
    this.isCenter,
    this.nationalID,
  }) : super(
            name: name,
            email: email,
            id: id,
            birthDay: birthDay,
            createdDate: createdDate,
            state: userState,
            gender: gender,
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
