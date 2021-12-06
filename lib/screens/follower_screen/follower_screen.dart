import 'package:amigos/model/user.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({Key? key}) : super(key: key);

  @override
  _FollowerScreenState createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  bool isDataLoading = true;

  List<FollowerDetails> followers = List.empty(growable: true);

  List<dynamic> userFollowers = List.empty();

  List<dynamic> followersFollowing = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _getAllFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Followers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.mainColor,
      ),
      body: isDataLoading == true
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: MyColors.contentPageColor,
              child: const Center(
                child: SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    )),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: MyColors.contentPageColor,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: ListView.builder(
                  itemCount: followers.length,
                  itemBuilder: (context, index) {
                    return _pendingFollowRequestItemRow(context, index);
                  })),
    );
  }

  _pendingFollowRequestItemRow(BuildContext context, int index) {
    var currentItem = followers[index];

    return Card(
      color: MyColors.secondColor,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            currentItem.profileImg != null
                ? SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentItem.profileImg!),
                    ),
                  )
                : Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: const BoxDecoration(
                        color: MyColors.mainColor, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 120.0,
                    child: Text(
                        currentItem.fullName != null
                            ? currentItem.fullName!
                            : "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0))),
                SizedBox(
                    width: 120.0,
                    child: Text("@${currentItem.username}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ))),
              ],
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  _removeUserFromCurrentUserFollowers(index, currentItem);
                },
                child: const Text(
                  "REMOVE",
                  style: TextStyle(color: MyColors.accentColor),
                ),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getAllFollowers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.get('followers');
        userFollowers = snapshot.get('followers');

        for (var element in data) {
          print('Data: ${element['username']}');

          var user = FollowerDetails(
            element['userId'],
            element['fullName'],
            element['username'],
            element['profileImg'],
          );

          followers.add(user);
        }

        setState(() => isDataLoading = false);
      }
    });
  }

  void _removeUserFromCurrentUserFollowers(
      int index, FollowerDetails followerDetails) async {
    setState(() => isDataLoading = true);

    // remove user from currentUser's followers list
    userFollowers.removeAt(index);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'followers': userFollowers}).then((value) async {
      mySnackBar(context, "Removed user from followers");

      // remove current user from followers following list
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followerDetails.userId)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          followersFollowing = snapshot.get('following');

          var indexIterator = -1;
          var indexAtWhichObjectExists = -1;

          for (var element in followersFollowing) {
            indexIterator++;

            print('Data: ${element['username']}');

            if (element['userId'] == FirebaseAuth.instance.currentUser!.uid) {
              indexAtWhichObjectExists = indexIterator;
            }
          }

          if (indexAtWhichObjectExists >= 0) {
            // user exists in following list
            followersFollowing.removeAt(indexAtWhichObjectExists);
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(followerDetails.userId)
              .update({'following': followersFollowing}).then((value) {
                setState(() => followers.clear());
            _getAllFollowers();
          });
        }
      });
    });
  }
}
