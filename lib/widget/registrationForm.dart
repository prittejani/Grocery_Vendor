import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/auth_provider.dart';
import 'package:grocery_vendor_side/screens/home_screen.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _confirmPassObsecure = true;
  bool _passObsecure = true;

  String shopEmail = "";
  String shopPassword = "";
  String shopName = "";
  String shopDialog = "";
  String shopMono = "";
  String shopAddress = "";
  bool isLoading = false;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtCPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<auth_provider>(context);
    Message(message) {
      setState(() {
      });
      Get.snackbar(
        "",
        "",
        //borderColor: Colors.green,
        colorText: Colors.green,
        titleText: Text("Alert.. ⚠",style: TextStyle(color: Colors.redAccent),),
        barBlur: 2,
        messageText: Text(message,style: TextStyle(color: Colors.redAccent),),
        backgroundColor: Colors.grey.shade200,
        boxShadows: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
        icon: const Icon(Icons.add_alert,color: Colors.green,),
      );
    }
    return isLoading
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          )
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Shop Name";
                        }
                        setState(() {
                          shopName = value;
                        });
                        return null;
                      },
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_business,color: Colors.green,),
                          hintText: " Business Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),
                          ),
                          focusColor: Colors.green),
                    ),
                  ), //Name
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if(value!.length > 10 && value.length < 10 )
                          {
                            return "Enter valid mobile number";
                          }
                        if (value.isEmpty) {
                          return "Enter Mobile Number";
                        }
                        setState(() {
                          shopMono = value;
                        });
                        return null;
                      },
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone,color: Colors.green,),
                          hintText: " Mobile Number",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //Mobile Number
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        final bool _isValid =
                            EmailValidator.validate(txtEmail.text);
                        if (!_isValid) {
                          return 'Invalid email format';
                        }
                        setState(() {
                          shopEmail = value;
                        });
                        return null;
                      },
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,color: Colors.green,),
                          hintText: " Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //email
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: txtPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        if (value.length < 6) {
                          return "Minimum 6 characters allowed";
                        }
                        return null;
                      },
                      cursorColor: Colors.green,
                      obscureText: _passObsecure,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passObsecure = !_passObsecure;
                              });
                            },
                            child: _passObsecure
                                ? Icon(
                              CupertinoIcons.eye,
                              color: Colors.grey,
                            )
                                : Icon(
                              CupertinoIcons.eye_slash,
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock,color: Colors.green,),
                          hintText: " Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //Password
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: txtCPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        if (value.length < 6) {
                          return "Minimum 6 characters allowed";
                        }
                        if (txtPassword.text != txtCPassword.text) {
                          return 'Password Dosen\'t Match';
                        }
                        setState(() {
                          shopPassword = value;
                        });
                        return null;
                      },
                      cursorColor: Colors.green,
                      obscureText: _confirmPassObsecure,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _confirmPassObsecure = !_confirmPassObsecure;
                              });
                            },
                            child: _confirmPassObsecure
                                ? Icon(
                              CupertinoIcons.eye,
                              color: Colors.grey,
                            )
                                : Icon(
                              CupertinoIcons.eye_slash,
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock,color: Colors.green,),
                          hintText: " Confirm Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //Confirm Password
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: txtAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Press Navigation Button";
                        }
                        if (auth.shoplatitude == null) {
                          return "Please Press Navigation Button";
                        }
                        setState(() {
                          shopAddress = value;
                        });
                        return null;
                      },
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.contact_mail,color: Colors.green,),
                          suffixIcon: IconButton(
                            onPressed: () {
                              txtAddress.text = 'Locating...\nPlease Wait';
                              auth.getCurrentAddress().then((address) {
                                if (address != null) {
                                  setState(() {
                                    txtAddress.text = '${auth.shopAddress}';
                                  });
                                } else {
                                  Get.snackbar(
                                    "",
                                    "",
                                    //borderColor: Colors.green,
                                    colorText: Colors.green,
                                    barBlur: 2,
                                    messageText: Text("Couldn't find location",style: TextStyle(color: Colors.redAccent),),
                                    backgroundColor: Colors.grey.shade200,
                                    boxShadows: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.16),
                                      )
                                    ],
                                    icon: const Icon(Icons.add_alert,color: Colors.green,),
                                  );
                                }
                              });
                            },
                            icon: Icon(Icons.location_searching,color: Colors.green,),
                          ),
                          hintText: " Business Address",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //address
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      validator: (value) {
                        setState(() {
                          shopDialog = value.toString();
                        });
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.comment,color: Colors.green,),
                          hintText: " Shop Dialog",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),),
                          focusColor: Colors.green),
                    ),
                  ), //Shop Dialog
                  SizedBox(
                    height: size.height / 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (auth.ifPicAvail == true) {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          auth
                              .registerVendor(shopEmail, shopPassword)
                              .then((credential) {
                            log("===========-----> Vendor Data Uploaded");
                            auth
                                .uploadShopImage(auth.image, shopName)
                                .then((url) {
                              log("===========-----> Shop Image Uploaded");
                              if (url != null) {
                                auth.UploadShopData(
                                  ShopImg: url,
                                  ShopName: shopName,
                                  ShopMobileNumber: "+91${shopMono}",
                                  ShopDialog: shopDialog,
                                  ShopAddress: shopAddress,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                Get.offAllNamed(HomeScreen.id);
                                log("===========-----> Shop All Data Uploaded");
                              } else {
                                Message("Failed to Upload Shop Pic");
                              }
                            });
                          });
                        } else {
                          Message("Please enter valid details");
                        }
                      } else {
                        Message("Shop Image is required");
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: size.height / 18,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(size.height / 20),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                ],
              ),
            ),
          );
  }
}
