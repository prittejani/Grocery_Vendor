import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor_side/screens/dashboard_screen.dart';
import 'package:grocery_vendor_side/widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.bell),
              ),
            ],
          ),
        ]),
        drawer: kDrawer(),
        body: MainScreen(),
      ),
    );
  }
}
