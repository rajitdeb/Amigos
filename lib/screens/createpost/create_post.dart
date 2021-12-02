import 'dart:io';
import 'package:amigos/bloc/create_post_bloc.dart';
import 'package:amigos/bloc/get_user_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/screens/homescreen/home_screen.dart';
import 'package:amigos/themes/styles.dart';
import 'package:amigos/widgets/snackbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  TextEditingController captionController = TextEditingController();

  String? imgUriValue;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post", style: TextStyle(color: Colors.white),),
        backgroundColor: MyColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: isLoading == true
        ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.mainColor,
          child: Center(child: CircularProgressIndicator(color:Colors.white),),
        )
        : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          color: MyColors.contentPageColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                child: TextField(
                  controller: captionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  cursorColor: MyColors.secondColor,
                  style: const TextStyle(color: MyColors.secondColor),
                  decoration: const InputDecoration(
                      labelText: "Caption",
                      floatingLabelStyle: TextStyle(color: MyColors.secondColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColors.secondColor,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColors.secondColor,
                              width: 2.0,
                              style: BorderStyle.solid))),
                ),
              ),

              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    minWidth: 70.0,
                    height: 70.0,
                    color: MyColors.mainColor,
                    child: const Icon(Icons.photo, color: Colors.white),
                    onPressed: () => _selectAPictureFromStorage(context),
                  ),

                  const SizedBox(width: 30.0,),

                  Expanded(
                    child: Container(
                      height: 150.0,
                      decoration: imgUriValue == null
                      ? BoxDecoration(
                          color: MyColors.mainColor,
                          borderRadius: BorderRadius.circular(16.0),
                      )
                      : BoxDecoration(
                        color: MyColors.mainColor,
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(imgUriValue!))
                        )
                      ),
                      child: imgUriValue == null
                      ? const Center(
                        child: Text(
                          "No image selected",
                          style: TextStyle(color: MyColors.secondColor),
                        ),
                      )
                     : Container()
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16.0),

              MaterialButton(
                onPressed: () {
                  print("post clicked!");
                  _validateAndCreatePost(context);
                },
                minWidth: MediaQuery.of(context).size.width,
                height: 50.0,
                color: MyColors.accentColor,
                child: const Text("POST", style: TextStyle(color: Colors.white),),
              )

            ],
          ),
        ),
      ),
    );
  }

  _validateAndCreatePost(BuildContext context) async {

    setState(() => isLoading = true);

    String postCaption = captionController.text.toString().trim();

    AmigosUser user = await GetUserBloc()
        .getUserById(FirebaseAuth.instance.currentUser!.uid)
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return AmigosUser.fromJson(data);
    });

    if(postCaption.isNotEmpty){

      if(imgUriValue != null){
        // Add Post Image to Firebase Storage
        final url = await CreatePostBloc().uploadPostImgToFirebaseStorage(imgUriValue!);
        _uploadPostToFirestore(postCaption, url, user);
      } else {
        _uploadPostToFirestore(postCaption, null, user);
      }

    } else {
      if(imgUriValue != null){
        // Add Post Image to Firebase Storage
        final url = await CreatePostBloc().uploadPostImgToFirebaseStorage(imgUriValue!);
        _uploadPostToFirestore(postCaption, url, user);
      } else {
        setState(() => isLoading = false);
        mySnackBar(context, "Both caption and image cannot be null.");
      }
    }

  }

  Future _selectAPictureFromStorage(BuildContext context) async {

    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() => imgUriValue = image?.path);

    mySnackBar(context, "${image?.path}");
  }

  _uploadPostToFirestore(String? postCaption, String? postImgUrl, AmigosUser user) async{
    AmigosUserPosts post = AmigosUserPosts(
        postCaption,
        postImgUrl,
        user.fullName,
        user.userId,
        user.profileImg,
        user.username,
        DateTime.now().millisecondsSinceEpoch,
        List.empty()
    );

    CreatePostBloc().createPost(post);

    mySnackBar(context, "Post Uploaded");

    Get.offAll(() => const HomeScreen());
  }

}
