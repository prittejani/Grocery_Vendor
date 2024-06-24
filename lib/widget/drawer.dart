// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);
// //
// //   @override
// //   MyAppState createState() => MyAppState();
// // }
// //
// // class MyAppState extends State<MyApp> {
// //   final GlobalKey<SliderDrawerState> _sliderDrawerKey =
// //   GlobalKey<SliderDrawerState>();
// //   late String title;
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData(fontFamily: 'BalsamiqSans'),
// //       debugShowCheckedModeBanner: false,
// //       home: Scaffold(
// //         body: SliderDrawer(
// //             appBar: SliderAppBar(
// //                 appBarColor: Colors.white,
// //                 title: Text(title,
// //                     style: const TextStyle(
// //                         fontSize: 22, fontWeight: FontWeight.w700))),
// //             key: _sliderDrawerKey,
// //             sliderOpenSize: 179,
// //             slider: _SliderView(
// //               onItemClick: (title) {
// //                 _sliderDrawerKey.currentState!.closeSlider();
// //                 setState(() {
// //                   this.title = title;
// //                 });
// //               },
// //             ),
// //             child: _AuthorList()),
// //       ),
// //     );
// //   }
// // }
//
// class SliderView extends StatefulWidget {
//   final Function(String)? onItemClick;
//
//   const SliderView({Key? key, this.onItemClick}) : super(key: key);
//
//   @override
//   State<SliderView> createState() => _SliderViewState();
// }
//
// class _SliderViewState extends State<SliderView> {
//   User? user = FirebaseAuth.instance.currentUser;
//   var vendorData;
//

//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getVendorData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.only(top: 30),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: 30,
//           ),
//           CircleAvatar(
//             radius: 45,
//             backgroundColor: Colors.green,
//             child: CircleAvatar(
//               radius: 42,
//               backgroundImage: NetworkImage(vendorData != null
//                   ? vendorData["shopImage"]
//                   : 'https://nikhilvadoliya.github.io/assets/images/nikhil_1.webp'),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             vendorData != null ? vendorData["shopName"] : 'Shop Name',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           ...[
//             Menu(Icons.dashboard_outlined, 'Dashboard'),
//             Menu(Icons.shopping_bag_outlined, 'Product'),
//             Menu(Icons.wallet_giftcard, 'Coupons'),
//             Menu(Icons.list_alt_outlined, 'Orders'),
//             Menu(Icons.stacked_bar_chart_outlined, 'Reports'),
//             Menu(Icons.settings_applications_outlined, 'Setting'),
//             Menu(Icons.arrow_back_ios, 'LogOut')
//           ]
//               .map((menu) => SliderMenuItem(
//                   title: menu.title,
//                   iconData: menu.iconData,
//                   onTap: widget.onItemClick))
//               .toList(),
//         ],
//       ),
//     );
//   }
// }
//
// class SliderMenuItem extends StatelessWidget {
//   final String title;
//   final IconData iconData;
//   final Function(String)? onTap;
//
//   const SliderMenuItem(
//       {Key? key,
//       required this.title,
//       required this.iconData,
//       required this.onTap})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.black,
//         ),
//       ),
//       leading: Icon(iconData, color: Colors.green),
//       onTap: () {
//         onTap?.call(title);
//         log("${title}");
//       },
//     );
//   }
// }
//
// class Menu {
//   final IconData iconData;
//   final String title;
//
//   Menu(this.iconData, this.title);
// }
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/product_provider.dart';
import 'package:grocery_vendor_side/screens/banner_screen.dart';
import 'package:grocery_vendor_side/screens/login_screen.dart';
import 'package:grocery_vendor_side/screens/order_screen.dart';
import 'package:grocery_vendor_side/screens/product_screen.dart';
import 'package:provider/provider.dart';

class kDrawer extends StatefulWidget {
  const kDrawer({super.key});

  @override
  State<kDrawer> createState() => _kDrawerState();
}

class _kDrawerState extends State<kDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection("vendors")
        .doc(user?.uid)
        .get();
    log("${result.id}");
    log("${result.data().toString()}");
    setState(() {
      vendorData = result;
    });

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendorData();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    provider.getShopName(vendorData != null ? vendorData["shopName"] : '');
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.symmetric(),
            decoration: BoxDecoration(
              color: Colors.green,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              accountName: Text(
                vendorData != null ?
                "${vendorData["shopName"]}" : "Shop Name",
              ),
              accountEmail: Text( vendorData != null ? "${vendorData["shopEmail"]}" : "Shop Email"),
              currentAccountPictureSize: Size.square(60),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 165, 255, 137),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: vendorData != null
                        ? NetworkImage(vendorData["shopImage"])
                        : null,
                  ),
                ),//Text
              ), //circleAvatar
            ), //UserAccountDrawerHeader
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined,color: Colors.green,),
            title: const Text(' Product '),
            onTap: () {
              Get.toNamed(ProductScreen.id);
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.photo,color: Colors.green,),
            title: const Text(' Banner '),
            onTap: () {
              Get.to(() => BannerScreen());
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.wallet_giftcard),
          //   title: const Text(' Coupons '),
          //   onTap: () {
          //     Get.back();
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined,color: Colors.green,),
            title: const Text(' Orders '),
            onTap: () {
              Get.to(() => OrderScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout,color: Colors.green,),
            title: const Text('Logout'),
            onTap: () {
              Get.offAllNamed(LoginScreen.id);
              FirebaseAuth.instance.signOut();
              log("++++++++++++++++++++++++++++++++>>>>>>>>>>>>>>>>>>>>>>>>> LOGOUT");
              log("${vendorData.data().toString()}");
            },
          ),
        ],
      ),
    );
  }
}
