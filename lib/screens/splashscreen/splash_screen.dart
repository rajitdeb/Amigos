import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/screens/auth/login_screen.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/app_text_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyColors.mainColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(height: 120.0,),

            appTextLogo(context),

            const SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(color: Colors.white,)),

            appVersionNumber(context)
          ],
        ),
      ),
    );
  }

  Widget appVersionNumber(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Text(
        "v0.0.1",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal
        ),
      ),
    );
  }

  _moveToHomeScreen() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    // Get.offAll(() => const LoginScreen());
    if(FirebaseAuth.instance.currentUser != null){
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
