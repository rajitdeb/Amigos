import 'dart:io';
import 'package:amigos/model/user.dart';
import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class AmigosRepository {
  // endpoints
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");

  // methods
  Future<void> addUserDataToFirestore(
      BuildContext context, AmigosUser user) async {
    return userCollection
        .doc(user.userId)
        .set({
          'userId': user.userId,
          'username': user.username,
          'fullName': user.fullName,
          'email': user.email,
          'bio': user.bio,
          'followers': user.followers,
          'following': user.following
        })
        .then((value) => mySnackBar(context, "User details added."))
        .catchError((error) =>
            mySnackBar(context, "Failed to add user. Error: $error"));
  }

  Future setAmigosUserCustomUsername(
      BuildContext context, String userId, String username) async {
    userCollection
        .where('username', isEqualTo: username)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        mySnackBar(context,
            "Username already exists. Please choose a different username");
      } else {
        userCollection.doc(userId).update({'username': username}).then((value) {
          mySnackBar(context, "Successfully set username");
          Get.offAll(() => const HomeScreen());
        }).onError((error, stackTrace) {
          mySnackBar(context, error.toString());
        });
      }
    }).catchError((error) {
      mySnackBar(context, "Failed to add user. Error: $error");
    });
  }

  createPost(AmigosUserPosts post) async {
    await postCollection.add({
      'postCaption': post.postCaption,
      'postImgLink': post.postImgLink,
      'authorProfileImg': post.authorProfileImg,
      'authorUserId': post.authorUserId,
      'authorUsername': post.authorUsername,
      'authorFullName': post.authorFullName,
      'createdAt': post.createdAt,
      'likedBy': post.likedBy
    });
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    return userCollection.doc(userId).get();
  }

  Future<String> uploadPostImgToFirebaseStorage(String _imgPath) async {
    var filename = basename(_imgPath);
    var destination = "postImages/$filename";
    var ref = FirebaseStorage.instance.ref(destination);

    var snapshot = await ref.putFile(File(_imgPath));

    return snapshot.ref.getDownloadURL();
  }

  getAllPosts() async {
    postCollection.orderBy("createdAt", descending: true);
  }

  updateLikes(postId) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    postCollection.doc(postId).get().then((DocumentSnapshot snapshot) async {
      var data = snapshot.data() as Map<String, dynamic>;
      var post = AmigosUserPosts.fromJson(data);

      if (post.likedBy.contains(currentUserId)) {
        post.likedBy.remove(currentUserId);
      } else {
        post.likedBy.add(currentUserId);
      }

      await postCollection.doc(postId).update({
        'likedBy': post.likedBy
      });
    });
  }

  uploadProfilePicture(File imgFile) async {

    final userId = FirebaseAuth.instance.currentUser!.uid;

    var filename = basename(imgFile.path);
    var destination = "userProfileImages/$userId/$filename";
    var ref = FirebaseStorage.instance.ref(destination);

    var snapshot = await ref.putFile(imgFile);

    snapshot.ref.getDownloadURL().then((value) async {
      return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({ 'profileImg': value });
    });
  }

  Future<QuerySnapshot> searchUsers(String searchQuery) async {
    return await userCollection
        .where(['username', 'fullName'], isEqualTo: searchQuery)
        .get();
  }
}
