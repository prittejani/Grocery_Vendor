import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/screens/login_screen.dart';
import 'package:grocery_vendor_side/widget/image_piker.dart';
import 'package:grocery_vendor_side/widget/registrationForm.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration-screen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height / 18,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Text(
                      'Vendor Registration',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height / 30,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height / 130,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Text(
                      'Register your self and provide service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height / 65,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height / 25,
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height / 12),
                        topRight: Radius.circular(size.height / 12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(size.height / 50),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ShopPicCard(),
                            RegistrationForm(),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(LoginScreen.id);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: '',
                                  children: [
                                    TextSpan(
                                      text: "Already have an account ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login?",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height / 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
