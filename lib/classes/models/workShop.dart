import 'package:slahly/classes/models/location.dart';

class WorkShop {
  String? id;
  String? name;
  bool isCenter;
  String? phoneNumber;

  CustomLocation loc;

  WorkShop(
      {this.id,
      this.name,
      required this.isCenter,
      this.phoneNumber,
      required this.loc});
}
