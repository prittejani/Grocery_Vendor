import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor_side/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ShopPicCard extends StatefulWidget {
  const ShopPicCard({super.key});

  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File? image;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<auth_provider>(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          auth.getImage().then((image) {
            setState(() {
              this.image = image;
            });
            if (image != null) {
              auth.ifPicAvail = true;
            }
          });
        },
        child: Container(
          height: size.height / 6,
          width: size.width / 2.8,
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(30),
              shape: BoxShape.circle,
              border: Border(
                right: BorderSide(color: Colors.green),
                left: BorderSide(color: Colors.green),
                bottom: BorderSide(color: Colors.green),
                top: BorderSide(color: Colors.green),
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.width / 80),
            child: image == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Shop Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: size.height / 6,
                    width: size.width / 2.8,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(30),
                      shape: BoxShape.circle,
                      border: Border(
                        right: BorderSide(color: Colors.green),
                        left: BorderSide(color: Colors.green),
                        bottom: BorderSide(color: Colors.green),
                        top: BorderSide(color: Colors.green),
                      ),
                      image: DecorationImage(
                        image:  FileImage(
                          image!,
                        ),
                        fit: BoxFit.fill,
                      )
                    ),

                  ),
          ),
        ),
      ),
    );
  }
}
