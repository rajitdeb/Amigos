import 'package:amigos/screens/bottombar/follow_requests.dart';
import 'package:amigos/screens/bottombar/home.dart';
import 'package:amigos/screens/bottombar/profile.dart';
import 'package:amigos/themes/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  var screens = [const Home(), const FollowRequests(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Amigos", style: TextStyle(color: Colors.white),),
        backgroundColor: MyColors.mainColor,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.white,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout, color: Colors.white,)),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyColors.contentPageColor,
        child: screens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: MyColors.mainColor,
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Requests"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
          ),
        ],
      ),
    );
  }
}
