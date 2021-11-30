import 'package:amigos/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.contentPageColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: MyColors.secondColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("images/others/github_profile.jpg"),
                      ),
                    ),
                    Column(
                      children: const [
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Posts",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: const [
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: const [
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
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
              ),

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
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                    itemCount: 50,
                    itemBuilder: (context, index) {
                      return Container(
                        color: MyColors.secondColor,
                        child: Center(child: Text(index.toString())),
                      );
                    }),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings, color: Colors.white),
        backgroundColor: MyColors.accentColor,
        onPressed: () {
          // Get.bottomSheet();
          _modalBottomSheetMenu(context);
        },
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
            height: 150.0,
            color: MyColors.mainColor,
            child: InkWell(
              child: Material(
                color: MyColors.mainColor,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Choose", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          );
        });
  }
}
