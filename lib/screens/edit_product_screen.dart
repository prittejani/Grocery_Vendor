import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/product_provider.dart';
import 'package:grocery_vendor_side/widget/category_list.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final String productId;

  const EditProduct({super.key, required this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _txtBrand = TextEditingController();
  TextEditingController _txtSku = TextEditingController();
  TextEditingController _txtProductName = TextEditingController();
  TextEditingController _txtWeight = TextEditingController();
  TextEditingController _txtPrice = TextEditingController();
  TextEditingController _txtComperedPrice = TextEditingController();
  TextEditingController _txtDes = TextEditingController();
  TextEditingController _txtCategory = TextEditingController();
  TextEditingController _txtSubCategory = TextEditingController();
  TextEditingController _txtStock = TextEditingController();
  TextEditingController _txtLowStock = TextEditingController();
  TextEditingController _txtTax = TextEditingController();
  String img = "";
  String categoryImg = "";
  File? _img;
  bool _see = false;
  bool _editing = true;
  DocumentSnapshot? doc;
  double discount = 0.0;
  String dropdownValue = "";
  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  getProductDetails() {
    FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .get()
        .then(
      (DocumentSnapshot document) {
        if (document.exists) {
          setState(() {
            doc = document;
            _txtBrand.text = document['brand'];
            _txtSku.text = document['sku'];
            _txtProductName.text = document['productName'];
            _txtWeight.text = document['weight'];
            _txtDes.text = document['description'];
            _txtTax.text = document['tax'].toString();
            dropdownValue = document['collection'];
            _txtStock.text = document['stockQty'].toString();
            _txtLowStock.text = document['lowStockQty'].toString();
            _txtCategory.text = document['category']['mainCategory'];
            _txtSubCategory.text = document['category']['subCategory'];
            _txtPrice.text = document['price'].toString();
            _txtComperedPrice.text = document['comparedPrice'].toString();
            img = document['productImg'];
            categoryImg = document['category']['imgCategory'];
            var difference = double.parse(_txtPrice.text) -
                double.parse(_txtComperedPrice.text);
            discount =
                (difference / double.parse(_txtComperedPrice.text) * 100);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              setState(
                () {
                  _editing = false;
                },
              );
            },
            child: Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      bottomSheet: Container(
        height: size.height / 17,
        child: Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: "Saving");
                    log("Start...............................");
                    if (_img != null) {
                      log("Image Check.........................................");
                      provider
                          .uploadProduct(_img!.path, _txtProductName.text)
                          .then(
                        (url) {
                          if (url != null) {
                            log("with image going......................................");

                            EasyLoading.dismiss();
                            provider.updateProductDataToDB(
                              productName: _txtProductName.text,
                              weight: _txtWeight.text,
                              tax: double.parse(_txtTax.text),
                              stockQty: double.parse(_txtStock.text),
                              sku: _txtSku.text,
                              price: double.parse(_txtPrice.text),
                              lowStockQty: double.parse(_txtLowStock.text),
                              des: _txtDes.text,
                              collection: dropdownValue,
                              brand: _txtBrand.text,
                              comparedPrice:
                                  double.parse(_txtComperedPrice.text),
                              category: _txtCategory.text,
                              subcategory: _txtSubCategory.text,
                              productId: widget.productId,
                              image: img,
                              categoryImage: categoryImg,
                              context: context,
                            );
                          }
                        },
                      );
                    } else {
                      log("without image going......................................");
                      provider.updateProductDataToDB(
                        productName: _txtProductName.text,
                        weight: _txtWeight.text,
                        tax: double.parse(_txtTax.text),
                        stockQty: double.parse(_txtStock.text),
                        sku: _txtSku.text,
                        price: double.parse(_txtPrice.text),
                        lowStockQty: double.parse(_txtLowStock.text),
                        des: _txtDes.text,
                        collection: dropdownValue,
                        brand: _txtBrand.text,
                        comparedPrice: double.parse(_txtComperedPrice.text),
                        category: _txtCategory.text,
                        subcategory: _txtSubCategory.text,
                        productId: widget.productId,
                        image: img,
                        categoryImage: categoryImg,
                        context: context,
                      );
                      EasyLoading.dismiss();
                    }
                    ;
                    provider.resetProvider();
                  }
                },
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 120,
                                child: TextFormField(
                                  controller: _txtBrand,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  cursorColor: Colors.green,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    hintText: "Brand",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.green.shade200,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text("Sku :"),
                                  Container(
                                    width: 75,
                                    child: TextFormField(
                                      controller: _txtSku,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            controller: _txtProductName,
                            style: TextStyle(
                              fontSize: 30,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    prefix: Text("\₹ "),
                                  ),
                                  controller: _txtPrice,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width/7.5,
                                child: Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      prefix: Text("/"),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _txtWeight,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    prefix: Text("\₹",  style: TextStyle(
                                        fontSize: 20,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey
                                    ),),
                                  ),
                                  controller: _txtComperedPrice,
                                  style: TextStyle(
                                    fontSize: 20,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    "${discount.toStringAsFixed(0)}% OFF",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Inclusive to all tax",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              provider.getImage().then((image) {
                                setState(() {
                                  _img = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _img != null
                                  ? Image.file(
                                      _img!,
                                      height: 300,
                                    )
                                  : Container(
                                    height: 200,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 12,
                                          color: Color.fromRGBO(0, 0, 0, 0.16),
                                        )
                                      ],
                                    color: Colors.white,
                                    ),
                                    child: Image.network(
                                        img,
                                        height: 300,
                                      ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "About this product",
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLines: null,
                              controller: _txtDes,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              keyboardType: TextInputType.multiline,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Container(
                              alignment: Alignment.center,
                              height: size.height / 12,
                              width: size.width / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border(
                                  right:
                                  BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                  top: BorderSide(color: Colors.green),
                                  bottom:
                                  BorderSide(color: Colors.green),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width / 40,
                                  ),
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: size.width / 40,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: _txtCategory,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            setState(() {});
                                            return "Select Category Name";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.green,
                                        decoration: InputDecoration(
                                          hintText: 'Not Selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),

                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _editing ? false : true,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CategoryList();
                                          },
                                        ).whenComplete(() {
                                          setState(() {
                                            categoryImg = provider.imgCategory;
                                            _txtCategory.text =
                                                provider.selectedCategory;
                                            _see = true;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _see,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height / 12,
                                width: size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border(
                                    right:
                                    BorderSide(color: Colors.green),
                                    left: BorderSide(color: Colors.green),
                                    top: BorderSide(color: Colors.green),
                                    bottom:
                                    BorderSide(color: Colors.green),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width / 40,
                                    ),
                                    Text(
                                      "Sub Category",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: size.width / 50,
                                    ),
                                    Expanded(
                                      child: AbsorbPointer(
                                        absorbing: true,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: _txtSubCategory,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Select Sub Category Name";
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.green,
                                          decoration: InputDecoration(
                                            hintText: 'Not Selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return subCategoryList();
                                          },
                                        ).whenComplete(() {
                                          setState(() {
                                            _txtSubCategory.text =
                                                provider.selectedSubCategory;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: size.height / 12,
                            width: size.width / 1.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border(
                                right:
                                BorderSide(color: Colors.green),
                                left: BorderSide(color: Colors.green),
                                top: BorderSide(color: Colors.green),
                                bottom:
                                BorderSide(color: Colors.green),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Text(
                                  "Collection",
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: size.width / 12,
                                ),
                                DropdownButton<String>(
                                  hint: Text(
                                    "Select Collection",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  value: dropdownValue.isNotEmpty
                                      ? dropdownValue
                                      : null,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                  items: _collection
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          Container(
                            alignment: Alignment.center,
                            height: size.height / 12,
                            width: size.width / 1.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border(
                                right:
                                BorderSide(color: Colors.green),
                                left: BorderSide(color: Colors.green),
                                top: BorderSide(color: Colors.green),
                                bottom:
                                BorderSide(color: Colors.green),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Text("Stock : ", style: TextStyle(
                                  fontSize: 15,
                                ),),
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _txtStock,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          Container(
                            alignment: Alignment.center,
                            height: size.height / 12,
                            width: size.width / 1.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border(
                                right:
                                BorderSide(color: Colors.green),
                                left: BorderSide(color: Colors.green),
                                top: BorderSide(color: Colors.green),
                                bottom:
                                BorderSide(color: Colors.green),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Text("Low Stock : ", style: TextStyle(
                                  fontSize: 15,
                                ),),
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _txtLowStock,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          Container(
                            alignment: Alignment.center,
                            height: size.height / 12,
                            width: size.width / 1.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border(
                                right:
                                BorderSide(color: Colors.green),
                                left: BorderSide(color: Colors.green),
                                top: BorderSide(color: Colors.green),
                                bottom:
                                BorderSide(color: Colors.green),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Text("Tax : ", style: TextStyle(
                                  fontSize: 15,
                                ),),
                                SizedBox(
                                  width: size.width / 40,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    controller: _txtTax,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
