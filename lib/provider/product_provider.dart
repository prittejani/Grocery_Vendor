import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider extends ChangeNotifier {
  String selectedCategory = '';
  String selectedSubCategory = '';
  String imgCategory = '';
  String ProductURL = '';
  File? image;
  String pickerError = "";
  String shopName = "";

  SelectedCategory({mainCategory, imgCategory}) {
    this.selectedCategory = mainCategory;
    this.imgCategory = imgCategory;
    notifyListeners();
  }

  SelectedSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(ShopName) {
    this.shopName = ShopName;
    //notifyListeners();
  }

  resetProvider() {
    this.selectedCategory = "";
    this.selectedSubCategory = "";
    this.imgCategory = '';
    this.ProductURL = '';
    this.image = null;
    //notifyListeners();
  }

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

  alertDialogBox({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "Okay",
                  style: TextStyle(color: CupertinoColors.activeGreen),
                ),
                onPressed: Get.back,
              ),
            ],
          );
        });
  }

  Future<String> uploadProduct(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadUrl = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.ProductURL = downloadUrl;
    return downloadUrl;
  }

  Future<void>? saveProductDataToDB(
      {productName,
      des,
      price,
      comparedPrice,
      collection,
      brand,
      sku,
      weight,
      tax,
      stockQty,
      lowStockQty,
      context}) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection("products");
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user!.uid},
        'productName': productName,
        'description': des,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'imgCategory': this.imgCategory,
        },
        'weight': weight,
        'tax': tax,
        'stockQty': stockQty,
        'lowStockQty': lowStockQty,
        'published': false,
        'productId': timeStamp.toString(),
        'productImg': this.ProductURL,
      });
      this.alertDialogBox(
          context: context,
          title: "SAVE DATA",
          content: "Product Details Save Successfully");
    } catch (e) {
      this.alertDialogBox(
          context: context, title: "SAVE DATA", content: "${e.toString()}");
    }
    return null;
  }

  Future<void>? updateProductDataToDB({
    productName,
    productId,
    des,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    weight,
    tax,
    stockQty,
    lowStockQty,
    context,
    image,
    category,
    subcategory,
    categoryImage,
  }) {
    CollectionReference _products =
        FirebaseFirestore.instance.collection("products");
    try {
      _products.doc(productId).update({
        'productName': productName,
        'description': des,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': category,
          'subCategory': subcategory,
          'imgCategory':
              this.imgCategory == null ? categoryImage : this.imgCategory,
        },
        'weight': weight,
        'tax': tax,
        'stockQty': stockQty,
        'lowStockQty': lowStockQty,
        'productImg': this.ProductURL == null ? image : this.ProductURL,
      });
      this.alertDialogBox(
          context: context,
          title: "SAVE DATA",
          content: "Product Details Save Successfully");
    } catch (e) {
      this.alertDialogBox(
          context: context, title: "SAVE DATA", content: "${e.toString()}");
    }
    return null;
  }
}
