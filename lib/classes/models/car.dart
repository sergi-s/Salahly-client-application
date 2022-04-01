class Car {
  String? id;
  String? model;
  String? color;
  String noPlate;
  String? noChassis;
  CarAccess? carAccess;

  Car(
      {this.id,
      this.model,
      this.color,
      required this.noPlate,
      this.noChassis,
      this.carAccess});

  final Map<CarAccess, String> _CarAccess = {
    CarAccess.owner: "Owner",
    CarAccess.sub: "SubOwner",
  };

  String? getCarAccess() {
    return _CarAccess.containsKey(carAccess) ? _CarAccess[carAccess] : "";
  }

  @override
  String toString() {
    return "$model $noPlate";
  }
}

enum CarAccess { owner, sub }
