import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:go_router/go_router.dart";

import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/http_request.dart';

import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/place_predictions.dart';
import 'package:slahly/classes/provider/rsadata.dart';

import 'package:slahly/widgets/dropOff/search_text_field.dart';
import 'package:slahly/widgets/dropOff/prediction_tile.dart';

class DropOffSearchScreen extends ConsumerStatefulWidget {
  static const String routeName = "/DropOffSearchScreen";

  final CustomLocation pikUpLocation;

  const DropOffSearchScreen({Key? key, required this.pikUpLocation})
      : super(key: key);

  @override
  _DropOffSearchScreenState createState() => _DropOffSearchScreenState();
}

class _DropOffSearchScreenState extends ConsumerState<DropOffSearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  List<PlacePredictions> dropOffPlacePredictionList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.watch(rsaProvider.notifier).assignUserLocation(widget.pikUpLocation);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pickUpTextEditingController.text = widget.pikUpLocation.address.toString();
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
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
                        Center(
                          child: Text(
                            "set_where_to".tr(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    SearchTextField(
                      icon: const Icon(Icons.my_location),
                      hint: "your_current_location".tr(),
                      textEditingController: pickUpTextEditingController,
                      onTap: findPlace,
                    ),
                    const SizedBox(height: 16),
                    SearchTextField(
                      icon: const Icon(Icons.pin_drop),
                      hint: "where_to".tr(),
                      textEditingController: dropOffTextEditingController,
                      onTap: findPlace,
                    )
                  ],
                ),
              ),
            ),

            //predictions
            const SizedBox(height: 10),
            (dropOffPlacePredictionList.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.manual,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return PredictionTile(
                              placePredictions:
                                  dropOffPlacePredictionList[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: dropOffPlacePredictionList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    ));
  }

  void findPlace(String placeName) async {
    // "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&location=${loc.latitude},${loc.longitude} &radius=500&key=${googleMapsAPI}";
    if (placeName.length > 1) {
      //TODO get user subscription
      String autoCompleteURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&&radius=500&key=$googleMapsAPI&location=${widget.pikUpLocation.latitude},${widget.pikUpLocation.longitude}&radius=500";

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
