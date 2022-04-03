import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import "package:slahly/classes/models/place_predictions.dart";

import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/http_request.dart';
import 'package:slahly/widgets/location/progressDialog.dart';

class PredictionTile extends ConsumerWidget {
  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);
  final PlacePredictions placePredictions;

  @override
  Widget build(BuildContext context, ref) {
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id!, ref, context);
      },
      child: Container(
          child: Column(
        children: [
          SizedBox(width: 10),
          Row(
            children: [
              const Icon(Icons.add_location),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placePredictions.main_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      placePredictions.secondary_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      )),
    );
  }

  void getPlaceAddressDetails(String place_id, ref, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Setting Drop off, please wait"));

    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place_id}&key=${googleMapsAPI}";

    var res = await httpRequest(placeDetailsURL);

    if (res == "failed" || res["status"] != "OK") return;
    CustomLocation customLocation = CustomLocation(
        id: place_id,
        name: res["result"]["name"],
        latitude: res["result"]["geometry"]["location"]["lat"],
        longitude: res["result"]["geometry"]["location"]["lng"]);

    ref.watch(rsaProvider.notifier).assignDropOffLocation(customLocation);

    Navigator.pop(context);
  }
}
