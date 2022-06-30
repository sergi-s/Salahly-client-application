import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';
import 'package:slahly/widgets/dialogues/request_confirmation_dialogue.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/location/mapWidget.dart';
import 'package:slahly/widgets/roadsideassistance/select_car_request.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RoadSideAssistanceScreen extends ConsumerStatefulWidget {
  static const String routeName = "/locationComponent";

  @override
  _RoadSideAssistanceScreenState createState() =>
      _RoadSideAssistanceScreenState();
}

class _RoadSideAssistanceScreenState
    extends ConsumerState<RoadSideAssistanceScreen> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // ref.watch(salahlyClientProvider.notifier).getSavedData();
    });
    super.initState();
  }

  final PanelController _pcCarSlider = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: salahlyAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            MapWidget(key: myMapWidgetState),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.20,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () =>
                      myMapWidgetState.currentState?.locatePosition(),
                  child: const Icon(
                    Icons.location_on,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: const Color(0xFF193566),
                    padding: const EdgeInsets.all(10),
                  ),
                )),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.25,
                bottom: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    if (ref.watch(salahlyClientProvider).requestType != null) {
                      if (ref.watch(salahlyClientProvider).requestType ==
                          RequestType.RSA) {
                        context.push(SearchingMechanicProviderScreen.routeName,
                            extra: myMapWidgetState
                                .currentState!.currentCustomLoc);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text("onGoingRequest".tr()),
                        ));
                      }
                      return;
                    }
                    _pcCarSlider.open();
                  },
                  child: Text("request".tr()),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                )),
            SelectCarRequest(
              pc: _pcCarSlider,
              onTap: () {
                if (ref.watch(salahlyClientProvider).requestType != null) {
                  if (ref.watch(salahlyClientProvider).requestType ==
                      RequestType.RSA) {
                    context.push(SearchingMechanicProviderScreen.routeName,
                        extra: myMapWidgetState.currentState!.currentCustomLoc);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("onGoingRequest".tr()),
                    ));
                  }
                  return;
                }

                if (ref.watch(rsaProvider).car == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("plzSpecCar".tr()),
                  ));
                  return;
                }
                requestConfirmationDialogue(
                  context,
                  titleChildren: [
                    Text("confirm_location".tr()),
                    const ImageIcon(AssetImage('assets/images/tow-truck 2.png')),
                  ],
                  content: Text("rsaConfirmation".tr() +
                      "\n" +
                      myMapWidgetState.currentState!.currentCustomLoc.address!),
                  actionChildren: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF193566),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          print(myMapWidgetState.currentState!.currentCustomLoc);
                          context.push(SearchingMechanicProviderScreen.routeName,
                              extra: myMapWidgetState.currentState!.currentCustomLoc);
                        },
                        child: Text("confirm_location".tr()))
                  ],
                );
              },
            ),
          ],
        ));
  }

}
