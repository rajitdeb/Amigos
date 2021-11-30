import 'package:amigos/model/user.dart';
import 'package:amigos/screens/auth/login_screen.dart';
import 'package:amigos/screens/auth/verify_email.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/app_text_logo.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
              const SizedBox(height: 16.0),
              signupForm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget signupForm(BuildContext context) {
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
              height: MediaQuery.of(context).size.height,
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
                    "Sign Up",
                    style: TextStyle(
                      color: MyColors.mainColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        labelText: "Full Name",
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
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        labelText: "Email",
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
                              "SIGNUP",
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
                            Get.offAll(() => const LoginScreen());
                          },
                          child: const Text(
                            "Already have an account? Login",
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
    setState(() => isLoading = true);

    String fullName = fullNameController.text.toString();
    String username = usernameController.text.toString();
    String password = passwordController.text.toString();

    if (fullName.isNotEmpty) {
      if (username.isNotEmpty &&
          (username.contains("@gmail.com") ||
              username.contains("@yahoo.com") ||
              username.contains("@yahoo.co.in") ||
              username.contains("@rediffmail.com") ||
              username.contains("@outlook.com"))) {
        if (password.isNotEmpty) {
          signupUser(context, fullName, username, password);
        } else {
          setState(() => isLoading = false);
          mySnackBar(context, "Password field cannot be empty.");
        }
      } else {
        setState(() => isLoading = false);
        mySnackBar(context, "Please enter a valid email");
      }
    } else {
      setState(() => isLoading = false);
      mySnackBar(context, "Please enter full name");
    }
  }

  void signupUser(BuildContext context, String fullName, String username,
      String password) async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: username, password: password);

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      FirebaseAuth.instance.userChanges().listen((User? user) async {
        if (user != null && !user.emailVerified) {
          setState(() => isLoading = false);

          var amigosUser = AmigosUser(null, user.uid, "sample_test", fullName, user.email!,
             null, 0, null, 0, 0, null);

          Get.offAll(() => const VerifyEmailScreen(), arguments: amigosUser);
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      if (e.code == 'weak-password') {
        mySnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        mySnackBar(context, "The account already exists for that email.");
      } else {
        mySnackBar(context, e.toString());
      }
    } catch (e) {
      setState(() => isLoading = false);
      mySnackBar(context, e.toString());
    }
  }
}
