import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/services/firebase_service.dart';
import 'package:grocery_vendor_side/services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoyList extends StatefulWidget {
  final DocumentSnapshot document;

  const DeliveryBoyList({super.key, required this.document});

  @override
  State<DeliveryBoyList> createState() => _DeliveryBoyListState();
}

class _DeliveryBoyListState extends State<DeliveryBoyList> {
  FirebaseService _service = FirebaseService();
  OrderService _orderService = OrderService();
  GeoPoint? _shopLocation;


  @override
  void initState() {
    super.initState();
    _service.getStoreDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = value["shopLocation"];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.green,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                "Select Delivery boy",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.boys
                    .where("accVerified", isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                        color: CupertinoColors.activeGreen,
                        radius: 20,
                      )
                    );
                  }
                  return snapshot.data!.size > 0 ? ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      GeoPoint _location = data["boyLocation"];
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                              _shopLocation!.latitude,
                              _shopLocation!.longitude,
                              _location.latitude,
                              _location.longitude);
                      var distance = distanceInMeters /1000;
                      print(distance);
                      if (distance > 10) {
                        return Container();
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: "Assigning Boy....");
                              _service
                                  .selectBoy(
                                orderId: widget.document.id,
                                email: data["boyEmail"],
                                name: data["boyName"],
                                phone: data["boyMobileNo"],
                                location: data["boyLocation"],
                                image: data["boyImage"],
                              )
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    "Assigned Delivery Boy");
                                Get.back();
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                data["boyImage"],
                              ),
                            ),
                            title: Text(data['boyName']),
                            subtitle: Text(
                                "${distance.toStringAsFixed(0)} Km"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse('tel:${data["boyMobileNo"]}'),
                                    );
                                  },
                                  icon: Icon(
                                    CupertinoIcons.phone,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    GeoPoint _location = data["boyLocation"];
                                    String _name = data['boyName'];
                                    _orderService.mapLauncher(_location, _name);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.map,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }).toList(),
                  ):Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
