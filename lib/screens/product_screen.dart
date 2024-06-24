import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/screens/add_product_screen.dart';
import 'package:grocery_vendor_side/widget/drawer.dart';
import 'package:grocery_vendor_side/widget/published_product.dart';
import 'package:grocery_vendor_side/widget/unpublished_product.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Manage Products',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green
              ),
            ),
          ),
          drawer: kDrawer(),
          body: Column(
            children: [
              Material(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 10.0, right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AddProduct.id);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width/1.1,
                          height: size.height / 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(width: size.width/40,),
                              Text(
                                'Add New',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                tabs: [
                  Tab(
                    text: ' Published ',
                  ),
                  Tab(
                    text: ' Un Published ',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PublishProduct(),
                    UnPublishProduct(),
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
