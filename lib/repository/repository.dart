import 'package:amigos/model/user.dart';
import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmigosRepository {

  // endpoints
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  // methods
  Future<void> addUserDataToFirestore(BuildContext context, AmigosUser user) async {
    return userCollection
        .doc(user.userId)
        .set({
          'userId': user.userId,
          'username': user.username,
          'fullName': user.fullName,
          'email': user.email,
          'bio': user.bio,
          'postsCount': user.postsCount,
          'posts': user.posts,
          'followersCount': user.followersCount,
          'followingCount': user.followingCount,
          'userDetails': user.userDetails
        })
        .then((value) => mySnackBar(context, "User details added."))
        .catchError((error) =>
            mySnackBar(context, "Failed to add user. Error: $error"));
  }

  Future setAmigosUserCustomUsername(BuildContext context, String userId, String username) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((QuerySnapshot snapshot) {
          if(snapshot.docs.isNotEmpty){
            mySnackBar(context, "Username already exists. Please choose a different username");
          } else {
            userCollection
                .doc(userId)
                .update({
              'username': username
            })
            .then((value) {
              mySnackBar(context, "Successfully set username");
              Get.offAll(() => const HomeScreen());
            })
            .onError((error, stackTrace) {
              mySnackBar(context, error.toString());

            });
          }
        })
        .catchError((error) {
            mySnackBar(context, "Failed to add user. Error: $error");
        });
  }

}