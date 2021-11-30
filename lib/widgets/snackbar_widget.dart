import 'package:flutter/material.dart';

mySnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}