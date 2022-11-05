import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/dash_page.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  var subscription;

  bool isOnline = true;

  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOnline = false;
        });
      } else {
        setState(() {
          isOnline = true;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashPage()),
              (route) => false);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no_internet.png",
            height: 300,
            width: 300,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              "Looks like you got disconnected, Please check your Internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    );
  }
}
