import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import "package:slahly/classes/models/place_predictions.dart";
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/http_request.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';

class PredictionTile extends ConsumerStatefulWidget {
  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);
  final PlacePredictions placePredictions;

  _PredictionTileState createState() => _PredictionTileState();
}

class _PredictionTileState extends ConsumerState<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await getPlaceAddressDetails(widget.placePredictions.place_id!);

        print("${ref.watch(rsaProvider).dropOffLocation} ->>>");
        ref.watch(rsaProvider.notifier).assignRequestTypeToTTA();
        await ref.watch(rsaProvider.notifier).requestTta();
        if(ref.watch(rsaProvider).newNearbyProviders!.isEmpty) {
          ref.watch(rsaProvider.notifier).searchNearbyMechanicsAndProviders();
        }

        print("before app state");

        ref.watch(salahlyClientProvider.notifier).assignRequest(
            ref.watch(rsaProvider).requestType!, ref.watch(rsaProvider).rsaID!);
        print("after app state");

        context.push(ChooseProviderScreen.routeName);
      },
      child: Column(
        children: [
          const SizedBox(width: 10),
          Row(
            children: [
              const Icon(Icons.add_location),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.placePredictions.main_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.placePredictions.secondary_text.toString(),
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
      ),
    );
  }

  Future getPlaceAddressDetails(String placeId) async {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) =>
    //         ProgressDialog(message: "Setting Drop off, please wait"));

    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsAPI";

    var res = await httpRequest(placeDetailsURL);

    if (res == "failed" || res["status"] != "OK") return;
    CustomLocation customLocation = CustomLocation(
        id: placeId,
        name: res["result"]["name"],
        latitude: res["result"]["geometry"]["location"]["lat"],
        longitude: res["result"]["geometry"]["location"]["lng"]);

    ref.watch(rsaProvider.notifier).assignDropOffLocation(customLocation);

    print("drop off location is at ${ref.watch(rsaProvider).dropOffLocation!}");
  }
}
