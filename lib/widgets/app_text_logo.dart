import 'package:flutter/material.dart';

Widget appTextLogo(BuildContext context) {
  return SizedBox(
    child: Column(
      children: const [

        Text(
          "Amigos",
          style: TextStyle(
              color: Colors.white,
              fontSize: 48.0,
              fontWeight: FontWeight.w900
          ),
        ),

        Text(
          "Connect with people",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.normal
          ),
        ),
      ],
    ),
  );
}