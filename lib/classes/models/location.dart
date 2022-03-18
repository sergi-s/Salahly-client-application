class CustomLocation {
  late double longitude;
  late double latitude;
  late String? address;
  late String? name;
  late LocationType? type;

  CustomLocation({required this.longitude, required this.latitude, this.address, this.name,this.type});
}

enum LocationType{mechanic,provider}