import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_vendor_side/widget/customSnakbar.dart';

class auth_provider extends ChangeNotifier {
  File? image;
  bool ifPicAvail = false;
  String pickerError = "";
  String error = "";

  //Shop Data
  double shoplatitude = 0.0;
  double shoplongitude = 0.0;
  bool permissionAllowed = false;
  String placeName = "";
  String shopAddress = "";
  String email = "";

  //To take image from vendor
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = "No Image selected";
      log("No Image Selected");
      notifyListeners();
    }
    return this.image!;
  }

  //To get current location
  Future getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LocationPermission permission = await Geolocator.checkPermission();
    if (position != null ||
        permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      this.shoplatitude = position.latitude;
      this.shoplongitude = position.longitude;
      this.permissionAllowed = true;

      final coordinates =
          new Coordinates(this.shoplatitude, this.shoplongitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var shopAddress = addresses.first;
      this.shopAddress = shopAddress.addressLine.toString();
      this.placeName = shopAddress.featureName.toString();
      notifyListeners();
      return shopAddress;
    } else {
      customWidget.customSnackbar(
        suberrorTitle: "Permission is not allowed",
        errorTitle: "Allow",
        icon: Icons.location_on_outlined,
        iconColor: Colors.white,
        errorTitleColor: Colors.white,
        backgroundColor: Colors.green,
      );
    }
  }

  //Registration
  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (ex) {
      if (ex.code == 'weak-password') {
        this.error = "error Password is too weak";
        notifyListeners();
        log("=======>register error Password is too weak");
      }
      if (ex.code == 'email-already-in-use') {
        this.error = "User already in use.";
        notifyListeners();
        log("=======>register error User already in use.");
      }
    }
    return userCredential!;
  }

  //Login
  Future<UserCredential>LoginVendor(String email,String password,context) async {
    UserCredential? credential;
    try {
       credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      log("${credential.toString()}");
    } on FirebaseException catch (ex) {
      this.error = ex.code.toString();
      notifyListeners();
        CustomAlertDialog(context: context, title: "Alert!!", message: "${ex.code}", btnText: "Ok");
      log("+++++++++++++>>>>>>>>>>>>Login error ${ex.code}");
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      CustomAlertDialog(context: context, title: "Alert!!", message: "${e.toString()}", btnText: "Ok");
      log("+++++++++++++>>>>>>>>>>>>Login error ${e.toString()}");
    }
    return credential!;
  }

  //Reset Password
  Future<void> resetPassword(email) async {
    this.email = email;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (ex) {
      this.error = ex.toString();
      notifyListeners();
      log("+++++++++++++>>>>>>>>>>>>Reset password error ${ex.code}");
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      log("+++++++++++++>>>>>>>>>>>>Reset Password error ${e.toString()}");
    }
  }

  //Upload Shop Image
  Future<String> uploadShopImage(ShopImg, String ShopName) async {
    //File file = File(ShopImg);
    //Storage
    TaskSnapshot uploadTask = await FirebaseStorage.instance.ref("ShopPic/${ShopName}").putFile(ShopImg);
    log("++++++++++++++++>>>>> Image $ShopImg");
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    //log("++++++++++++++++>>>>> Image After $url");
    log("===========-----> Shop Photo Upload");
    return url;
  }

  //Upload Shop All Data
  Future<void> UploadShopData(
      {String? ShopImg,
      ShopName,
      ShopMobileNumber,
      ShopDialog,
      ShopAddress}) async {
    User? user = FirebaseAuth.instance.currentUser;
    //DataBase
    FirebaseFirestore.instance.collection("vendors").doc(user!.uid).set({
      "accVerified": true,
      "shopId": user.uid,
      "shopImage": ShopImg,
      "shopName": ShopName,
      "shopMobileNo": ShopMobileNumber,
      "shopEmail": this.email,
      "shopDialog": ShopDialog,
      "shopAddress": ShopAddress,
      "shopLocation": GeoPoint(this.shoplatitude, this.shoplongitude),
      "shopOpen": true,
      "shopRating": 0.00,
      "shopTotalRating": 0,
      "isTopPiked": true,
    }).then(
      (value) {
        log("==========>>>>>>>>>>>>>Vendors data Gone");
      },
    );
    return null;
  }
}
