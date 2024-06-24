import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor_side/provider/order_provider.dart';
import 'package:grocery_vendor_side/services/order_service.dart';
import 'package:grocery_vendor_side/widget/drawer.dart';
import 'package:grocery_vendor_side/widget/orderSummaryCard.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderService _orderService = OrderService();
  User? user = FirebaseAuth.instance.currentUser;
  int tag = 0;
  List<String> options = [
    'Ordered',
    'Accepted',
    'Rejected',
    'Pick Up',
    'On The Way',
    'Delivered',
    // 'All Orders'
  ];

  @override
  Widget build(BuildContext context) {
    var _order = Provider.of<OrderProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Manage Orders",
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
        ),
        drawer: kDrawer(),
        body: Column(
          children: [
            Container(
              color: Colors.green,
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "My Orders",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: C2ChipStyle.filled(
                  foregroundColor: Colors.white,
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  selectedStyle: C2ChipStyle.filled(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                ),
                value: tag,
                onChanged: ((val) {
                  // if (val == 0) {
                  //   setState(() {
                  //     _order.status = "";
                  //   });
                  // }
                  setState(() {
                    tag = val;
                    _order.filterOrder(options[val]);
                  });
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderService.orders
                    .where("seller.sellerId", isEqualTo: user!.uid)
                    .where("orderStatus", isEqualTo: _order.status)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.green,
                        radius: 20,
                        animating: true,
                      )
                    );
                  }
                  if (snapshot.data!.size == 0) {
                    return Expanded(
                      child: Center(
                        child: Text(tag > 0
                            ? "No ${options[tag]} orders"
                            : " No orders continue shopping.."),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        // Map<String, dynamic> data =
                        //     document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: new OrderSummaryCard(document: document),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
