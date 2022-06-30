import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/widgets/dialogues/finish_request_dialog_confirmation.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/global_widgets/app_drawer.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class RequestFinalScreen extends ConsumerStatefulWidget {
  static const String routeName = "/requestFinalScreen";

  RequestFinalScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RequestFinalScreen> createState() => _RequestFinalScreenState();
}

class _RequestFinalScreenState extends ConsumerState<RequestFinalScreen> {
  Client currentUser = Client(subscription: SubscriptionTypes.gold);
  String imgURL = "", title = "request", smallDescription = "", subType = "";
  List<Widget> towEndedText = [];
  List<Widget> buttonsList = [];

  void setData() {
    imgURL = ref.watch(rsaProvider).towProvider == null
        ? "assets/images/mechanic.png"
        : "assets/images/tow-truck 2.png";
    print("request type ${ref.watch(rsaProvider).requestType}");
    if (ref.watch(rsaProvider).requestType != null) {
      title = RSA.requestTypeToString(ref.watch(rsaProvider).requestType!);

      if (ref.watch(rsaProvider).requestType == RequestType.RSA) {
        smallDescription = "rsa".tr();
      }
      if (ref.watch(rsaProvider).requestType == RequestType.WSA) {
        smallDescription = "wsa".tr();
      }
      if (ref.watch(rsaProvider).requestType == RequestType.TTA) {
        smallDescription = "tta".tr();
      }
    }
    subType = "${(Client.subscriptionToString(SubscriptionTypes.gold)).tr()}"
            ","
            "${currentUser.getSubscriptionRange()}" +
        ("km".tr());

    towEndedText = [];
    buttonsList = [];
    if (ref.watch(rsaProvider).towProvider != null) {
      towEndedText.add(MyTwoEndTextDivided(
          firstStr: "provider".tr(),
          secondStr: ref.watch(rsaProvider).towProvider!.name));
      towEndedText.add(MyTwoEndTextDivided(
          firstStr: "expectedTime".tr(),
          secondStr: (ref.watch(rsaProvider).towProvider!.estimatedTime ??
              "--") + " ${"min".tr()}"));
      buttonsList.add(
        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF193566),
              ),
              onPressed: () {
                ref.watch(rsaProvider.notifier).confirmTowArrival();
              },
              child: const Text("Confirm Arrival")),
        ),
      );
    }

    buttonsList.add(
      Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF193566),
            ),
            onPressed: () {
              confirmFinish(context, ref);
            },
            child: const Text("Finish Request")),
      ),
    );

    if (ref.watch(rsaProvider).mechanic != null) {
      towEndedText.add(MyTwoEndTextDivided(
          firstStr: "mechanic".tr(),
          secondStr: ref.watch(rsaProvider).mechanic!.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    setData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: salahlyAppBar(),
      extendBodyBehindAppBar: true,
      drawer: salahlyDrawer(context),
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage("assets/images/mechanic.png"), fit: BoxFit.cover)),
          // ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16.0, right: 16.0, bottom: 32),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.78,
                      color: const Color.fromRGBO(255, 255, 255, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(imgURL),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                    child: Text(title,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Center(
                                    child: Text(smallDescription,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              DefaultTextStyle(
                                  style: const TextStyle(
                                      color: Color(0xFF193566),
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 15),
                                  child: Column(
                                    children: [
                                      MyTwoEndTextDivided(
                                          firstStr: "subType".tr(),
                                          secondStr: subType),
                                      ...towEndedText,
                                    ],
                                  )),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: buttonsList,
                              ),
                            ],
                          ),
                        ),
                      ))),
            ),
          )
        ],
      ),
    );
  }
}

class MyTwoEndTextDivided extends StatelessWidget {
  final String? firstStr, secondStr;
  double customThickness;

  MyTwoEndTextDivided(
      {required this.firstStr,
      required this.secondStr,
      this.customThickness = 2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(firstStr!),
        ),
        Expanded(
            child: Divider(
          thickness: customThickness,
          color: Colors.grey,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(secondStr!),
        ),
      ],
    );
  }
}
