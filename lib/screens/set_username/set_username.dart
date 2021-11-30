import 'package:amigos/bloc/create_user_bloc.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/app_text_logo.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetUsernameScreen extends StatefulWidget {
  const SetUsernameScreen({Key? key}) : super(key: key);

  @override
  _SetUsernameScreenState createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends State<SetUsernameScreen> {

  TextEditingController usernameController = TextEditingController();

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
              setUsernameForm(context)
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

  setUsernameForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
            "Set Username",
            style: TextStyle(
              color: MyColors.mainColor,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            "Set your username so that its easier for people to find you.",
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
                labelText: "Custom Username",
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
            onTap: () => _setUsernameForUser(context),
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

  _setUsernameForUser(BuildContext context) async {

    String username = usernameController.text.toString();

    if(username.isNotEmpty || username.contains("@")){
      CreateUserBloc().setAmigosUserCustomUsername(
          context,
          FirebaseAuth.instance.currentUser!.uid,
          username
      );

    }else {
      mySnackBar(context, "Please enter a valid username");
    }
  }

}
