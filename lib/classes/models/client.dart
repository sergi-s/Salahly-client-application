import 'package:flutter/cupertino.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';

class Client extends UserType {
  SubscriptionTypes subscription = SubscriptionTypes.silver;

  Client({
    required String? name,
    required String? email,
    String? id,
    String? birthDay,
    String? createdDate,
    AccountState? userState,
    Sex? sex,
    Type? type,
    String? avatar,
    String? address,
    String? phoneNumber,
    CustomLocation? loc,
     required this.subscription,
  }) : super(
            name: name,
            email: email,
            id: id,
            birthDay: birthDay,
            createdDate: createdDate,
            state: userState,
            sex: sex,
            type: type,
            avatar: avatar,
            loc: loc,
            phoneNumber: phoneNumber);

  @override
  set setPassword(String value) {
    super.setPassword = value;
  }

  Map<SubscriptionTypes,double> _subscriptionData = {
    SubscriptionTypes.silver: 4,
    SubscriptionTypes.gold: 50,
    SubscriptionTypes.platinum: 200
  };

  double? getSubscriptionRange(){
    return _subscriptionData.containsKey(subscription)?_subscriptionData[subscription]:0;
  }

  @override
  bool isValid() {
    return (super.isValid()
        // && subscriptionValidate(subscription)
    );
  }

  // Validation
  bool subscriptionValidate(int subscription) {
    return subscription > 0;
  }
}

enum SubscriptionTypes{
  silver,gold,platinum
}