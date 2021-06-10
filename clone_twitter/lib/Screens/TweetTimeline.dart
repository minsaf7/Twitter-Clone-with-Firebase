import 'package:clone_twitter/Constants/Constants.dart';
import 'package:clone_twitter/Model/TweetModel.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Screens/Tweet.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:clone_twitter/Widgets/TweerContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  final String currentUserId;
  const Timeline({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List followingsTweet = [];
  bool isLoading = false;

  displayTweets(Tweets tweets, UsersModel auther) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: AllTweets(
          tweets: tweets, auther: auther, currentUserId: widget.currentUserId),
    );
  }

  displayFollowingTweet(String currentUserId) {
    List<Widget> followingTweet = [];
    for (Tweets tweets in followingsTweet) {
      followingTweet.add(
        FutureBuilder<DocumentSnapshot>(
          future: userRef.doc(tweets.authorId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UsersModel auther = UsersModel.fromDoc(snapshot.data!);
              return displayTweets(tweets, auther);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
    }
    return followingTweet;
  }

  setFollowingTweets() async {
    setState(() {
      isLoading = true;
    });

    List followTweets = [];
    followTweets = await DBServices.getFeedTweets(widget.currentUserId);
    if (mounted) {
      setState(() {
        followingsTweet = followTweets;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFollowingTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => sideMenu(),
        //   icon: Icon(
        //     CupertinoIcons.line_horizontal_3_decrease_circle_fill,
        //     size: 40,
        //     color: Colors.blue,
        //   ),
        // ),
        title: Image.asset(
          "assets/logo.png",
          height: 40,
          width: 40,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => Tweet(
                      currentUserId: widget.currentUserId,
                    ))),
        child: Image.asset('assets/tweet1.png'),
        // child: Icon(
        //   CupertinoIcons.pencil_slash,
        //   color: Colors.white,
        //   size: 40.0,
        // ),
      ),
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
            future: userRef.doc(widget.currentUserId).get(),
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
                  Center(
                    child: UserAccountsDrawerHeader(
                        currentAccountPicture: CircleAvatar(
                          backgroundImage:
                              NetworkImage(usersModel.profilePicture),
                        ),
                        accountName: Text(usersModel.lname),
                        accountEmail: Text(usersModel.email)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "This is a Twitter clone application developed using flutter & firebase by Mohamed Misaf, an undergraduate of Coventry University, UK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          // textAlign: TextAlignVertical.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Container(
                    // width: 100,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red),
                    child: TextButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              );
            }),
      ),
      body: RefreshIndicator(
        onRefresh: () => setFollowingTweets(),
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: followingsTweet.isEmpty && isLoading == false
                      ? [
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'There is No New Tweets',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                      : displayFollowingTweet(widget.currentUserId),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  sideMenu() {
    return Drawer(
      elevation: 5.0,
      child: Text("This is a drawer"),
    );
  }
}
