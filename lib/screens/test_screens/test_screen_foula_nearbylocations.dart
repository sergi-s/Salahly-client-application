import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/provider/rsadata.dart';

class TestScreenFoulaNearbyLocations extends ConsumerStatefulWidget {
  // const TestScreenFoulaNearbyLocations({Key? key}) : super(key: key);
  static final String routeName = '/test_screen_foula_nearbylocations';
  @override
  _TestScreenFoulaNearbyLocationsState createState() => _TestScreenFoulaNearbyLocationsState();
}

class _TestScreenFoulaNearbyLocationsState extends ConsumerState<TestScreenFoulaNearbyLocations> {
  RSANotifier? rsaNotifier;
  @override
  Widget build(BuildContext context) {
    // if(rsaNotifier == null) {
      rsaNotifier = ref.watch(rsaProvider.notifier);
    // }
    final nearbyMechanics = ref.watch(rsaProvider).nearbyMechanics??[];
    return Center(
      child: Column(
        children: [
          Text('The numebr of nearby mechanics is: '+nearbyMechanics.length.toString()),
          ElevatedButton(onPressed: (){
            if(rsaNotifier != null) {
                NearbyLocations.getNearbyMechanicsAndProvidersFoula(
                    31.206866, 29.918298, 400, rsaNotifier!);
              }else Text('rsaNotifier is null');
            }, child: Text('Start stream')),
          ElevatedButton(onPressed: (){
            NearbyLocations.stopListener();
            ref.watch(rsaProvider.notifier).assignNearbyMechanics([]);
          }, child: Text('Stop stream'))
        ],
      )
    );
  }
}
