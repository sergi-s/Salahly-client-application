import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:slahly/abstract_classes/user.dart';
import "package:slahly/classes/models/client.dart";

import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/car.dart';

final StateNotifierProvider<ClientNotifier, Client> userProvider =
    StateNotifierProvider<ClientNotifier, Client>((ref) => ClientNotifier());

class ClientNotifier extends StateNotifier<Client> {
  ClientNotifier() : super(Client(type: Type.client));

  setName(String name) => state = state.copyWith(name: name);

  setEmail(String email) => state = state.copyWith(email: email);

  setSubscription(SubscriptionTypes subscripe) =>
      state = state.copyWith(subscription: subscripe);

  setLocation(CustomLocation loc) => state = state.copyWith(loc: loc);

  setBirthDay(DateTime birthDay) => state = state.copyWith(birthDay: birthDay);

  setPhoneNumber(String phone) => state = state.copyWith(phoneNumber: phone);

  setAddress(String address) =>
      state = state.copyWith(address: address); //34an 5atr hesham

  addCar(Car car) => state = state.copyWith(cars: [...state.cars, car]);

  removeCar(Car car) {
    state = state.copyWith(cars: [
      for (final carInf in state.cars)
        if (car != carInf) carInf
    ]);
  }

  addAvatar(String avatarInf) {
    state = state.copyWith(avatar: avatarInf);
  }
}
