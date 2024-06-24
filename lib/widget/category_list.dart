import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var category = FirebaseFirestore.instance.collection("category");

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(28),
                topLeft: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Category",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: category.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            document['img'],
                          ),
                        ),
                        title: Text("${document['catName']}"),
                        onTap: () {
                          _provider.SelectedCategory(
                            imgCategory: document['img'],
                            mainCategory: document['catName'],
                          );
                          Get.back();
                        },
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class subCategoryList extends StatefulWidget {
  const subCategoryList({super.key});

  @override
  State<subCategoryList> createState() => _subCategoryListState();
}

class _subCategoryListState extends State<subCategoryList> {
  var category = FirebaseFirestore.instance.collection("category");

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Sub Category",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: category.doc(_provider.selectedCategory).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map data = {};
                data = snapshot.data?.data() as Map;
                return data != null
                    ? Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(" ~ : : Main Category : : ~ "),
                                    SizedBox(height: 5,),
                                    Text(
                                      " ${_provider.selectedCategory} ",
                                      style: TextStyle(
                                        overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w700,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 5,
                            ),
                            Container(
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView.builder(
                                    itemBuilder: (BuildContext context, int i) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Text("${i + 1}"),
                                        ),
                                        title: Text(
                                            "${data['subCat'][i]['subCatName']}"),
                                        onTap: () {
                                          _provider.SelectedSubCategory(
                                              data['subCat'][i]['subCatName']);
                                          Get.back();
                                        },
                                      );
                                    },
                                    itemCount: data['subCat'] == null
                                        ? 0
                                        : data['subCat'].length,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text("No category selected");
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
