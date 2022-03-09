
import 'package:flutter_flavor/flutter_flavor.dart';

dynamic getGoogleMapsAPI() async{
  return FlavorConfig.instance.variables["maps_api"];
  // return await DotEnv().env['GOOGLE_MAPS_API'];
}

