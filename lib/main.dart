import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/firebase_options.dart';
import 'package:grocery_vendor_side/provider/auth_provider.dart';
import 'package:grocery_vendor_side/provider/order_provider.dart';
import 'package:grocery_vendor_side/provider/product_provider.dart';
import 'package:grocery_vendor_side/screens/SplashScreen.dart';
import 'package:grocery_vendor_side/screens/add_product_screen.dart';
import 'package:grocery_vendor_side/screens/home_screen.dart';
import 'package:grocery_vendor_side/screens/login_screen.dart';
import 'package:grocery_vendor_side/screens/product_screen.dart';
import 'package:grocery_vendor_side/screens/register_screen.dart';
import 'package:grocery_vendor_side/screens/resetPassword_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => auth_provider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        AddProduct.id: (context) => AddProduct(),
        ProductScreen.id: (context) => ProductScreen(),
      },
    );
  }
}
