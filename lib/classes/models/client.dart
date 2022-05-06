import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';
import 'car.dart';

enum SubscriptionTypes { silver, gold, platinum }

class Client extends UserType {
  SubscriptionTypes _subscription = SubscriptionTypes.silver;
  List<Car> _cars = [];

  Client({
    String? name,
    String? email,
    String? id,
    DateTime? birthDay,
    DateTime? createdDate,
    AccountState? userState,
    Gender? gender,
    Type? type,
    String? avatar,
    CustomLocation? loc,
    String? phoneNumber,
    List<Car>? cars,
    SubscriptionTypes? subscription,
    String? address,
  }) : super(
            name: name,
            email: email,
            id: id,
            birthDay: birthDay,
            createdDate: createdDate,
            userState: userState,
            gender: gender,
            type: type,
            avatar: avatar,
            loc: loc,
            phoneNumber: phoneNumber,
            address: address) {
    _subscription = subscription ?? _subscription;
    _cars = cars ?? _cars;
  }

  Client copyWith({
    String? name,
    String? email,
    String? id,
    DateTime? birthDay,
    DateTime? createdDate,
    AccountState? userState,
    Gender? gender,
    Type? type,
    String? avatar,
    CustomLocation? loc,
    String? phoneNumber,
    List<Car>? cars,
    SubscriptionTypes? subscription,
    String? address,
  }) =>
      Client(
        name: name ?? this.name,
        email: email ?? this.email,
        id: id ?? this.id,
        birthDay: birthDay ?? this.birthDay,
        createdDate: createdDate ?? this.createdDate,
        userState: userState ?? this.userState,
        gender: gender ?? this.gender,
        type: type ?? this.type,
        avatar: avatar ?? this.avatar,
        loc: loc ?? this.loc,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        cars: cars ?? _cars,
        subscription: subscription ?? _subscription,
      );

  final Map<SubscriptionTypes, double> _subscriptionData = {
    SubscriptionTypes.silver: 4,
    SubscriptionTypes.gold: 50,
    SubscriptionTypes.platinum: 200
  };

  double? getSubscriptionRange() {
    return _subscriptionData.containsKey(_subscription)
        ? _subscriptionData[_subscription]
        : 0;
  }



  SubscriptionTypes get subscription => _subscription;

  static String subscriptionToString(SubscriptionTypes subscription) {
    return (subscription.toString()).isNotEmpty
        ? (subscription.toString()).substring(18)
        : "";
    // deletes "RSAStates." at the beginning
  }

  List<Car> get cars => _cars;

  Map<SubscriptionTypes, double> get subscriptionData => _subscriptionData;

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
