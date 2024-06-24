import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/screens/edit_product_screen.dart';

class UnPublishProduct extends StatefulWidget {
  const UnPublishProduct({super.key});

  @override
  State<UnPublishProduct> createState() => _UnPublishProductState();
}

class _UnPublishProductState extends State<UnPublishProduct> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products").where("seller.sellerUid",isEqualTo: user!.uid)
            .where('published', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: Colors.green,
                animating: true,
              )
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey[200],
                ),
                columns: [
                  DataColumn(
                    label: Container(width: 200, child: Text("Product Name"),),
                  ),
                  DataColumn(
                    label: Text("Image"),
                  ),
                  DataColumn(
                    label: Text("Info"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: _productDetails(snapshot.data!),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      return DataRow(
        cells: [
          DataCell(
            Container(
                child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  SizedBox(width: 20,),
                  Text(
                    data["productName"],
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )),
          ),
          DataCell(
            Container(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  data["productImg"],
                ),
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(CupertinoIcons.info),
              onPressed: () {
                Get.to(() =>
                  EditProduct(
                    productId: data["productId"],
                  ),
                );
              },
            ),
          ),
          DataCell(
            popUpButton(data),
          )
        ],
      );
    }).toList();
    return newList;
  }

  Widget popUpButton(data) {
    return PopupMenuButton(
      onSelected: (String value) {
        if (value == 'publish') {
          FirebaseFirestore.instance
              .collection("products")
              .doc(data["productId"])
              .update({'published': true});
        }
        if (value == 'delete') {
          FirebaseFirestore.instance
              .collection("products")
              .doc(data["productId"])
              .delete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'publish',
          child: ListTile(
            leading: Icon(
              Icons.check,
            ),
            title: Text("Publish"),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              Icons.delete_outline,
            ),
            title: Text("Delete"),
          ),
        ),
      ],
    );
  }
}
