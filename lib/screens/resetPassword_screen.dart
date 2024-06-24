
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/auth_provider.dart';
import 'package:grocery_vendor_side/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-password-screen';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController emailController = TextEditingController();
  String txtEmail = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<auth_provider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: Colors.green
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Upper Page
                SizedBox(
                  height: size.height / 18,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height / 25,
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
                      'Enter your email to get a password reset link',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height / 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height / 25,
                ),
                //Lower Page
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height / 12),
                        topRight: Radius.circular(size.height / 12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(size.height / 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height / 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(size.height / 90),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 12,
                                      color: Color.fromRGBO(0, 0, 0, 0.16),
                                    )
                                  ],
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200),

                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Email";
                                  }
                                  final bool _isValid = EmailValidator.validate(
                                      emailController.text);
                                  if (!_isValid) {
                                    return 'Invalid email format';
                                  }
                                  setState(() {
                                    txtEmail = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ), //Email TextFiled
                            SizedBox(
                              height: size.height / 25,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  auth.resetPassword(txtEmail);
                                  Get.snackbar("Alert", "Please Check Your Email ${txtEmail} To Reset Password");
                                  Get.offAllNamed(LoginScreen.id);
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //         "Please Check Your Email ${txtEmail} To Reset Password"),
                                  //   ),
                                  // );
                                }
                              },
                              child: Container(
                                height: size.height / 15,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child:
                                  _loading
                                      ? CupertinoActivityIndicator(
                                          color: Colors.green,
                                          animating: true,
                                        )
                                      :
                                  Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: size.height / 50,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height / 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Remember your password?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width / 100,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(LoginScreen.id);
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
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
