import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/screens/DropOff_screens/dropOff_search_screen.dart';

import 'package:slahly/screens/allScreens.dart';
import 'package:slahly/screens/dropOff_screens/dropOff_location_screen.dart';
import 'package:slahly/screens/history/addcustomhistroy.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/firebaseemulatortestscreen/firebaseemulatortestscreen.dart';
import 'package:slahly/screens/homescreen.dart';
import 'package:slahly/screens/login_signup/TryScreen.dart';
import 'package:slahly/screens/login_signup/check_login.dart';
import 'package:slahly/screens/login_signup/registration.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';
import 'package:slahly/screens/roadsideassistance/waitforarrival.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/test_user_SM.dart';
import 'package:slahly/screens/userMangament/addSubowner.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';
import 'package:slahly/screens/testscreen.dart';
import 'package:slahly/screens/Describeproblem.dart';
import 'package:slahly/screens/viewcars.dart';
import 'package:slahly/screens/addcarbutton.dart';
import 'package:slahly/screens/waitforapproval/wait_for_approval_screen.dart';
import 'package:slahly/screens/waitforarrvial.dart';
import 'package:slahly/screens/history/viewhistory.dart';

class Routing {
  get router => GoRouter(
        initialLocation: ViewHistory.routeName,
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
            path: ManageSubowner.routeName,
            builder: (context, state) => ManageSubowner(),
          ),
          GoRoute(
            path: TransferOwner.routeName,
            builder: (context, state) => TransferOwner(),
          ),
          GoRoute(
            path: AddSubowner.routeName,
            builder: (context, state) => AddSubowner(),
          ),
          GoRoute(
            path: MyLocationScreen.routeName,
            builder: (context, state) => MyLocationScreen(),
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
            path: HomePage.routeName,
            builder: (context, state) => HomePage(),
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
            path: SearchingMechanicProvider.routeName,
            builder: (context, state) => SearchingMechanicProvider(
                userLocation: CustomLocation(latitude: 1, longitude: 2)),
            // builder: (context, state) => SearchingMechanicProvider(userLocation: state.extra! as CustomLocation),
          ),
          GoRoute(
            //TESTING
            path: FirebaseEmulatorScreen.routeName,
            builder: (context, state) => FirebaseEmulatorScreen(),
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
                return Registration(emailobj: state.extra! as String);
              }),
          GoRoute(
            path: ViewCars.routeName,
            builder: (context, state) => ViewCars(),
          ),
          GoRoute(
            path: AddCars.routeName,
            builder: (context, state) => AddCars(),
          ),
          GoRoute(
            path: WaitForApprovalScreen.routeName,
            builder: (context, state) => WaitForApprovalScreen(),
          ),
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
            path: ViewHistory.routeName,
            builder: (context, state) => ViewHistory(),
          ),
          GoRoute(
            path: CustomHistory.routeName,
            builder: (context, state) => CustomHistory(),
          ),
        ],
      );
}
