import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:slahly/abstract_classes/user.dart';
import "package:slahly/classes/models/client.dart";

import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/car.dart';

final StateNotifierProvider<ClientNotifier, Client> userProvider =
    StateNotifierProvider<ClientNotifier, Client>((ref) => ClientNotifier());

class ClientNotifier extends StateNotifier<Client> {
  ClientNotifier() : super(Client(type: Type.client));

  assignName(String name) => state = state.copyWith(name: name);

  assignEmail(String email) => state = state.copyWith(email: email);

  assignSubscription(SubscriptionTypes subscription) =>
      state = state.copyWith(subscription: subscription);

  assignLocation(CustomLocation loc) => state = state.copyWith(loc: loc);

  assignBirthDay(DateTime birthDay) =>
      state = state.copyWith(birthDay: birthDay);

  assignPhoneNumber(String phone) => state = state.copyWith(phoneNumber: phone);

  assignAddress(String address) => state = state.copyWith(address: address);

  assignCar(Car car) {
    bool flag = true;
    for (int i = 0; i < state.cars.length; i++) {
      if (state.cars[i].noPlate == car.noPlate) {
        flag = false;
      }
    }
    if (flag) {
      state = state.copyWith(cars: [...state.cars, car]);
    }
  }

  removeCar(Car car) {
    // state = state.copyWith(cars: [
    //   for (final carInf in state.cars)
    //     if (car != carInf) carInf
    // ]);
    state.cars.remove(car);
    state = state.copyWith(cars: state.cars);
  }

  assignAvatar(String avatarInf) {
    state = state.copyWith(avatar: avatarInf);
  }
}
