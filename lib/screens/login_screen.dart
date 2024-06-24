import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/provider/auth_provider.dart';
import 'package:grocery_vendor_side/screens/register_screen.dart';
import 'package:grocery_vendor_side/screens/resetPassword_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String txtEmail = "";
  String txtPassword = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<auth_provider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Upper Text
                  SizedBox(
                    height: size.height / 18,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Text(
                        'Vendor Login',
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
                        'Access Your Dashboard By Own Way',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height / 56,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  //Lower Text
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
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.height / 40),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.16),
                                      )
                                    ]
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(size.height / 90),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                      child: TextFormField(
                                        cursorColor: Colors.green,
                                        controller: emailController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Email";
                                          }
                                          final bool _isValid =
                                              EmailValidator.validate(
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
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ), //Email TextFiled
                                    Container(
                                      padding: EdgeInsets.all(size.height / 90),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: passwordController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Password";
                                          }
                                          if (value.length < 6) {
                                            return "Minimum 6 characters allowed";
                                          }
                                          setState(() {
                                            txtPassword = value;
                                          });
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: _passObsecure,
                                        cursorColor: Colors.green,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
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
                                        ),
                                      ),
                                    ), //Password TextFiled
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height / 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(ResetPassword.id);
                                    },
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ), //Forgot password text
                              SizedBox(
                                height: size.height / 35,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    // setState(() {
                                    //   _loading = true;
                                    // });
                                    auth.LoginVendor(txtEmail, txtPassword,context);
                                  }
                                },
                                child: Container(
                                  width: size.width,
                                  height: size.height / 15,
                                  // margin: EdgeInsets.symmetric(
                                  //     horizontal: size.width / 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: _loading
                                        ? CupertinoActivityIndicator(
                                            color: Colors.white,
                                      animating: true,
                                          )
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: size.height / 40,
                                            ),
                                          ),
                                  ),
                                ),
                              ), //Login Button
                              SizedBox(
                                height: size.height / 80,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(RegistrationScreen.id);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: '',
                                    children: [
                                      TextSpan(
                                        text: "Don\'t have an account ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Register?",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
