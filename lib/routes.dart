import 'package:go_router/go_router.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/firebaseemulatortestscreen/firebaseemulatortestscreen.dart';
import 'package:slahly/screens/homescreen.dart';
import 'package:slahly/screens/login_signup/registration.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';
import 'package:slahly/screens/roadsideassistance/waitforarrival.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/screens/testscreen.dart';
import 'package:slahly/screens/Describeproblem.dart';
import 'package:slahly/screens/waitforapproval/wait_for_approval_screen.dart';
import 'package:slahly/screens/waitforarrvial.dart';

class Routing {
  get router => GoRouter(

    initialLocation: WaitForApprovalScreen.routeName,

    routes: <GoRoute> [
      GoRoute(
        path: LoginSignupScreen.routeName,
        builder: (context, state) => LoginSignupScreen(),
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
        path: WaitForArrival.routeName,
        builder: (context, state) => WaitForArrival(),
      ),
      GoRoute( //TESTING
        path: FirebaseEmulatorScreen.routeName,
        builder: (context, state) => FirebaseEmulatorScreen(),
      ),
      GoRoute( //TESTING
        path: TestScreen.routeName,
        builder: (context, state) => TestScreen(),
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
        path: Registration.routeName,
        builder: (context, state) => Registration(),
      ),
      GoRoute(
        path: WaitForApprovalScreen.routeName,
        builder: (context, state) => WaitForApprovalScreen(),
      ),
    ],
  );
}
