import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';


final valueProvider = Provider<int>((ref) {
  return 364;
});

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

class TestScreen extends ConsumerWidget {
  const TestScreen({Key? key}) : super(key: key);
  static final routeName = "/testscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final value = ref.watch(valueProvider);
    final rsa = ref.read(rsaProvider.notifier);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //
      // },),
      // body: Center(child: Text("Value: $value")),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                rsa.assignMechanic(
                    Mechanic(
                      name: "Mechanic",
                      email: "Mecha@mech.m",
                      rating: 3.4,
                      isCenter: false,
                    ),
                    false);
                rsa.assignProvider(
                    TowProvider(
                      name: "Mechanic",
                      email: "Mecha@mech.m",
                      rating: 3.4,
                      isCenter: false,
                    ),
                    false);
                rsa.assignProblemDescription("description");
              },
              child: Text("Assign data")),
          ElevatedButton(
              onPressed: () {
                context.go(RSAConfirmationScreen.routeName);
              }, child: Text("go to confirmation screen ")),
        ],
      ),
    );
  }
}

class TestScreenWithoutConsumer extends StatelessWidget {
  const TestScreenWithoutConsumer({Key? key}) : super(key: key);
  static final routeName = "/testscreenwoconsumer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (_, ref, __) {
            final value = ref.watch(valueProvider);
            return Text("Value: $value");
          },
        ),
      ),
    );
  }
}
