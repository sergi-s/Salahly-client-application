import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';
import 'package:slahly/classes/models/car.dart';

void confirmCustomHistory(context, ref,
    {String? systemName,
    String? partId,
    String? partName,
    String? description,
    Car? car,
    DateTime? dateTime,
    double? actualDistance,
    double? distance,
    double? partCost,
    double? maintenanceCost,
    double? otherCost}) {
  showDialog(
    context: context,
    builder: (context) {
      final _db = Localstore.instance;
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Report".tr(),
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 30,
                      letterSpacing: 2,
                      color: Color(0xFF193566),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        "Date:".tr(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF193566)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('MM/dd/yyyy').format(dateTime!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  (car?.model != null)
                      ? Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Car:".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              car!.model.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  (systemName == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "System Name:".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              systemName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (partId == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Part Id :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              partId,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (partName == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Part Name :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              partName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (actualDistance == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Actual Distance :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              actualDistance.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (distance == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Distance :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              distance.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (partCost == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Part Cost :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              partCost.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (maintenanceCost == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Maintance Cost :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              maintenanceCost.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (otherCost == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Other Cost :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              otherCost.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  (description == null)
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "Description :".tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF193566)),
                            ),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Expanded(
                              child: Text(
                                description,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 70, top: 20),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        color: Colors.blueGrey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        color: const Color(0xFF193566),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onPressed: () {
                          final id = _db.collection("customHistory").doc().id;
                          _db.collection('customHistory').doc(id).set({
                            'id': id,
                            'carNoPlate': car!.noPlate,
                            'dateTime': dateTime.toString(),
                            "systemName": systemName,
                            "partId": partId,
                            "partName": partName,
                            "description": description,
                            "actualDistance": actualDistance.toString(),
                            "distance": distance.toString(),
                            "partCost": partCost.toString(),
                            "maintenanceCost": maintenanceCost.toString(),
                            "otherCost": otherCost.toString(),
                          });
                          print(id);
                          print("elmafrod tkon addded");
                          Navigator.pop(context);
                          context.pop();
                        },
                        child: Text(
                          "Confirm".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
