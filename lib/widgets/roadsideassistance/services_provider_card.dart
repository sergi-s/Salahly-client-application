import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServicesProviderCard extends StatelessWidget {
  late String foundType;

  ServicesProviderCard({
    Key? key,
    required this.serviceProviderType,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderIsCenter,
    required this.serviceProviderPhoneNumber,
  }) : super(key: key) {
    foundType = serviceProviderType == "Mechanic"
        ? "found_Mechanic"
        : "found_tow_provider";
  }

  final String serviceProviderType,
      serviceProviderName,
      serviceProviderEmail,
      serviceProviderPhoneNumber;
  bool serviceProviderIsCenter;

  void customDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Row(
                children: [
                  Text(serviceProviderType),
                  Icon(serviceProviderIsCenter ? Icons.badge : null)
                ],
              ),
              content: getContent(),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel".tr()))
                // IconButton(
                //     icon: const Icon(Icons.close),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     })
              ],
            ));
  }

  Widget getContent() {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: Image.network(
                    "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY3MDUxMjkzMjI1OTIwMTcz/brad-pitt-attends-the-premiere-of-20th-century-foxs--square.jpg")
                .image,
            radius: 25,
          ),
          Row(
            children: [
              Text(
                "${"Name".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "${"Email".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Row(
            children: [
              Text(
                "${"Phone".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderPhoneNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFd1d9e6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 70,
      child: Center(
        child: GestureDetector(
          onTap: () {
            customDialog(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/Checkmark.png',
              //   fit: BoxFit.contain,
              //   height: 33,
              // ),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
              const SizedBox(width: 15),
              Text(
                foundType.tr(),
                style: TextStyle(fontSize: 21),
              )
            ],
          ),
        ),
      ),
    );
  }
}
