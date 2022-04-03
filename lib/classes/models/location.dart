class CustomLocation {
  late double longitude;
  late double latitude;
  late String? address;
  late String? name;
  late LocationType? type;
  late String? id;

  CustomLocation(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.name,
      this.type,
      this.id,
      });

  @override
  String toString() {
    return "ToString: ${name} at lat:$latitude, long:$longitude, address:$address";
  }
}

enum LocationType { mechanic, provider }
