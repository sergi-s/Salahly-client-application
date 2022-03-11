class WorkShop {
  String? id;
  String? name;
  bool isCenter;
  String? phoneNumber;
  String address;

  double latitude;
  double longitude;

  WorkShop(
      {this.id,
      this.name,
      required this.isCenter,
      this.phoneNumber,
      required this.address,
      required this.longitude,
      required this.latitude});
}
