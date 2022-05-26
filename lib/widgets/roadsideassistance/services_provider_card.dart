import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';

Widget mapMechanicToFullWidget(Mechanic mec) {
  return ServicesProviderWiget(
    serviceProviderEmail: mec.email,
    serviceProviderName: mec.name,
    serviceProviderIsCenter: mec.isCenter,
    serviceProviderType: mec.getUserType(),
    serviceProviderPhoneNumber: mec.phoneNumber,
    serviceProviderRating: mec.rating,
    serviceProviderAddress: mec.address,
  );
}

Widget mapTowProviderToFullWidget(TowProvider prov) {
  return ServicesProviderWiget(
    serviceProviderEmail: prov.email,
    serviceProviderName: prov.name,
    serviceProviderIsCenter: prov.isCenter,
    serviceProviderType: prov.getUserType(),
    serviceProviderPhoneNumber: prov.phoneNumber,
    serviceProviderRating: prov.rating,
    serviceProviderAddress: prov.address,
  );
}

class ServicesProviderWiget extends StatelessWidget {
  late String foundType;

  ServicesProviderWiget({
    Key? key,
    this.serviceProviderType,
    this.serviceProviderName,
    this.serviceProviderEmail,
    this.serviceProviderIsCenter,
    this.serviceProviderPhoneNumber,
    this.serviceProviderRating,
    this.serviceProviderAddress,
    this.avatar,
  }) : super(key: key) {
    foundType = serviceProviderType == "Mechanic"
        ? "found_Mechanic"
        : "found_tow_provider";
  }

  String? serviceProviderType,
      serviceProviderName,
      serviceProviderEmail,
      serviceProviderPhoneNumber,
      serviceProviderAddress,
      avatar;
  bool? serviceProviderIsCenter;
  double? serviceProviderRating;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 20, color: Color(0xFF193566)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            CircleAvatar(
              backgroundImage: Image.network(avatar ??
                      "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY3MDUxMjkzMjI1OTIwMTcz/brad-pitt-attends-the-premiere-of-20th-century-foxs--square.jpg")
                  .image,
              radius: 35,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 60.0, right: 60, bottom: 50, top: 50),
              child: Table(
                columnWidths: const {0: FractionColumnWidth(0.3)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Text(
                      "${"Name".tr()}:",
                      textAlign: TextAlign.justify,
                    )),
                    TableCell(
                        child: Text(
                      serviceProviderName ?? "name",
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text(
                      "${"Phone".tr()}:",
                      textAlign: TextAlign.justify,
                    )),
                    TableCell(
                        child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: serviceProviderPhoneNumber));
                      },
                      label: Text(
                        serviceProviderPhoneNumber ?? "01..",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF193566),
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffff193566).withOpacity(0),
                        elevation: 0,
                        animationDuration: Duration.zero,
                      ),
                      icon: const Icon(
                        Icons.copy,
                        color: Color(0xFF193566),
                      ),
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text(
                      "${"Rating".tr()}:",
                    )),
                    TableCell(
                        child: Text(
                      serviceProviderRating.toString(),
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Text(
                        "${"Address".tr()}:",
                      ),
                    ),
                    TableCell(
                      child: Text(
                        serviceProviderAddress ?? "address",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]),
                ],
              ),
            ),
            // SizedBox(height: 15),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "${"Name".tr()}:",
            //       textAlign: TextAlign.justify,
            //       style: const TextStyle(fontSize: 25),
            //     ),
            //     const SizedBox(width: 15),
            //     Text(
            //       serviceProviderName ?? "name",
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(fontSize: 20),
            //     )
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "${"Phone".tr()}:",
            //       textAlign: TextAlign.justify,
            //       style: const TextStyle(fontSize: 25),
            //     ),
            //     // const SizedBox(width: ),
            //     Container(
            //       child: ElevatedButton.icon(
            //         onPressed: () {
            //           Clipboard.setData(
            //               ClipboardData(text: serviceProviderPhoneNumber));
            //         },
            //         label: Text(
            //           serviceProviderPhoneNumber ?? "01..",
            //           style: const TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 14),
            //         ),
            //         style: ElevatedButton.styleFrom(
            //           primary: const Color(0xFFff193566).withOpacity(0),
            //           elevation: 0,
            //           animationDuration: Duration.zero,
            //         ),
            //         icon: const Icon(
            //           Icons.copy,
            //           color: Colors.black,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // //end phone number
            // //rating
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "${"Rating".tr()}:",
            //       textAlign: TextAlign.justify,
            //       style: const TextStyle(fontSize: 25),
            //     ),
            //     const SizedBox(width: 15),
            //     Text(
            //       serviceProviderRating.toString(),
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(fontSize: 20),
            //     )
            //   ],
            // ),
            // //end rating
            //
            // //address
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "${"Address".tr()}:",
            //       textAlign: TextAlign.justify,
            //       style: const TextStyle(fontSize: 25),
            //     ),
            //     const SizedBox(width: 15),
            //     Text(
            //       serviceProviderAddress ?? "address",
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(fontSize: 20),
            //     )
            //   ],
            // ),
            //end address
          ]),
    );
  }
}

