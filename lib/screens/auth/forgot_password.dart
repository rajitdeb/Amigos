import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/app_text_logo.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController usernameController = TextEditingController();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pageHeader(),
              const SizedBox(height: 48.0),
              forgotPasswordForm(context)
            ],
          ),
        ),
      ),
    );
  }

  pageHeader() {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        SizedBox(
            width: 70.0,
            height: 70.0,
            child: Image.asset("images/icon/launcher_icon.png")),
        const SizedBox(height: 16.0),
        appTextLogo(context),
      ],
    );
  }

  forgotPasswordForm(BuildContext context) {
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
            )
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
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
                  "Forgot Password",
                  style: TextStyle(
                    color: MyColors.mainColor,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  "A password reset link will be sent to your registered email.",
                  style: TextStyle(
                    color: MyColors.mainColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
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
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () => _sendPasswordResetLink(context),
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
                            "SEND RESET LINK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
  }

  _sendPasswordResetLink(BuildContext context) async {

    setState(() {
      isLoading = true;
    });

    String email = usernameController.text.toString();

    if (email.isNotEmpty) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        setState(() {
          isLoading = false;
        });
            mySnackBar(context, "Email sent.");
          })
          .onError((FirebaseAuthException error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        if (error.code == "user-not-found") {
          mySnackBar(context, "Error: User not found with this email");
        } else {
          mySnackBar(context, "Error: " + error.toString());
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      mySnackBar(context, "Email field cannot be empty.");
    }
  }
}
