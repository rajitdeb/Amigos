import 'package:amigos/bloc/search_users_bloc.dart';
import 'package:amigos/model/user.dart';
import 'package:amigos/screens/homescreen/searched_user_profile_screen.dart';
import 'package:amigos/themes/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUsers extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isNotEmpty
        ? Container(
            color: MyColors.contentPageColor,
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: FirestoreAnimatedList(
              query: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('fullName')
                  .startAt([query]).endAt([query + 'z']),
              itemBuilder: (BuildContext context,
                      DocumentSnapshot<Object?>? snapshot,
                      Animation<double> animation,
                      int index) =>
                  _usersItemRow(snapshot, index),
            ),
          )
        : Container(
            color: MyColors.contentPageColor,
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: MyColors.contentPageColor,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: MyColors.mainColor, // affects AppBar's background color
        actionsIconTheme: IconThemeData(
            color: Colors
                .white // affects action Icons like (Search, back button) in AppBar
            ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: InputBorder.none,
          // affects the Underline Border of Search Bar; in Focus
          border:
              InputBorder.none // affects when Search Bar is in searched state
          ),
      hintColor: Colors.grey,
      // affects the initial 'Search' text
      textTheme: const TextTheme(
          headline6: TextStyle(
              // headline 6 affects the query text
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor:
              Colors.white), // affects when the text in Search Bar is selected
    );
  }

  _usersItemRow(DocumentSnapshot<Object?>? snapshot, int index) {
    var data = snapshot!.data() as Map<String, dynamic>;
    var user = AmigosUser.fromJson(data);

    return GestureDetector(
      onTap: () { Get.to(() => SearchedUserProfileScreen(), arguments: user); },
      child: Card(
        color: MyColors.secondColor,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              user.profileImg != null
                  ? SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImg!)
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

              SizedBox(width: 8.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120.0,
                      child: Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          "@${user.username}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                          )
                      )
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }



}
