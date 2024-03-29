import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/screens/Describeproblem.dart';
import 'package:slahly/screens/DropOff_screens/dropOff_search_screen.dart';
import 'package:slahly/screens/allScreens.dart';
import 'package:slahly/screens/car_management/addCars.dart';
import 'package:slahly/screens/car_management/view_cars_screen.dart';
import 'package:slahly/screens/chatbot/chatbotscreen.dart';
import 'package:slahly/screens/dropOff_screens/dropOff_location_screen.dart';
import 'package:slahly/screens/firebaseemulatortestscreen/firebaseemulatortestscreen.dart';
import 'package:slahly/screens/history_management/add_custom_history.dart';
import 'package:slahly/screens/history_management/ongoing_requests.dart';
import 'package:slahly/screens/history_management/view_history.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/homescreen.dart';
import 'package:slahly/screens/login_signup/TryScreen.dart';
import 'package:slahly/screens/login_signup/check_login.dart';
import 'package:slahly/screens/login_signup/registration.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/rating/rating.dart';
import 'package:slahly/screens/reminder/addReminderScreen.dart';
import 'package:slahly/screens/reminder/reminderScreen.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';
import 'package:slahly/screens/roadsideassistance/request_full_data_screen.dart';
import 'package:slahly/screens/roadsideassistance/roadside_assistance_map.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/test_screens/test_screen_foula_nearbylocations.dart';
import 'package:slahly/screens/test_screens/test_user_SM.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';
import 'package:slahly/screens/testscreenyoyo.dart';
import 'package:slahly/screens/userMangament/addSubowner.dart';
import 'package:slahly/screens/userMangament/view_cars_to_manage_subowners.dart';
import 'package:slahly/screens/userMangament/editProfile.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';
import 'package:slahly/screens/userMangament/pofile.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';
import 'package:slahly/screens/waitforarrvial.dart';
import 'package:slahly/screens/workshop_assistance/workshop_assistance_screen.dart';
import 'package:slahly/widgets/location/directionMap.dart';
import 'package:slahly/widgets/location/finalScreen.dart';

import 'classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'screens/roadsideassistance/arrival.dart';

