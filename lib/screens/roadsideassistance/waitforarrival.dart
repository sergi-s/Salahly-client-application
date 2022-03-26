import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/location/getuserlocation.dart';

Client user = Client(
    name: "aya",
    email: "aya.emai",
    subscription: SubscriptionTypes.silver,
    loc: CustomLocation(latitude: 55, longitude: 55));

class SearchingMechanicProvider extends ConsumerStatefulWidget {
  static const String routeName = "/searchingmechanicprovider";

  SearchingMechanicProvider({required this.userLocation});

  final CustomLocation userLocation;

  @override
  _SearchingMechanicProvider createState() => _SearchingMechanicProvider();
}

class _SearchingMechanicProvider extends ConsumerState<SearchingMechanicProvider> {
  Mechanic choosenMech = Mechanic(
    name: "Mohamed",
    email: "mohamed@gmail.com",
    nationalID: "123",
    phoneNumber: "012",
    isCenter: true,
    type: Type.mechanic,
    loc: CustomLocation(latitude: 50, longitude: 50),
  );

  TowProvider choosenTowProvider = TowProvider(
    name: "Sergi",
    email: "sergi@email.net",
    nationalID: "123",
    phoneNumber: "012",
    type: Type.provider,
    isCenter: false,
    loc: CustomLocation(latitude: 50, longitude: 50),
  );

  late RSA rsa;
  late Mechanic? mechanic;
  late TowProvider? provider;

  @override
  void initState() {

    // rsa = ref.watch(rsaProvider);
    // print(widget.userLocation.toString());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ref.watch(rsaProvider.notifier).assignUserLocation(widget.userLocation);
    int mechState = 2;
    int provState = 2;
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Be patient...!",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            MechanicApprovalTile(serviceProvider: choosenMech, temp: mechState),
            MechanicApprovalTile(
                serviceProvider: choosenTowProvider, temp: provState),
          ],
        ),
      ),
    );
  }
}

class MechanicApprovalTile extends StatelessWidget {
  UserType serviceProvider;
  int temp;

  MechanicApprovalTile(
      {Key? key, required this.serviceProvider, required this.temp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = serviceProvider.name ?? "Name";
    String type = serviceProvider.getUserType().toString();

    List<String> approvalStateTxt = ["Waiting", "Accept", "Canceled"];
    List<Color> approvalStateColor = [Colors.grey, Colors.green, Colors.red];

    String dis = (calculateDistance(user.loc?.longitude, user.loc?.latitude,
            serviceProvider.loc?.longitude, serviceProvider.loc?.latitude))
        .toStringAsFixed(2);

    if (temp == 3) {
      //should be 2 not 3
      return AlertDialog(
        title: Text('$name has canceled'),
        content: Text(
            'Please Select onther ${serviceProvider.getUserType().toString()}'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print("go to the choose screen");
            },
            child: const Text('OK'),
          ),
        ],
      );
    }

    return Container(
      height: 150,
      child: Card(
        shadowColor: approvalStateColor[temp],
        elevation: 6,
        child: ListTile(
          title: Text("$type \nName: $name"),
          isThreeLine: true,
          subtitle: Text('Disdance: $dis\n${serviceProvider.email}'),
          leading: const CircleAvatar(radius: 45),
          trailing: CircleAvatar(
            radius: 35,
            backgroundColor: approvalStateColor[temp],
            child: Center(
              child: Text(
                approvalStateTxt[temp],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
