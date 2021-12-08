import 'package:amigos/bloc/get_posts_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/screens/createpost/create_post.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyColors.contentPageColor,
        child: FirestoreAnimatedList(
            query: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("createdAt", descending: true),
            onLoaded: (snapshot) => print("Data Loaded: ${snapshot.size}"),
            emptyChild: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 190.0,
                        height: 190.0,
                        child: Image.asset("images/others/no_results.png")),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "No posts found",
                      style: TextStyle(color: MyColors.secondColor),
                    )
                  ],
                )),
            itemBuilder: (BuildContext context,
                DocumentSnapshot<Object?>? snapshot,
                Animation<double> animation,
                int index) {
              return FadeTransition(
                  opacity: animation,
                  child: _postItemRow(
                    context: context,
                    index: index,
                    document: snapshot,
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreatePost()),
        backgroundColor: MyColors.accentColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  _postItemRow(
      {required BuildContext context,
      required int index,
      DocumentSnapshot<Object?>? document,
      onTap}) {
    var data = document!.data() as Map<String, dynamic>;
    var post = AmigosUserPosts.fromJson(data);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      post.authorProfileImg != null
                          ? Container(
                              width: 50.0,
                              height: 50.0,
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      post.authorProfileImg!)
                              ),
                            )
                          : Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: MyColors.mainColor,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170.0,
                              child: Text(
                                post.authorFullName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: MyColors.mainColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                              width: 170.0,
                              child: Text(
                                "@${post.authorUsername}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: MyColors.mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50.0,
                    child: Text(
                      Utils().getTimeAgo(post.createdAt).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: MyColors.secondColor, fontSize: 13.0),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 1.0),
            post.postCaption != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.postCaption!,
                      style: const TextStyle(
                          color: MyColors.mainColor, fontSize: 14.0),
                    ),
                  )
                : Container(),
            post.postImgLink != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: Image.network(
                      post.postImgLink!,
                      fit: BoxFit.fitHeight,
                    ))
                : Container(),
            const SizedBox(height: 1.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  )),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () { GetPostsBloc().updateLikes(document.id); },
                      child: Icon(
                        Icons.favorite,
                        color: post.likedBy.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Colors.red
                            : Colors.grey[400],
                      )),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    post.likedBy.length.toString(),
                    style: const TextStyle(
                        color: MyColors.secondColor, fontSize: 18.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
