import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';

import "package:slahly/widgets/dropOff/TextFieldOnMap.dart";
import 'package:slahly/widgets/location/mapWidget.dart';

import 'package:slahly/screens/DropOff_screens/dropOff_search_screen.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/app_data.dart';

import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';

import 'package:slahly/utils/firebase/get_provider_data.dart';

class DropOffLocationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/DropOffLocationScreen";

  const DropOffLocationScreen({Key? key}) : super(key: key);

  @override
  _DropOffLocationScreenState createState() => _DropOffLocationScreenState();
}

class _DropOffLocationScreenState extends ConsumerState<DropOffLocationScreen> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();
  bool didRequest = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ref.watch(salahlyClientProvider.notifier).getSavedData();
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getString("towProvider") != null) {
        ref.watch(rsaProvider.notifier).assignProvider(
            await getProviderData(prefs.getString("towProvider")!), false);
      }

      if (ref.watch(salahlyClientProvider).requestType == RequestType.TTA) {
        ref.watch(rsaProvider.notifier).assignRequestID(
            ref.watch(salahlyClientProvider).requestID.toString());
        context.push(ChooseProviderScreen.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MapWidget(key: myMapWidgetState),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
              height: 270,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(("hi_there".tr()),
                        style: const TextStyle(fontSize: 12)),
                    Text(("where_to".tr()),
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    TextFieldOnMap(
                      isSelected: false,
                      textToDisplay: ("your_current_location".tr()),
                      iconToDisplay: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Consumer(
                      builder: (context, ref, child) {
                        return GestureDetector(
                          onTap: () {
                            print(
                                "before next scree${myMapWidgetState.currentState!.currentCustomLoc.toString()}");

                            if (ref.watch(salahlyClientProvider).requestType !=
                                null) {
                              if (ref
                                      .watch(salahlyClientProvider)
                                      .requestType ==
                                  RequestType.TTA) {
                                context.push(DropOffSearchScreen.routeName,
                                    extra: myMapWidgetState
                                        .currentState!.currentCustomLoc);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text("There is another ongoing request"),
                                ));
                              }

                              return;
                            }
                            context.push(DropOffSearchScreen.routeName,
                                extra: myMapWidgetState
                                    .currentState!.currentCustomLoc);
                          },
                          child: getProviderWidget(),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.80,
          right: 0,
          bottom: MediaQuery.of(context).size.height * 0.19,
          child: ElevatedButton(
            onPressed: () => myMapWidgetState.currentState?.locatePosition(),
            child: const Icon(
              Icons.location_on,
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    ));
  }

// Get assigned Provider
  Widget getProviderWidget() {
    return (ref.watch(rsaProvider).towProvider != null
        ? mapTowProviderToWidget(ref.watch(rsaProvider).towProvider!)
        // ? Container(child: Text("Mech exits"))
        : TextFieldOnMap(
            textToDisplay:
                didRequest ? "choose_provider".tr() : "where_to".tr(),
            imageIconToDisplay:
                const ImageIcon(AssetImage('assets/images/tow-truck 2.png')),
            isSelected: !didRequest,
          ));
  }
}
