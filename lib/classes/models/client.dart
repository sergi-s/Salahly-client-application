import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';
import 'car.dart';

class Client extends UserType {
  SubscriptionTypes subscription = SubscriptionTypes.silver;
  List<Car> cars = [];

  Client({
    required String? name,
    required String? email,
    String? id,
    String? birthDay,
    String? createdDate,
    AccountState? userState,
    Gender? gender,
    Type? type,
    String? avatar,
    String? address,
    String? phoneNumber,
    CustomLocation? loc,
    List<Car>? cars,
    required this.subscription,
  }) : super(
            name: name,
            email: email,
            id: id,
            birthDay: birthDay,
            createdDate: createdDate,
            state: userState,
            gender: gender,
            type: type,
            avatar: avatar,
            loc: loc,
            phoneNumber: phoneNumber);

  @override
  set setPassword(String value) {
    super.setPassword = value;
  }

  final Map<SubscriptionTypes, double> _subscriptionData = {
    SubscriptionTypes.silver: 4,
    SubscriptionTypes.gold: 50,
    SubscriptionTypes.platinum: 200
  };

  double? getSubscriptionRange() {
    return _subscriptionData.containsKey(subscription)
        ? _subscriptionData[subscription]
        : 0;
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

enum SubscriptionTypes { silver, gold, platinum }
