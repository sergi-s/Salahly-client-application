import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "package:go_router/go_router.dart";
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/widgets/WSA/prediction_tile.dart';
import 'package:slahly/utils/constants.dart';

import 'package:slahly/utils/http_request.dart';

import 'package:slahly/classes/models/place_predictions.dart';
import 'package:slahly/widgets/WSA/search_text_field.dart';

class WSASearchScreen extends StatefulWidget {
  static const String routeName = "/WSASearchScreen";

  final CustomLocation pikUpLocation;

  WSASearchScreen({Key? key, required this.pikUpLocation}) : super(key: key);

  @override
  _WSASearchScreenState createState() => _WSASearchScreenState();
}

class _WSASearchScreenState extends State<WSASearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  List<PlacePredictions> dropOffPlacePredictionList = [];

  @override
  Widget build(BuildContext context) {
    pickUpTextEditingController.text = widget.pikUpLocation.address.toString();
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 215,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, top: 20, right: 25, bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Stack(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.arrow_back),
                        onTap: context.pop,
                      ),
                      const Center(
                        child: Text(
                          "Set Where to",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  SearchTextField(
                    icon: const Icon(Icons.my_location),
                    hint: "Your current location",
                    textEditingController: pickUpTextEditingController,
                    onTap: findPlace,
                  ),
                  const SizedBox(height: 16),
                  SearchTextField(
                    icon: const Icon(Icons.pin_drop),
                    hint: "Where to?",
                    textEditingController: dropOffTextEditingController,
                    onTap: findPlace,
                  )
                ],
              ),
            ),
          ),

          //predictions
          const SizedBox(height: 10),
          (dropOffPlacePredictionList.length > 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return PredictionTile(
                          placePredictions: dropOffPlacePredictionList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: dropOffPlacePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container()),
        ],
      ),
    ));
  }

  void findPlace(String placeName) async {
    // "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&location=${loc.latitude},${loc.longitude} &radius=500&key=${googleMapsAPI}";
    if (placeName.length > 1) {
      //TODO get user subscription
      String autoCompleteURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&&radius=500&key=${googleMapsAPI}&location=${widget.pikUpLocation.latitude},${widget.pikUpLocation.longitude}&radius=500";

      var res = await httpRequest(autoCompleteURL);

      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        setState(() {
          dropOffPlacePredictionList = placesList;
        });
      }
    }
  }
}
