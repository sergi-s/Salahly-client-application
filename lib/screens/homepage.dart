import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/screens/chatbot/chatbotscreen.dart';
import 'package:slahly/screens/dropOff_screens/dropOff_location_screen.dart';
import 'package:slahly/screens/roadsideassistance/roadside_assistance_map.dart';
import 'package:slahly/screens/workshop_assistance/workshop_assistance_screen.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/firebase/get_all_cars.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';
import 'package:slahly/utils/firebase/get_provider_data.dart';
import 'package:slahly/utils/firebase/get_user_data.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/global_widgets/app_drawer.dart';
import 'package:slahly/widgets/homepage/AppCard.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      getUserData(ref);
      allCars(ref);
      reviveFromCloud();
      revive();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: salahlyAppBar(),
      drawer: salahlyDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "welcome".tr(),
                textScaleFactor: 1.4,
                style: const TextStyle(
                    fontSize: 23,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff193566)),
              ).tr(),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              CardWidget(
                  fun: () {
                    context.push(RoadSideAssistanceScreen.routeName);
                  },
                  title: 'rsa'.tr(),
                  subtitle: 'rsaDescription'.tr(),
                  image: 'assets/images/emergency-call.png'),
              CardWidget(
                  fun: () {
                    context.push(WSAScreen.routeName);
                  },
                  title: 'wsa'.tr(),
                  subtitle: 'wsaDescription'.tr(),
                  image: 'assets/images/mechanic.png'),
              CardWidget(
                  fun: () {
                    context.push(DropOffLocationScreen.routeName);
                  },
                  title: 'tta'.tr(),
                  subtitle: 'ttaDescription'.tr(),
                  image: 'assets/images/Tow.png'),
              // ElevatedButton(
              //     onPressed: () {
              //       print(ref.watch(userProvider).cars);
              //       // print(ref.watch(userProvider).cars);
              //       reviveFromCloud();
              //       revive();
              //     },
              //     child: Text("tesst"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          context.push(ChatBotScreen.routeName);
        },
        backgroundColor: Colors.indigo,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/chatbot.png'),
          backgroundColor: Color(0xff193566),
          radius: 25,
        ),
        // Image.asset('assets/images/chatbot.png'),
      ),
    );
  }

  void revive() async {
    ////////////////////////
    ref.watch(salahlyClientProvider.notifier).getSavedData();
    final prefs = await SharedPreferences.getInstance();

    if (ref.watch(salahlyClientProvider).requestType == RequestType.WSA ||
        ref.watch(salahlyClientProvider).requestType == RequestType.RSA ||
        ref.watch(salahlyClientProvider).requestType == RequestType.TTA) {
      ref
          .watch(rsaProvider.notifier)
          .assignRequestType(ref.watch(salahlyClientProvider).requestType!);

      ref.watch(rsaProvider.notifier).assignRequestID(
          ref.watch(salahlyClientProvider).requestID.toString());

      if (prefs.getString("mechanic") != null) {
        ref.watch(rsaProvider.notifier).assignMechanic(
            await getMechanicData(prefs.getString("mechanic")!), false);
      }
      if (prefs.getString("towProvider") != null) {
        ref.watch(rsaProvider.notifier).assignProvider(
            await getProviderData(prefs.getString("towProvider")!), false);
      }
    }
    ////////////////////////
  }

  Future reviveFromCloud() async {
    getActiveRequest(rsaRef);
    getActiveRequest(ttaRef);
    getActiveRequest(wsaRef);
  }

  getActiveRequest(DatabaseReference local) async {
    String? rsaID, mechanicID, towProviderID;
    RequestType? requestType;
    DatabaseEvent dbEvent = await local
        .orderByChild("userID")
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once();
    DataSnapshot dataSnapshot = dbEvent.snapshot;

    for (var element in dataSnapshot.children) {
      RSAStates tempState =
          RSA.stringToState(element.child("state").value.toString());
      print(
          "${element.child("state").value.toString()} vs $tempState vs ${RSAStates.cancelled}");
      requestType = local == rsaRef
          ? RequestType.RSA
          : local == wsaRef
              ? RequestType.WSA
              : RequestType.TTA;
      print("from cloud${tempState}, ");
      if (tempState != RSAStates.done && tempState != RSAStates.cancelled) {
        rsaID = element.key;
        print("id: $rsaID state $tempState ");
        for (var response in element.child("mechanicsResponses").children) {
          if ((response.value == "accepted" &&
                  requestType == RequestType.RSA) ||
              (response.value == "chosen" && requestType != RequestType.RSA)) {
            mechanicID = response.key.toString();
          }
        }

        for (var response in element.child("providersResponses").children) {
          if ((response.value == "accepted" &&
                  requestType == RequestType.RSA) ||
              (response.value == "chosen" && requestType != RequestType.RSA)) {
            towProviderID = response.key.toString();
          }
        }
      }
    }
    if (rsaID != null && requestType != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("requestID", rsaID);
      prefs.setString("requestType", RSA.requestTypeToString(requestType));
      prefs.setString("appState",
          SalahlyClient.appStateToString(AppState.requestingAssistance));

      if (mechanicID != null) {
        prefs.setString("mechanic", mechanicID);
      }
      if (towProviderID != null) {
        prefs.setString("towProvider", towProviderID);
      }
    }
  }
}