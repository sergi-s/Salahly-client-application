import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/client.dart';
import "package:slahly/classes/provider/user_data.dart";
import 'package:slahly/classes/models/car.dart';

//TODO remove this page later
//It is just for testing purposes
class TestUserSM extends ConsumerWidget {
  static const String routeName = "/testuserscreen";

  final TextEditingController CarNameController = TextEditingController();
  final TextEditingController CarmodelContorller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Client user = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: CarNameController,
              decoration: const InputDecoration(hintText: 'no plate'),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: CarmodelContorller,
              decoration: const InputDecoration(hintText: 'Carmodel'),
            ),
            ElevatedButton(
                onPressed: () {
                  userNotifier.addCar(Car(
                      noPlate: CarNameController.text,
                      model: CarmodelContorller.text));
                },
                child: const Text("add car")),
            ElevatedButton(
                onPressed: () {
                  userNotifier.removeCar(user.cars[0]);
                },
                child: const Text("removeeee")),
            const SizedBox(height: 50),
            Text(user.cars.toString()),
            ///////////////////////////////////////////////////////////////////
            Text(user.name ?? "NON"), //ME
            Text(user.phoneNumber ?? "NON"), //HESHAM

            ElevatedButton(
                onPressed: () => {userNotifier.setName("Sergi")},
                child: const Text("Change name to sergi")),

            ElevatedButton(
                onPressed: () => {userNotifier.setPhoneNumber("Hesham")},
                child: const Text("Change phoneNumber to Hesham")),
          ],
        ),
      ),
    );
  }
}
