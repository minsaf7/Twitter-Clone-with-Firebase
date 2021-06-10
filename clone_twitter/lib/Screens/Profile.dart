import 'package:clone_twitter/Constants/Constants.dart';
import 'package:clone_twitter/Model/TweetModel.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Screens/EditProfile.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:clone_twitter/Widgets/TweerContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  int profileSegmentValue = 0;
  bool isFollowing = false;
  List allTweets = [];
  List mediaTweets = [];

  Map<int, Widget> profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Tweets",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Media",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Likes",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  };

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

  allTweetContainer() {}

  buildProfile(UsersModel auther) {
    switch (profileSegmentValue) {
      case 0:
        return ListView.builder(
            itemCount: allTweets.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AllTweets(
                tweets: allTweets[index],
                auther: auther,
                currentUserId: auther.id,
              );
            });
        break;
      case 1:
        return ListView.builder(
            itemCount: mediaTweets.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AllTweets(
                tweets: allTweets[index],
                auther: auther,
                currentUserId: auther.id,
              );
            });
        break;
      case 2:
        return Text(
          "Likes",
          style: TextStyle(fontWeight: FontWeight.bold),
        );
        break;
      default:
        return Text(
          "Something went wrong",
          style: TextStyle(fontWeight: FontWeight.bold),
        );
        break;
    }
  }

  followUnfollow() {
    if (isFollowing) {
      unFollow();
    } else {
      follow();
    }
  }

  follow() {
    DBServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      isFollowing = true;
      followersCount++;
    });
  }

  unFollow() {
    DBServices.unFollowUser(widget.currentUserId, widget.visitedUserId);

    setState(() {
      isFollowing = false;
      followersCount--;
    });
  }

  setupFollowing() async {
    bool isFollowingTHeUser = await DBServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      isFollowing = isFollowingTHeUser;
    });
  }

  getAllTweets() async {
    print("1");
    List userTweets = await DBServices.getUserTweets(widget.currentUserId);
    print("2");
    if (mounted) {
      print("3");
      setState(() {
        allTweets = userTweets;
        mediaTweets =
            userTweets.where((element) => element.image.isNotEmpty).toList();
      });
      print("4");

      if (allTweets.isEmpty) {
        print("Tweets empty");
      } else {
        print(allTweets[0]);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupFollowing();
    getAllTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Profile",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
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
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              //cover image
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: usersModel.coverPicture.isEmpty
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(usersModel.coverPicture),
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox.shrink(),
                      widget.currentUserId != widget.visitedUserId
                          ? IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),

              //profile image
              Container(
                transform: Matrix4.translationValues(0, -40, 0),
                //transform: Matrix4.t,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 45.0,
                          // backgroundImage: usersModel.profilePicture.isNotEmpty ? NetworkImage(usersModel.profilePicture) : Image.asset('assets/placeholder.png'),

                          backgroundImage: usersModel.profilePicture.isEmpty
                              ? null
                              : NetworkImage(usersModel.profilePicture),
                        ),
                        widget.currentUserId != widget.visitedUserId
                            ? GestureDetector(
                                onTap: () => followUnfollow(),
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  // color: Colors.amber,
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? Colors.blue
                                        : Colors.grey[850],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 2.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isFollowing ? "Following" : "Follow",
                                      style: TextStyle(
                                          color: isFollowing
                                              ? Colors.white
                                              : Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                              user: usersModel,
                                            ))),
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  // color: Colors.amber,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 2.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //name

                    Row(
                      children: [
                        Text(
                          usersModel.fname,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " " + usersModel.lname,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    //bio

                    SizedBox(
                      height: 10,
                    ),
                    Text(usersModel.bio),

                    //follow count
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("$followersCount followers"),
                        Text("  $followingCount following"),
                      ],
                    ),
//tabbar
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: profileSegmentValue,
                        thumbColor: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        children: profileTabs,
                        onValueChanged: (int? i) {
                          setState(() {
                            profileSegmentValue = i!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              buildProfile(usersModel)
            ],
          );
        },
      ),
    );
  }
}
