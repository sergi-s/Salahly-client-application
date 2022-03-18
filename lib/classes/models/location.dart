class CustomLocation {
  late double longitude;
  late double latitude;
  late String? address;
  late String? name;
  late LocationType? type;

  CustomLocation({required this.latitude, required this.longitude, this.address, this.name,this.type});
}

enum LocationType{mechanic,provider}