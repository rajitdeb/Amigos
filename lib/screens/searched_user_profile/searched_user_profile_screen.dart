import 'package:amigos/bloc/follow_user_bloc.dart';
import 'package:amigos/bloc/get_user_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class SearchedUserProfileScreen extends StatefulWidget {
  const SearchedUserProfileScreen({Key? key}) : super(key: key);

  @override
  _SearchedUserProfileScreenState createState() => _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {

  late AmigosUser user;

  int postsCount = 0;

  @override
  void initState() {
    super.initState();
    user = Get.arguments;
    _getTotalPostsCount(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Searched User Profile", style: TextStyle(color: Colors.white),),
        backgroundColor: MyColors.mainColor,
      ),
      body: Container(
        color: MyColors.contentPageColor,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: MyColors.contentPageColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(16.0),
                    color: MyColors.secondColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            user.profileImg != null
                                ? SizedBox(
                              width: 70.0,
                              height: 70.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user.profileImg!),
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
                              children: [
                                Text(
                                  Utils().getFormattedCounts(postsCount),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Posts",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                // Utils().getFormattedCounts(user.followers.length),
                                Utils().getFormattedCounts(1000),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Followers",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Utils().getFormattedCounts(user.following.length),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Following",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "@${user.username}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            user.bio != null
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8.0,
                                ),
                                const Text(
                                  "Bio",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  user.bio != null
                                      ? user.bio!
                                      : "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                                : Container()
                          ],
                        )
                      ],
                    )),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56.0,
                  color: MyColors.mainColor,
                  child: const Center(
                    child: Text(
                      "POSTS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // used expanded widget to give gridview all the available space
                // after the above two containers have occupied
                Expanded(
                    child: FirestoreAnimatedGrid(
                        query: FirebaseFirestore.instance
                            .collection("posts")
                            .where('authorUserId',
                            isEqualTo: user.userId)
                            .orderBy('createdAt', descending: true),
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 2.0,
                        itemBuilder: (BuildContext context,
                            DocumentSnapshot<Object?>? snapshot,
                            Animation<double> animation,
                            int index) {
                          return FadeTransition(
                              opacity: animation,
                              child: _profilePostItemRow(
                                context: context,
                                index: index,
                                document: snapshot,
                              ));
                        })),
              ],
            )),
        ),
      floatingActionButton: user.userId == FirebaseAuth.instance.currentUser!.uid
        ? Container()
        : FloatingActionButton.extended(
          onPressed: () { _followUser(user.userId); },
          backgroundColor: MyColors.accentColor,
          label: const Text(
            "Follow",
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  _profilePostItemRow(
      {required BuildContext context,
        required int index,
        DocumentSnapshot<Object?>? document}) {
    var data = document!.data() as Map<String, dynamic>;
    var post = AmigosUserPosts.fromJson(data);

    return Container(
      color: MyColors.secondColor,
      child: post.postImgLink != null
          ? Image.network(post.postImgLink!)
          : Center(
        child: Text(
          post.postCaption!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _getTotalPostsCount(String userId) async {

    await FirebaseFirestore.instance
        .collection("posts")
        .where('authorUserId', isEqualTo: userId)
        .get()
        .then((value) => setState(() => postsCount = value.size));

    print("POSTS COUNT: $postsCount");

  }

  void _followUser(String userId) async {

      GetUserBloc().getUserById(FirebaseAuth.instance.currentUser!.uid).then((DocumentSnapshot snapshot) {
        var data = snapshot.data() as Map<String, dynamic>;
        AmigosUser user = AmigosUser.fromJson(data);
        AmigosFollowRequestUser followRequestUser =
        AmigosFollowRequestUser(
            user.userId,
            user.fullName,
            user.username,
            user.profileImg
        );
        FollowUserBloc().followUser(context, userId, followRequestUser);
      });


  }

}
