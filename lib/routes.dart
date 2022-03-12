import 'package:go_router/go_router.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/myLocation/getLocationComponent.dart';

class Routing {
  get router => GoRouter(

    initialLocation: SplashScreen.routeName,

    routes: <GoRoute> [
      GoRoute(
        path: LoginSignupScreen.routeName,
        builder: (context, state) => LoginSignupScreen(),
      ),
      GoRoute(
        path: LocationScreen.routeName,
        builder: (context, state) => LocationScreen(),
      ),
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => SplashScreen(),
      ),
    ],
  );
}
