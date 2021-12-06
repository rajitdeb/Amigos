import 'package:amigos/bloc/get_user_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowRequests extends StatefulWidget {
  const FollowRequests({Key? key}) : super(key: key);

  @override
  State<FollowRequests> createState() => _FollowRequestsState();
}

class _FollowRequestsState extends State<FollowRequests> {

  List<AmigosFollowRequestUser> amigosFollowRequestUserList = List.empty(growable: true);

  List<dynamic> userDetails = List.empty();

  List<dynamic> currentUserFollowerList = List.empty(growable: true);

  bool isDataLoading = true;
  
  @override
  void initState() {
    super.initState();
    _getAllFollowRequest();
  }
  
  @override
  Widget build(BuildContext context) {

    return isDataLoading == true
    ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: MyColors.contentPageColor,
      child: const Center(
        child: SizedBox(
          width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0,)
        ),
      ),
    )
    : Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: MyColors.contentPageColor,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: ListView.builder(
        itemCount: amigosFollowRequestUserList.length,
        itemBuilder: (context, index) {
          return _pendingFollowRequestItemRow(context, index);
        }
      ),
    );
  }

  _getAllFollowRequest() async {
    await FirebaseFirestore.instance
        .collection('followRequests')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {

          if(snapshot.exists) {

            userDetails = snapshot.get('followRequestList');
            for(var element in userDetails) {
              var amigosFollowUer = AmigosFollowRequestUser(
                  element['userId'],
                  element['fullName'],
                  element['username'],
                  element['profileImg'],
              );

              amigosFollowRequestUserList.add(amigosFollowUer);
            }

            setState(() => isDataLoading = false);
          }else {
            setState(() => isDataLoading = false);
          }

    });
  }

  _pendingFollowRequestItemRow(BuildContext context, int index) {

    var currentItem = amigosFollowRequestUserList[index];

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
                backgroundImage: NetworkImage(
                    currentItem.profileImg!),
              ),
            )
                : Container(
              width: 70.0,
              height: 70.0,
              decoration: const BoxDecoration(
                  color: MyColors.mainColor,
                  shape: BoxShape.circle),
              child: const Center(
                child: Icon(Icons.person,
                    color: Colors.white),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 120.0,
                    child: Text(
                        currentItem.fullName != null ? currentItem.fullName! : "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                        )
                    )
                ),

                SizedBox(
                    width: 120.0,
                    child: Text(
                        "@${currentItem.username}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        )
                    )
                ),
              ],
            ),

            Row(
              children: [

                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white,),
                  onPressed: () { _deleteFollowRequestFromUser(index); },
                ),

                IconButton(
                  icon: Icon(Icons.check, color: Colors.white,),
                  onPressed: () {
                    setState(() { isDataLoading = true; });
                    _addUserToMyFollowerList(index);
                  },
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteFollowRequestFromUser(int index) async {
    /* Delete a particular user */
    userDetails.remove(userDetails[index]);
    print("UserDetails List: $userDetails");

    /* Update list after every operation */
    await FirebaseFirestore.instance
    .collection('followRequests')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .update({
      'followRequestList': userDetails
    }).then((value) {
      setState(() {
        isDataLoading = true;
        amigosFollowRequestUserList.clear();
      });
      _getAllFollowRequest();
      mySnackBar(context, "Successfully deleted follow request");
    });

  }

  void _addUserToMyFollowerList(int index) async {

    /*

      * 1. Add user to current user's follower list
      *
      * 2. Add current user to to followedBy user's following list
      *
      * 3. Delete user from amigosFollowUser list and update

     */

    AmigosFollowRequestUser followRequestUser = amigosFollowRequestUserList[index];

    await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get()
    .then((DocumentSnapshot snapshot) async {
      if(snapshot.exists){
        var data = snapshot.data() as Map<String, dynamic>;
        var followerList = AmigosUser.fromJson(data);

        print("Followers Lsit: ${followerList.followers}");

        if(followerList.followers.isEmpty){

          followerList.followers.add(followRequestUser);

          print("Followers Lsit: ${followerList.followers}");

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'followers': List.of([
              {
                'userId': followRequestUser.userId,
                'fullName': followRequestUser.fullName,
                'username': followRequestUser.username,
                'profileImg': followRequestUser.profileImg
              }
            ])
          });

        } else {

          followerList.followers.add(FollowerDetails(
            followRequestUser.userId,
            followRequestUser.fullName,
            followRequestUser.username,
            followRequestUser.profileImg,
          ).toJson());

          print(followerList.followers);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'followers': followerList.followers
          });

        }

        _addCurrentUserToFollowingList(followRequestUser, index);

      }
    });

  }

  void _addCurrentUserToFollowingList(AmigosFollowRequestUser followRequestUser, int index) async {

    /*

      * 1. Add user to current user's follower list
      *
      * 2. Add current user to to followedBy user's following list
      *
      * 3. Delete user from amigosFollowUser list and update

     */

    AmigosUser amigosUser;

    GetUserBloc().getUserById(FirebaseAuth.instance.currentUser!.uid).then((DocumentSnapshot snapshot) async {
      var data = snapshot.data() as Map<String, dynamic>;
      amigosUser = AmigosUser.fromJson(data);

      FollowingDetails followingDetails = FollowingDetails(
          amigosUser.userId,
          amigosUser.fullName,
          amigosUser.username,
          amigosUser.profileImg
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(followRequestUser.userId)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if(snapshot.exists){
          var data = snapshot.data() as Map<String, dynamic>;
          var followingList = AmigosUser.fromJson(data);

          print("Followers Lsit: ${followingList.following}");

          if(followingList.following.isEmpty){

            followingList.following.add(followingDetails);

            print("Followers Lsit: ${followingList.following}");

            await FirebaseFirestore.instance
                .collection('users')
                .doc(followRequestUser.userId)
                .update({
              'following': List.of([
                {
                  'userId': followingDetails.userId,
                  'fullName': followingDetails.fullName,
                  'username': followingDetails.username,
                  'profileImg': followingDetails.profileImg
                }
              ])
            });

          } else {

            followingList.following.add(FollowingDetails(
              followingDetails.userId,
              followingDetails.fullName,
              followingDetails.username,
              followingDetails.profileImg,
            ).toJson());

            print(followingList.following);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(followRequestUser.userId)
                .update({
              'following': followingList.following
            });

          }

          _deleteFollowRequestFromUser(index);

        }
      });

    });

  }



}
