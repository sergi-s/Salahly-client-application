
class PlacePredictions {
  String? secondary_text, main_text, place_id;

  PlacePredictions({this.secondary_text, this.main_text, this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    secondary_text = json["structured_formatting"]["secondary_text"];
    main_text = json["structured_formatting"]["main_text"];
  }
}
