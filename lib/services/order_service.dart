import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/widget/delivery_boy_list.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderService {
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({
      "orderStatus": status,
    });
    return result;
  }
  Color? statusColor(DocumentSnapshot document) {
    if (document['orderStatus'] == "Accepted") {
      return Color(0xffE4DEAE);
    }
    if (document['orderStatus'] == "Rejected") {
      return Colors.red;
    }
    if (document['orderStatus'] == "Pick Up") {
      return Color(0xff8eb15c);
    }
    if (document['orderStatus'] == "Delivered") {
      return Colors.green;
    }
    if (document['orderStatus'] == "On The Way") {
      return Color(0xff5cc593);
    }
    return Colors.greenAccent;
  }

  // Color? statusColor(DocumentSnapshot document) {
  //   if (document['orderStatus'] == "Accepted") {
  //     return Colors.lightBlue;
  //   }
  //   if (document['orderStatus'] == "Rejected") {
  //     return Colors.red;
  //   }
  //   if (document['orderStatus'] == "Pick Up") {
  //     return Colors.pink[900];
  //   }
  //   if (document['orderStatus'] == "Delivered") {
  //     return Colors.green;
  //   }
  //   if (document['orderStatus'] == "On The Way") {
  //     return Colors.purple[900];
  //   }
  //   return Colors.orange;
  // }

  Icon? statusIcon(DocumentSnapshot document) {
    if (document['orderStatus'] == "Accepted") {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == "Rejected") {
      return Icon(
        Icons.dangerous_outlined,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == "Pick Up") {
      return Icon(
        Icons.cases_sharp,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == "Delivered") {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == "On The Way") {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  showMyDialog(title, status, documentId, context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text("Are You Sure? 🤔"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    EasyLoading.show(status: "Updating Status");
                    updateOrderStatus(documentId, status).then((value) {
                      EasyLoading.showSuccess("Order ${status}");
                    });
                    Get.back();
                  },
                  child: Center(
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: CupertinoColors.activeGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget statusContainer(document, context) {
    if (document["deliveryBoy"]["name"].length > 1) {
      return document["deliveryBoy"]["image"] == null
          ? Container()
          : ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  document["deliveryBoy"]["image"],
                ),
              ),
              title: Text(document["deliveryBoy"]['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('tel:${document["deliveryBoy"]["phone"]}'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, top: 2, bottom: 2),
                        child: Icon(
                          Icons.phone_in_talk,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      GeoPoint _location = document["deliveryBoy"]["location"];
                      mapLauncher(_location, document["deliveryBoy"]['name']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, top: 2, bottom: 2),
                        child: Icon(
                          Icons.map,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }
    if (document["orderStatus"] == "Accepted") {
      return Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white))),
              backgroundColor: MaterialStatePropertyAll(
                Color(0xff133A1B),
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeliveryBoyList(
                      document: document,
                    );
                  });
            },
            child: Text(
              "Select Delivery Boy",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.blueGrey))),
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.green,
                  ),
                ),
                onPressed: () {
                  showMyDialog(
                      "Accept Order", "Accepted", document.id, context);
                },
                child: Text(
                  "Accept",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing: document["orderStatus"] == "Rejected" ? true : false,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        // side: BorderSide(
                        //     color: Colors.red),
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      document["orderStatus"] == "Rejected"
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                  onPressed: () {
                    showMyDialog(
                        "Reject Order", "Rejected", document.id, context);
                  },
                  child: Text(
                    "Reject",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mapLauncher(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(location.latitude, location.longitude),
      title: " ${name} is here ",
    );
  }
}
