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
  CollectionReference followRequestCollection =
      FirebaseFirestore.instance.collection("followRequests");

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

      await postCollection.doc(postId).update({'likedBy': post.likedBy});
    });
  }

  uploadProfilePicture(File imgFile) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    var filename = basename(imgFile.path);
    var destination = "userProfileImages/$userId/$filename";
    var ref = FirebaseStorage.instance.ref(destination);

    var snapshot = await ref.putFile(imgFile);

    snapshot.ref.getDownloadURL().then((value) async {
      return await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profileImg': value});
    });
  }

  Future<QuerySnapshot> searchUsers(String searchQuery) async {
    return await userCollection
        .where(['username', 'fullName'], isEqualTo: searchQuery).get();
  }

  followUser(BuildContext context, String destinationUserId,
      AmigosFollowRequestUser followRequestUser) async {

    /*

      * 1. Check if the current user already follows the visited profile
      *
      * 2. If already follows, unfollow visited profile
      *
      * 3. If not, check if the user has already sent a follow request to visited profile
      *
      * 4. If already sent a follow request, cancel the follow request
      *
      * 5. If not, send a follow request

     */


    // checking if the visited profile is in the user's following list
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      var data = snapshot.data() as Map<String, dynamic>;
      var currentUser = AmigosUser.fromJson(data);

      var indexAtWhichObjectExists = -1;

      var indexIterator = -1;

      for (var element in currentUser.following) {
        indexIterator++;

        // if exists record the index at which profile details exists
        if (element['userId'] == destinationUserId) {
          indexAtWhichObjectExists = indexIterator;
        }
      }

      if (indexAtWhichObjectExists >= 0) {
        // as current user is already following visited profile, stop following
        currentUser.following.removeAt(indexAtWhichObjectExists);

        // Update current user profile
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'following': currentUser.following})
            .then((value) => mySnackBar(context, "Removed user from your following list."));

        // Also Remove currentUser from destinationUser's follower list
        await userCollection
            .doc(destinationUserId)
            .get()
            .then((DocumentSnapshot snapshot) async {
          var data = snapshot.data() as Map<String, dynamic>;
          var destinationUser = AmigosUser.fromJson(data);

          var indexAtWhichObjectExistsInFollowerList = -1;

          var indexIteratorDestination = -1;

          for (var element in destinationUser.followers) {
            indexIteratorDestination++;

            if (element['userId'] == currentUser.userId) {
              indexAtWhichObjectExistsInFollowerList = indexIteratorDestination;
            }
          }

          if (indexAtWhichObjectExistsInFollowerList >= 0) {
            destinationUser.followers.removeAt(indexIteratorDestination);
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(destinationUserId)
              .update({'followers': destinationUser.followers})
              .then((value) {
            mySnackBar(context, "Unfollowed user");
          });
        });
      } else {
        // current user not already following visited profile
        // check if current user has already sent a follow request to visited profile earlier
        await followRequestCollection
            .doc(destinationUserId)
            .get()
            .then((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            var data = snapshot.data() as Map<String, dynamic>;
            var followRequest = AmigosUserFollowRequests.fromJson(data);

            var indexAtWhichObjectExists = -1;

            var indexIterator = -1;

            for (var element in followRequest.followRequestsList) {
              indexIterator++;

              if (element['username'] == followRequestUser.username) {
                indexAtWhichObjectExists = indexIterator;
              }
            }

            if (indexAtWhichObjectExists >= 0) {
              // user already exists in followRequestList
              followRequest.followRequestsList
                  .removeAt(indexAtWhichObjectExists);
            } else {
              // user does not exist

              followRequest.followRequestsList.add({
                'userId': followRequestUser.userId,
                'username': followRequestUser.username,
                'fullName': followRequestUser.fullName,
                'profileImg': followRequestUser.profileImg,
              });
            }

            await FirebaseFirestore.instance
                .collection('followRequests')
                .doc(destinationUserId)
                .update({
              'followRequestList': followRequest.followRequestsList
            }).then((value) {
              if (indexAtWhichObjectExists >= 0) {
                mySnackBar(context, "Follow Request revoked");
              } else {
                mySnackBar(context, "Follow Request sent");
              }
            });
          } else {
            // user doesn't already follow visited profile
            // and it is the first time user has pressed on Follow btn on this profile
            followRequestCollection
                .doc(destinationUserId)
                .set({
                  'followRequestList': List.of([
                    {
                      'userId': followRequestUser.userId,
                      'fullName': followRequestUser.fullName,
                      'username': followRequestUser.username,
                      'profileImg': followRequestUser.profileImg
                    }
                  ])
                })
                .then((value) => mySnackBar(context, "Follow request sent."))
                .onError((error, stackTrace) =>
                    mySnackBar(context, "Error: $error"));
          }
        }).onError((error, stackTrace) => mySnackBar(context, "Error: $error"));
      }
    });
  }

  Future<AmigosUserFollowRequests> getUserAllFollowRequests(
      BuildContext context) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return await followRequestCollection
        .doc(currentUserId)
        .get()
        .then((DocumentSnapshot snapshot) {
      print(snapshot.data().toString());
      if (snapshot.data() == null) {
        mySnackBar(context, "No requests found");
      }
      return AmigosUserFollowRequests.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }
}
