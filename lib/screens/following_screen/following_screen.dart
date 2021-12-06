import 'package:amigos/model/user.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool isDataLoading = true;

  List<FollowingDetails> followings = List.empty(growable: true);

  List<dynamic> userFollowing = List.empty();

  List<dynamic> followingFollower = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _getAllFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "You Following",
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
              itemCount: followings.length,
              itemBuilder: (context, index) {
                return _followingtItemRow(context, index);
              })),
    );
  }

  void _getAllFollowing() async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.get('following');
        userFollowing = snapshot.get('following');

        for (var element in data) {
          print('Data: ${element['username']}');

          var user = FollowingDetails(
            element['userId'],
            element['fullName'],
            element['username'],
            element['profileImg'],
          );

          followings.add(user);
        }

        setState(() => isDataLoading = false);
      }
    });

  }

  Widget _followingtItemRow(BuildContext context, int index) {
    var currentItem = followings[index];

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
                  _removeCurrentUserFromFollowing(index, currentItem);
                },
                child: const Text(
                  "Unfollow",
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

  void _removeCurrentUserFromFollowing(int index, FollowingDetails currentItem) async {

    setState(() => isDataLoading = true);

    // remove tapper user from current user's following list

    userFollowing.removeAt(index);

    await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .update({
      'following': userFollowing
    })
    .then((value) async {

      // removed user from following list
      mySnackBar(context, "Successfully unfollowed user");

      // remove current user from tapped user's followers list
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentItem.userId)
      .get()
      .then((DocumentSnapshot snapshot) async {

        if(snapshot.exists){

          followingFollower = snapshot.get('followers');

          var indexIterator = -1;
          var indexAtWhichObjectExists = -1;

          for (var element in followingFollower) {
            indexIterator++;

            print('Data: ${element['username']}');

            if (element['userId'] == FirebaseAuth.instance.currentUser!.uid) {
              indexAtWhichObjectExists = indexIterator;
            }
          }

          if (indexAtWhichObjectExists >= 0) {
            // user exists in following list
            followingFollower.removeAt(indexAtWhichObjectExists);
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentItem.userId)
              .update({'followers': followingFollower})
              .then((value) {
                setState(() => followings.clear());
                _getAllFollowing();
          });

        }

      });


    });

  }
}
