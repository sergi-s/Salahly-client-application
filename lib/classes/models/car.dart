import 'dart:ui';

class Car {
  String? id;
  String? model;
  Color? color;
  String noPlate;
  String? noChassis;
  CarAccess? carAccess;

  List<String> usersId = [];

  Car(
      {this.id,
      this.model,
      this.color,
      required this.noPlate,
      this.noChassis,
      this.carAccess});

  addSubOwner(String userID) {
    usersId.add(userID);
  }

  removeSubOwner(String userID) {
    usersId = [
      for (var id in usersId)
        if (userID != id) id
    ];
  }

  final Map<CarAccess, String> _CarAccess = {
    CarAccess.owner: "Owner",
    CarAccess.sub: "SubOwner",
  };

  String? getCarAccess() {
    return _CarAccess.containsKey(carAccess) ? _CarAccess[carAccess] : "";
  }

  @override
  String toString() {
    return "model:$model\tnoPlate:$noPlate\tnoChassis:$noChassis";
  }
}

enum CarAccess { owner, sub }
