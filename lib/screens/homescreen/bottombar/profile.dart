import 'dart:io';
import 'package:amigos/bloc/create_user_bloc.dart';
import 'package:amigos/bloc/get_user_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/utils/utils.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AmigosUser? amigosUser;

  File? profileImg;

  int postsCount = 0;

  @override
  void initState() {
    super.initState();
    _getTotalPostsCount();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyColors.contentPageColor,
        child: amigosUser == null
            ? Container(
                width: 25.0,
                height: 25.0,
                color: MyColors.contentPageColor,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : Container(
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
                                amigosUser!.profileImg != null
                                    ? SizedBox(
                                        width: 70.0,
                                        height: 70.0,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              amigosUser!.profileImg!),
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
                                      Utils().getFormattedCounts(amigosUser!.followers.length),
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
                                      Utils().getFormattedCounts(amigosUser!.following.length),
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
                                  amigosUser != null
                                      ? "@${amigosUser!.username}"
                                      : "unknown",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  amigosUser != null
                                      ? amigosUser!.fullName
                                      : "unknown",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                amigosUser!.bio != null
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
                                            amigosUser!.bio != null
                                                ? amigosUser!.bio!
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
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings, color: Colors.white),
        backgroundColor: MyColors.accentColor,
        onPressed: () {
          _modalBottomSheetMenu(context);
        },
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        backgroundColor: MyColors.mainColor,
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text("Change profile picture",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // close bottomsheet
                  Navigator.of(context).pop(context);
                  // open profile picture menu
                  _modalProfilePictureBottomSheetMenu(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.block,
                  color: Colors.white,
                ),
                title: const Text("Delete Account",
                    style: TextStyle(color: Colors.white)),
                onTap: () => print("Profile Picture Changed!"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                title: const Text("Account Settings",
                    style: TextStyle(color: Colors.white)),
                onTap: () => print("Profile Picture Changed!"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.help,
                  color: Colors.white,
                ),
                title: const Text("Help and Support",
                    style: TextStyle(color: Colors.white)),
                onTap: () => print("Profile Picture Changed!"),
              ),
            ],
          );
        });
  }

  void _modalProfilePictureBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        backgroundColor: MyColors.mainColor,
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                title: const Text("Take a Photo",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  print("Taking Photo using Camera ...");
                  Navigator.of(context).pop(context);
                  _getUserPhoto(ImageSource.camera);
                  _modaluploadBottomSheetMenu(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                title: const Text("Choose from Gallery",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  print("Choosing Photo from Gallery ...");
                  Navigator.of(context).pop(context);
                  _getUserPhoto(ImageSource.gallery);
                  _modaluploadBottomSheetMenu(context);
                },
              ),
            ],
          );
        });
  }

  void _modaluploadBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        backgroundColor: MyColors.mainColor,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Change Profile Picture",
                            style: TextStyle(
                                color: MyColors.secondColor,
                                fontWeight: FontWeight.normal,
                              fontSize: 15.0
                            ),
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                          width: 70.0,
                          height: 70.0,
                          child: CircleAvatar(
                              backgroundImage: FileImage(profileImg!))),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: MaterialButton(
                                height: 50.0,
                                onPressed: () {
                                  _modalProfilePictureBottomSheetMenu(context);
                                },
                                color: MyColors.accentColor,
                                child: const Center(
                                    child: Text("RETAKE",
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: MaterialButton(
                                height: 50.0,
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                  CreateUserBloc().uploadProfilePicture(profileImg!);
                                  mySnackBar(context, "Your profile picture is being uploaded. Please wait...");
                                },
                                color: MyColors.accentColor,
                                child: const Center(
                                    child: Text("UPLOAD",
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  Future<void> _getUserPhoto(ImageSource source) async {
    final _picker = ImagePicker();
    switch (source) {
      case ImageSource.camera:
        {
          final XFile? image =
              await _picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            profileImg = File(image.path);
            Navigator.of(context).pop(context);
            _modaluploadBottomSheetMenu(context);
          }
          break;
        }

      case ImageSource.gallery:
        {
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            profileImg = File(image.path);
            Navigator.of(context).pop(context);
            _modaluploadBottomSheetMenu(context);
          }
          break;
        }
    }
  }

  void _loadUserProfile() {
    final data =
        GetUserBloc().getUserById(FirebaseAuth.instance.currentUser!.uid);

    data.then((DocumentSnapshot snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() => amigosUser = AmigosUser.fromJson(data));
    });
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

  void _getTotalPostsCount() async {

    await FirebaseFirestore.instance
        .collection("posts")
        .where('authorUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => setState(() => postsCount = value.size));

    print("POSTS COUNT: $postsCount");

  }
}