class ServicesProviderCard extends StatelessWidget {
  late String foundType;

  ServicesProviderCard(
      {Key? key,
      this.serviceProviderType,
      this.serviceProviderName,
      this.serviceProviderEmail,
      this.serviceProviderIsCenter,
      this.serviceProviderPhoneNumber,
      this.serviceProviderRating,
      this.serviceProviderAddress,
      this.avatar})
      : super(key: key) {
    foundType = serviceProviderType == "Mechanic"
        ? "found_Mechanic"
        : "found_tow_provider";
  }

  String? serviceProviderType,
      serviceProviderName,
      serviceProviderEmail,
      serviceProviderPhoneNumber,
      serviceProviderAddress,
      avatar;
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
                  Icon((serviceProviderIsCenter ?? false) ? Icons.badge : null),
                  // SizedBox(width: MediaQuery.of(context).size.height * 0.1),
                  const Expanded(
                    child: Divider(
                      color: Colors.transparent,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              content: getContent(),
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
            backgroundImage: Image.network(avatar ??
                    "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY3MDUxMjkzMjI1OTIwMTcz/brad-pitt-attends-the-premiere-of-20th-century-foxs--square.jpg")
                .image,
            radius: 25,
          ),
          const SizedBox(height: 15),
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
          (serviceProviderRating != null || serviceProviderRating!.isNaN)
              ? Row(
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
                )
              : Container(),
          //end rating

          //address
          (serviceProviderAddress != null)
              ? Row(
                  children: [
                    Text(
                      "${"Address".tr()}:",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(width: 15),

                    Flexible(
                      flex: 5,
                      child: Text(
                        serviceProviderAddress!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )
              : Container(),
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

Widget mapMechanicToWidget(Mechanic mec) {
  return ServicesProviderCard(
    serviceProviderEmail: mec.email,
    serviceProviderName: mec.name,
    serviceProviderIsCenter: mec.isCenter,
    serviceProviderType: mec.getUserType(),
    serviceProviderPhoneNumber: mec.phoneNumber,
    serviceProviderRating: mec.rating,
    serviceProviderAddress: mec.address,
    avatar: mec.avatar,
  );
}

Widget mapTowProviderToWidget(TowProvider prov) {
  return ServicesProviderCard(
    serviceProviderEmail: prov.email,
    serviceProviderName: prov.name,
    serviceProviderIsCenter: prov.isCenter,
    serviceProviderType: prov.getUserType(),
    serviceProviderPhoneNumber: prov.phoneNumber,
    serviceProviderRating: prov.rating,
    serviceProviderAddress: prov.address,
    avatar: prov.avatar,
  );
}
