import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor_side/services/firebase_service.dart';
import 'package:grocery_vendor_side/services/order_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;

  const OrderSummaryCard({super.key, required this.document});

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  OrderService _orderService = OrderService();
  FirebaseService _service = FirebaseService();
  DocumentSnapshot? _customer;

  @override
  void initState() {
    _service.getUserDetails(widget.document["userId"]).then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //Order Details
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: _orderService.statusIcon(widget.document),
            ),
            title: Text(
              widget.document["orderStatus"],
              style: TextStyle(
                  fontSize: 12,
                  color: _orderService.statusColor(widget.document),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "On ${DateFormat.yMMMd().format(
                DateTime.parse(widget.document["timestamp"]),
              )}",
              style: TextStyle(fontSize: 12),
            ),
            trailing: Text(
              "Amount : \₹${widget.document["total"].toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Customer Details
          _customer != null
              ? ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Customer : ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${_customer?["firstName"]}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "${_customer?["address"]}",
                    maxLines: 2,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      setState(() {
                        launchUrl(Uri.parse('tel:${_customer?["number"]}'));
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8,top: 2,bottom: 2),
                        child: Icon(
                          Icons.phone_in_talk,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          //Product Details
          ExpansionTile(
            iconColor: _orderService.statusColor(widget.document),
            collapsedIconColor: Colors.black,
            expansionAnimationStyle: AnimationStyle(
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 590),
            ),
            title: Text(
              "Order Details",
              style: TextStyle(fontSize: 10),
            ),
            subtitle: Text(
              "View order Details",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            children: [
              ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.network(
                          widget.document["products"][index]["productImage"]),
                    ),
                    title: Text(
                      widget.document["products"][index]["productName"],
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      "${widget.document["products"][index]["qty"]} X \₹${widget.document["products"][index]["price"].toStringAsFixed(0)} = \₹${widget.document["products"][index]["total"].toStringAsFixed(0)}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Amount : \₹${widget.document["total"].toStringAsFixed(0)} ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "Payment Type : \₹${widget.document["cod"] == true ? "COD" : " Pay Online"} ",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: widget.document["products"].length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                  top: 8,
                ),
                child: Card(
                  elevation: 8,
                  color: _orderService.statusColor(widget.document),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Seller : ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              widget.document["seller"]["shopName"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Delivery Fee : ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "\₹${widget.document["deliveryFee"].toString()}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        int.parse(widget.document["discount"]) > 0
                            ? Row(
                                children: [
                                  Text(
                                    "Discount : ",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    widget.document["discount"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        
          _orderService.statusContainer(widget.document, context),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
