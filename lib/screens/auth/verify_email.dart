import 'package:amigos/bloc/create_user_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/screens/set_username/set_username.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late AmigosUser amigosUser;

  bool isChangeEmailTriggered = false;

  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amigosUser = Get.arguments;
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify Email",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.mainColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: MyColors.contentPageColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "An email verification link has been sent your registered email id. Please click on the link to proceed further.",
              style: TextStyle(color: MyColors.secondColor, fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            _changeEmailField(),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () => _validateEmailVerification(context),
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
                        "DONE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () => _changeUserEmail(),
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
                        "CHANGE EMAIL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changeEmailField() {
    return isChangeEmailTriggered == true
        ? Container(
            child: TextField(
              controller: emailController,
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
          )
        : Container();
  }

  _validateEmailVerification(BuildContext myContext) async {
    // isChangeEmailTriggered then request changeEmail() and send verification Email
    // Validate if user has clicked on the link and verified his email

    setState(() => isLoading = true);

    if (isChangeEmailTriggered == true) {
      _validateCredentials(FirebaseAuth.instance.currentUser!);
    } else {
      await FirebaseAuth.instance.currentUser!.reload();

      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        var finalUser = FirebaseAuth.instance.currentUser!;

        var finalAmigosUser = AmigosUser(null, finalUser.uid, "sample_test",
            finalUser.email!, amigosUser.fullName, null, 0, null, 0, 0, null);

        await CreateUserBloc()
            .addAmigosUserToFirestore(context, finalAmigosUser);

        setState(() => isLoading = false);

        Get.offAll(() => const SetUsernameScreen());
      } else {
        setState(() => isLoading = false);
        mySnackBar(myContext, "Please verify your email to continue");
      }
    }
  }

  _validateCredentials(User user) async {
    String email = emailController.text.toString();

    if (email.isNotEmpty &&
        (email.contains("@gmail.com") ||
            email.contains("@yahoo.com") ||
            email.contains("@yahoo.co.in") ||
            email.contains("@rediffmail.com") ||
            email.contains("@outlook.com"))) {
      setState(() {
        isChangeEmailTriggered = false;
        isLoading = false;
      });
      await user.updateEmail(email);
      await user.sendEmailVerification();
    } else {
      mySnackBar(context, "Please enter a valid email");
    }
  }

  _changeUserEmail() {
    // Let user change email id for verification
    // And send email verification link again

    setState(() {
      isChangeEmailTriggered = true;
    });
  }
}
