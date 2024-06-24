import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({super.key});

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference vendorBanner =
        FirebaseFirestore.instance.collection('vendorBanner');
    return StreamBuilder<QuerySnapshot>(
      stream: vendorBanner.where("sellerUid", isEqualTo: user!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Stack(
                  children: [
                    Container(
                      height: 180,
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            document['imageUrl'],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width / 12,
                      top: MediaQuery.of(context).size.height / 45,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: InkWell(
                            onTap: () {
                              EasyLoading.show(status: "Deleting...");
                              vendorBanner.doc(document.id).delete();
                              EasyLoading.dismiss();
                            },
                            child: Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
