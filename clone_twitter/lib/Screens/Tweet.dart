import 'package:clone_twitter/Constants/Constants.dart';

import 'package:clone_twitter/Model/TweetModel.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Services/AuthService.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:clone_twitter/Services/StorageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Tweet extends StatefulWidget {
  final String currentUserId;
  const Tweet({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  TextEditingController tweet = new TextEditingController();
  late String tweets;
  bool isLoading = false;
  bool ispicSelected = false;

  late File _pickedImage;
  final picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        ispicSelected = true;
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(ispicSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 40,
          width: 40,
        ),
        centerTitle: true,
        actions: [
          Container(
            child: ispicSelected == true
                ? TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (tweets.isNotEmpty) {
                        print("TWEETS" + tweets);
                        String img;
                        if (ispicSelected = false) {
                          img = "";
                        } else {
                          img =
                              await StorageService.uploadTweetPic(_pickedImage);
                          print(img);
                        }
                        Tweets userTweets = Tweets(
                          authorId: widget.currentUserId,
                          text: tweets,
                          image: img,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          likes: 0,
                          retweets: 0,
                        );

                        // p
                        DBServices.createTweet(userTweets);
                        Navigator.pop(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text("Tweet"),
                  )
                : TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (tweets.isNotEmpty) {
                        print("TWEETS" + tweets);
                        String img = "";

                        Tweets userTweets = Tweets(
                          authorId: widget.currentUserId,
                          text: tweets,
                          image: img,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          likes: 0,
                          retweets: 0,
                        );

                        // p
                        DBServices.createTweet(userTweets);
                        Navigator.pop(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text("Tweet"),
                  ),
          ),
          isLoading ? CircularProgressIndicator() : SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(
                    height: 10,
                  ),

                  // SizedBox(
                  //   width: 10,
                  // ),
                  // CircleAvatar(
                  //   radius: 20.0,
                  //   backgroundImage: NetworkImage(usersModel.profilePicture),
                  // ),
                  // Container(
                  //   height: 40,
                  //   width: 40,
                  //   decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //           image: NetworkImage(usersModel.profilePicture))),
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: Container(
                  //     height: 100,
                  //     width: 300,
                  //     color: Colors.white,
                  //     child: TextField(
                  //       controller: tweet,
                  //       decoration: InputDecoration(
                  //           contentPadding: EdgeInsets.symmetric(
                  //             vertical: 100,
                  //           ),
                  //           border: InputBorder.none,
                  //           hintText: "Whats happening",
                  //           filled: true),
                  //       maxLines: 10,
                  //     ),
                  //   ),
                  // )
                  //Text("Whats inside yur mind"),

                  TextField(
                    controller: tweet,
                    //textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    // maxLines: 10,
                    maxLength: 150,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's happenning?",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(usersModel.profilePicture),
                          ),
                        )),
                    onChanged: (value) {
                      setState(() {
                        tweets = value;
                      });
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Divider(
                    // color: Colors.blue,
                    height: 40,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //alignment: Alignment.center,
                    width: 200,
                    height: 200,
                    //color: Colors.grey[300],
                    child: ispicSelected == true
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: FileImage(_pickedImage),
                              fit: BoxFit.cover,
                            )),
                          )
                        : SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text('Select An Image'),
                      onPressed: _openImagePicker,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text('Clear Image'),
                      onPressed: () {
                        setState(() {
                          // _pickedImage = File("");
                          ispicSelected = false;
                          // _pickedImage = null as File;
                        });
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
