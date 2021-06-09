import 'dart:ffi';

import 'package:clone_twitter/Constants/Constants.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Model/TweetModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServices {
  static Future<int> followersNum(String userID) async {
    QuerySnapshot followers =
        await followersRef.doc(userID).collection("Followers").get();

    return followers.docs.length;
  }

  static Future<int> followingNum(String userID) async {
    QuerySnapshot followers =
        await followingRef.doc(userID).collection("Followings").get();

    return followers.docs.length;
  }

  static void updateData(UsersModel user) {
    userRef.doc(user.id).update({
      'first name': user.fname,
      'last name': user.lname,
      'bio': user.bio,
      'cover picture': user.coverPicture,
      'profile picture': user.profilePicture,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> user = userRef
        .where('first name', isGreaterThanOrEqualTo: name)
        .get()
        .whenComplete(() => null);
    print("NAME: " + name);

    return user;
  }

  static void followUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection("Followings")
        .doc(visitedUserId)
        .set({});

    followersRef
        .doc(visitedUserId)
        .collection("Followers")
        .doc(currentUserId)
        .set({});
  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection("Followings")
        .doc(visitedUserId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection("Followers")
        .doc(currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection("Followers")
        .doc(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static void createTweet(Tweets userTweets) {
    tweetRef.doc(userTweets.authorId).set({"timeline": userTweets.timestamp});

    final tw = tweetRef.doc(userTweets.authorId).collection("userTweets").add({
      'text': userTweets.text,
      'image': userTweets.image,
      "authorId": userTweets.authorId,
      "timestamp": userTweets.timestamp,
      'likes': userTweets.likes,
      'retweets': userTweets.retweets,
    });
  }
}
