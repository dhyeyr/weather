import 'dart:async';


import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("HomePage", (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Center(
          child: Image.asset("assets/splash.png",width: 200,),
        ),
      ),
    );
  }
}
