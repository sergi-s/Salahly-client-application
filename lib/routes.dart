import 'package:go_router/go_router.dart';
import 'package:slahly/screens/loginscreen.dart';
import 'package:slahly/screens/signupscreen.dart';
import 'package:slahly/screens/splashscreen.dart';
import 'package:slahly/widgets/getLocationComponent.dart';

class Routing {
  get router => GoRouter(

    initialLocation: SignUpScreen.routeName,

    routes: <GoRoute> [
      GoRoute(
        path: SignUpScreen.routeName,
        builder: (context, state) => splashscreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: LocationComponent.routeName,
        builder: (context, state) => LocationComponent(),
      ),
    ],
  );
}
