import 'package:amigos/screens/auth/forgot_password.dart';
import 'package:amigos/screens/auth/signup_screen.dart';
import 'package:amigos/screens/auth/verify_email.dart';
import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/app_text_logo.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: Image.asset("images/icon/launcher_icon.png")),
              const SizedBox(height: 16.0),
              appTextLogo(context),
              const SizedBox(height: 48.0),
              loginForm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return isLoading == true
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            child: const Center(
              child: SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ))
        : Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: MyColors.mainColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: MyColors.mainColor),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.mainColor,
                                width: 2.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.mainColor,
                                width: 2.0,
                                style: BorderStyle.solid))),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: MyColors.mainColor),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.mainColor,
                                width: 2.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.mainColor,
                                width: 2.0,
                                style: BorderStyle.solid))),
                  ),
                  const SizedBox(height: 24.0),
                  GestureDetector(
                    onTap: () => _validateCredentials(),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: MyColors.accentColor,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const ForgotPassword());
                          },
                          child: const Text(
                            "Forgot Password? Click here",
                            style: TextStyle(color: MyColors.secondColor),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const SignupScreen());
                          },
                          child: const Text(
                            "Don't have an account? Signup",
                            style: TextStyle(color: MyColors.secondColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  _validateCredentials() {
    setState(() {
      isLoading = true;
    });

    String username = usernameController.text.toString();
    String password = passwordController.text.toString();

    if (username.isNotEmpty &&
        (username.contains("@gmail.com") ||
            username.contains("@yahoo.com") ||
            username.contains("@yahoo.co.in") ||
            username.contains("@rediffmail.com") ||
            username.contains("@outlook.com"))) {
      if (password.isNotEmpty) {
        signInUser(context, username, password);
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter correct password"),
        ));
      }
    } else {
      mySnackBar(context, "Please enter a valid email");
    }
  }

  signInUser(BuildContext context, String username, String password) async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);

      FirebaseAuth.instance.userChanges().listen((User? user) {
        setState(() {
          isLoading = false;
        });
        if (user != null && user.emailVerified) {
          Get.offAll(() => const HomeScreen());
        } else if (user != null && !user.emailVerified) {
          Get.offAll(() => const VerifyEmailScreen(), arguments: user);
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        mySnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        mySnackBar(context, "The account already exists for that email.");
      } else {
        mySnackBar(context, e.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      mySnackBar(context, e.toString());
    }
  }
}
