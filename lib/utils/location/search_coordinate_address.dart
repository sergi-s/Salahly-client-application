import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/http_request.dart';

Future<String> searchCoordinateAddress(double long, double lat) async {
late String placeAddress;
String geoURL =
    "https://open.mapquestapi.com/geocoding/v1/reverse?key=$geoCodingKey&includeRoadMetadata=true&includeNearestIntersection=true&location=${lat},${long}";

var response = await httpRequest(geoURL);

if (response != "failed") {
placeAddress =
"${response["results"][0]["locations"][0]["street"]}, ${response["results"][0]["locations"][0]["adminArea3"]}, ${response["results"][0]["locations"][0]["adminArea1"]}";
}
return placeAddress;
}