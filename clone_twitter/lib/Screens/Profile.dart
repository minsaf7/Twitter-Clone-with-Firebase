import 'package:clone_twitter/Constants/Constants.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const Profile(
      {Key? key, required this.currentUserId, required this.visitedUserId})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int followersCount = 0;
  int followingCount = 0;

  getFollowersCount() async {
    int _followersCount = await DBServices.followersNum(widget.visitedUserId);

    if (mounted) {
      setState(() {
        followersCount = _followersCount;
      });
    }
  }

  getFollowingCount() async {
    int _followingCount = await DBServices.followingNum(widget.visitedUserId);

    if (mounted) {
      setState(() {
        followingCount = _followingCount;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowersCount();
    getFollowingCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userRef.doc(widget.visitedUserId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            );
          }
          UsersModel usersModel = UsersModel.fromDoc(snapshot.data!);
          return ListView(
            children: [
              Text(usersModel.fname),
            ],
          );
        },
      ),
    );
  }
}