class Routing {
  get router => GoRouter(

        // initialLocation: TestScreenFoulaNearbyLocations.routeName,
        // initialLocation: CheckLogin.routeName,
    initialLocation: SplashScreen.routeName,

        routes: <GoRoute>[
          GoRoute(
            //TESTING
            path: TestScreen_nearbymechanics_and_create_rsa.routeName,
            builder: (context, state) =>
                TestScreen_nearbymechanics_and_create_rsa(), //TestScreenRSASMTest(),
          ),
          GoRoute(
            path: CheckLogin.routeName,
            builder: (context, state) => const CheckLogin(),
          ),
          GoRoute(
            path: LoginSignupScreen.routeName,
            builder: (context, state) => LoginSignupScreen(),
          ),
          GoRoute(
            path: TransferOwner.routeName,
            builder: (context, state) => TransferOwner(),
          ),
          GoRoute(
            path: RoadSideAssistanceScreen.routeName,
            builder: (context, state) => RoadSideAssistanceScreen(),
          ),
          GoRoute(
            path: HomePage.routeName,
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: SearchingMechanicProviderScreen.routeName,
            builder: (context, state) => SearchingMechanicProviderScreen(
                userLocation: state.extra! as CustomLocation),
            // userLocation: CustomLocation(latitude: 1, longitude: 2)),
            // builder: (context, state) => SearchingMechanicProvider(userLocation: state.extra! as CustomLocation),
          ),
          GoRoute(
            //TESTING
            path: FirebaseEmulatorScreen.routeName,
            builder: (context, state) => FirebaseEmulatorScreen(),
          ),
          GoRoute(
            path: ManageSubowner.routeName,
            builder: (context, state) =>
                ManageSubowner(chasis: state.extra! as String),
          ),
          GoRoute(
            path: AddSubowner.routeName,
            builder: (context, state) =>
                AddSubowner(chasis: state.extra! as String),
          ),
          GoRoute(
            path: SplashScreen.routeName,
            builder: (context, state) => SplashScreen(),
          ),
          GoRoute(
            path: HomeScreen.routeName,
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: ChooseProviderScreen.routeName,
            builder: (context, state) => ChooseProviderScreen(),
          ),
          GoRoute(
            path: ChooseMechanicScreen.routeName,
            builder: (context, state) => ChooseMechanicScreen(),
          ),
          GoRoute(
            path: RSAConfirmationScreen.routeName,
            builder: (context, state) => RSAConfirmationScreen(),
          ),
          GoRoute(
            path: DescCarProblem.routeName,
            builder: (context, state) => DescCarProblem(),
          ),
          GoRoute(
            path: WaitArrvial.routeName,
            builder: (context, state) => WaitArrvial(),
          ),
          GoRoute(
            path: TryScreen.routeName,
            builder: (context, state) => TryScreen(),
          ),
          GoRoute(
              path: Registration.routeName,
              builder: (context, state) {
                return Registration(
                  emailobj: state.extra! as String,
                );
              }),
          GoRoute(
            path: ViewCars.routeName,
            builder: (context, state) => ViewCars(),
          ),
          // GoRoute(
          //   path: AddCars.routeName,
          //   builder: (context, state) => AddCars(),
          // ),
          GoRoute(
            path: SwitchLanguageScreen.routeName,
            builder: (context, state) => SwitchLanguageScreen(),
          ),
          GoRoute(
            path: AllScreens.routeName,
            builder: (context, state) => AllScreens(),
          ),
          GoRoute(
            path: DropOffLocationScreen.routeName,
            builder: (context, state) => DropOffLocationScreen(),
          ),
          GoRoute(
            path: DropOffSearchScreen.routeName,
            builder: (context, state) {
              return DropOffSearchScreen(
                  pikUpLocation: state.extra as CustomLocation);
            },
          ),
          GoRoute(
            path: TestUserSM.routeName,
            builder: (context, state) => TestUserSM(),
          ),
          GoRoute(
            path: AddCustomHistory.routeName,
            builder: (context, state) => AddCustomHistory(),
          ),
          GoRoute(
            path: ViewHistory.routeName,
            builder: (context, state) => ViewHistory(),
          ),
          GoRoute(
            path: Manage_Subowners.routeName,
            builder: (context, state) => Manage_Subowners(),
          ),
          GoRoute(
            path: Arrival.routeName,
            // builder: (context, state) => Select(state.extra as bool),
            builder: (context, state) => Arrival(type: state.extra as bool),
          ),
          GoRoute(
            path: WSAScreen.routeName,
            builder: (context, state) => WSAScreen(),
          ),
          GoRoute(
            path: TestUserCAR.routeName,
            builder: (context, state) => TestUserCAR(),
          ),
          GoRoute(
            path: EditProfile.routeName,
            builder: (context, state) => EditProfile(),
          ),
          GoRoute(
            path: Profile.routeName,
            builder: (context, state) => Profile(),
          ),
          GoRoute(
            path: ReminderScreen.routeName,
            builder: (context, state) => ReminderScreen(),
          ),
          GoRoute(
            path: AddReminder.routeName,
            builder: (context, state) => AddReminder(),
          ),
          GoRoute(
            path: DirectionMap.routeName,
            builder: (context, state) => DirectionMap(
                currentLocation: state.extra as CustomLocation,
                destinationLocation: state.extra as CustomLocation),
          ),
          GoRoute(
            path: RequestFinalScreen.routeName,
            builder: (context, state) => RequestFinalScreen(),
          ),
          GoRoute(
            path: AddCar.routeName,
            builder: (context, state) => AddCar(),
          ),
          GoRoute(
            path: OngoingRequests.routeName,
            builder: (context, state) => OngoingRequests(),
          ),
          GoRoute(
            path: RatingScreen.routeName,
            builder: (context, state) => RatingScreen(),
          ),
          GoRoute(
            path: ChatBotScreen.routeName,
            builder: (context, state) => ChatBotScreen(),
          ),
          GoRoute(
            path: RequestFullDataScreen.routeName,
            builder: (context, state) =>
                RequestFullDataScreen(rsa: state.extra as RSA),
          ),
          GoRoute(
            path: TestScreenAya.routeName,
            builder: (context, state) => TestScreenAya(),
          ),
          GoRoute(
            path: TestScreenFoulaNearbyLocations.routeName,
            builder: (context, state) => TestScreenFoulaNearbyLocations(),
          ),
        ],
      );
}
