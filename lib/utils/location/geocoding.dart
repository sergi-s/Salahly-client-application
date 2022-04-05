import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/http_request.dart';

Future<String> searchCoordinateAddress(double long, double lat) async {
  String placeAddress = "";
  String geoURL =
      "https://open.mapquestapi.com/geocoding/v1/reverse?key=$geoCodingKey&includeRoadMetadata=true&includeNearestIntersection=true&location=${lat},${long}";

  var response = await httpRequest(geoURL);

  if (response != "failed") {
    placeAddress =
        "${response["results"][0]["locations"][0]["street"]}, ${response["results"][0]["locations"][0]["adminArea3"]}, ${response["results"][0]["locations"][0]["adminArea1"]}";
  }
  return placeAddress;
}

Future<String> searchCoordinateAddress_google(double lat,double long) async {
  String placeAddress = "";
  String geoURL =
      "https://maps.googleapis.com/maps/api/geocode/json?&key=$googleMapsAPI&latlng=${lat},${long}";

  String str1, str2, str3, str4;

  var response = await httpRequest(geoURL);

  if (response != "failed") {
    str1 = "${response["results"][0]["address_components"][1]["long_name"]}";
    str2 = "${response["results"][0]["address_components"][2]["long_name"]}";
    str3 = "${response["results"][0]["address_components"][3]["long_name"]}";
    // str4 = "${response["results"][0]["address_components"][6]["long_name"]}";

    placeAddress = "$str1, $str2, $str3";
  }
  return placeAddress;
}
