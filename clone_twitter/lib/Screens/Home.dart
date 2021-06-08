import 'package:clone_twitter/Screens/Notification.dart';
import 'package:clone_twitter/Screens/Profile.dart';
import 'package:clone_twitter/Screens/Search.dart';
import 'package:clone_twitter/Screens/TweetTimeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String currentUserId;
  const Home({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  // List screens = [
  //   Timeline(),
  //   Search(),
  //   Notifications(),
  //   Profile(
  //     currentUserId: widget.currentUserId,
  //     visitedUserId: widget.currentUserId,
  //   ),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: screens[selectedIndex],
      body: [
        Timeline(
          currentUserId: widget.currentUserId,
        ),
        Search(
          currentUserId: widget.currentUserId,
        ),
        Notifications(
          currentUserId: widget.currentUserId,
        ),
        Profile(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
      ].elementAt(selectedIndex),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          print("object");
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
          ),
        ],
      ),
    );
  }
}
