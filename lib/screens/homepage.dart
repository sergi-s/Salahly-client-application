import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/screens/chatbot/chatbotscreen.dart';
import 'package:slahly/screens/dropOff_screens/dropOff_location_screen.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/screens/workshop_assistance/workshop_assistance_screen.dart';
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
    Future.delayed(Duration.zero, () {
      getUserData(ref);
      allCars(ref);
      revive();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // allCars(ref); //TODO refactor and uncomment
    //TODO: get all users data and put it in state management
    return Scaffold(
      appBar: salahlyAppBar(),
      drawer: salahlyDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "welcome".tr(),
            textScaleFactor: 1.4,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xff193566)),
          ).tr(),
          CardWidget(
              fun: () {
                context.push(MyLocationScreen.routeName);
              },
              title: 'Roadside assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor ',
              image: 'assets/images/tow-truck 2.png'),
          CardWidget(
              fun: () {
                context.push(WSAScreen.routeName);
              },
              title: 'Workshop assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png'),
          CardWidget(
              fun: () {
                context.push(DropOffLocationScreen.routeName);
              },
              title: 'Tow Truck assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          context.push(ChatBotScreen.routeName);
        },
        backgroundColor: const Color(0xff193566),
        child: Image.asset('assets/images/bot2.png'),
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
}
//TODO: el translate m4 byt3ml keda, fa edit it
// and complete translation
// TODO: add photo to TTA line:55
// Use state management to get user data
