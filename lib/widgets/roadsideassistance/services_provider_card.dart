import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServicesProviderCard extends StatelessWidget {
  late String foundType;

  ServicesProviderCard({
    Key? key,
    this.serviceProviderType,
    this.serviceProviderName,
    this.serviceProviderEmail,
    this.serviceProviderIsCenter,
    this.serviceProviderPhoneNumber,
    this.serviceProviderRating,
    this.serviceProviderAddress,
  }) : super(key: key) {
    foundType = serviceProviderType == "Mechanic"
        ? "found_Mechanic"
        : "found_tow_provider";
  }

  String? serviceProviderType,
      serviceProviderName,
      serviceProviderEmail,
      serviceProviderPhoneNumber,
      serviceProviderAddress;
  bool? serviceProviderIsCenter;
  double? serviceProviderRating;

  void customDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Row(
                children: [
                  Text(serviceProviderType!),
                  Icon((serviceProviderIsCenter ?? false) ? Icons.badge : null)
                ],
              ),
              content: getContent(),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    })
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
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                "${"Name".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderName ?? "name",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          //email
          // Row(
          //   children: [
          //     Text(
          //       "${"Email".tr()}:",
          //       textAlign: TextAlign.justify,
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const SizedBox(width: 15),
          //     Text(
          //       serviceProviderEmail,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(fontSize: 15),
          //       overflow: TextOverflow.ellipsis,
          //     )
          //   ],
          // ),
          //end email
          // Row(
          //   children: [
          //     Text(
          //       "${"Phone".tr()}:",
          //       textAlign: TextAlign.justify,
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const SizedBox(width: 15),
          //     Text(
          //       serviceProviderPhoneNumber,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(fontSize: 15),
          //       overflow: TextOverflow.ellipsis,
          //     )
          //   ],
          // )
          //phone number
          Row(
            children: [
              Text(
                "${"Phone".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 25),
              ),
              // const SizedBox(width: ),
              Container(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: serviceProviderPhoneNumber));
                  },
                  label: Text(
                    serviceProviderPhoneNumber ?? "01..",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFff193566).withOpacity(0),
                    elevation: 0,
                    animationDuration: Duration.zero,
                  ),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          //end phone number

          //rating
          Row(
            children: [
              Text(
                "${"Rating".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderRating.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          //end rating

          //address
          Row(
            children: [
              Text(
                "${"Address".tr()}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(width: 15),
              Text(
                serviceProviderAddress ?? "address",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          //end address
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xD3D3D3D4),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD3D3D3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 50,
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
                style: const TextStyle(fontSize: 21),
              )
            ],
          ),
        ),
      ),
    );
  }
}
