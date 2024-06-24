import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor_side/provider/product_provider.dart';
import 'package:grocery_vendor_side/widget/Banner_%20Card.dart';
import 'package:grocery_vendor_side/widget/drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  TextEditingController _txtImagePath = TextEditingController();
  bool _see = false;
  File? _image;
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Manage Banners",
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
      drawer: kDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerCard(),

          SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Add new banner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: Text("No Image Selected"),
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: _see ? false : true,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _see = true;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.green,
                              ),
                              child: Text(
                                ' Add New Banner ',
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
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: _see,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                getImage().then((value) {
                                  if (_image != null) {
                                    setState(() {
                                      _txtImagePath.text = _image!.path;
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 25,
                                width: MediaQuery.of(context).size.width / 1.12,
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 40),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green,
                                ),
                                child: Text(
                                  ' Upload Image ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            AbsorbPointer(
                              absorbing: _image != null ? false : true,
                              child: InkWell(
                                onTap: () {
                                  EasyLoading.show(status: "Uploading...");
                                  uploadVendorBannerIMG(
                                          _image!.path, provider.shopName)
                                      .then((url) {
                                    if (url != null) {
                                      setState(() {
                                        _txtImagePath.clear();
                                        _image = null;
                                      });
                                      //Add Banner Database
                                      vendorBanner.add({
                                        'imageUrl': url,
                                        'sellerUid': user!.uid
                                      });
                                      EasyLoading.dismiss();
                                      log("Ok Done........................");
                                      provider.alertDialogBox(
                                        context: context,
                                        title: "Banner Upload",
                                        content:
                                            "Banner Upload Successfully.",
                                      );
                                    } else {
                                      EasyLoading.dismiss();
                                      provider.alertDialogBox(
                                        context: context,
                                        title: "Banner Upload",
                                        content: "Banner Upload Failed",
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.12,
                                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 40),
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _image != null
                                        ? Colors.green
                                        : Colors.black54,
                                  ),
                                  child: Text(
                                    ' Save ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _see = false;
                                    _image = null;
                                    _txtImagePath.clear();
                                  });
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  width: MediaQuery.of(context).size.width / 1.12,
                                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 40),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black54,
                                  ),
                                  child: Text(
                                    ' Cancel ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      log("No Image Selected");
    }
    return _image!;
  }

  Future<String> uploadVendorBannerIMG(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('vendorBanner/${shopName}/${timeStamp}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadUrl = await _storage
        .ref('vendorBanner/${shopName}/${timeStamp}')
        .getDownloadURL();
    return downloadUrl;
  }
}
