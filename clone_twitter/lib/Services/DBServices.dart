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
    }).then((value) async {
      QuerySnapshot followerSnapshot = await followersRef
          .doc(userTweets.authorId)
          .collection('Followers')
          .get();

      for (var docSnapshot in followerSnapshot.docs) {
        feedRef.doc(docSnapshot.id).collection('feed').doc(value.id).set({
          'text': userTweets.text,
          'image': userTweets.image,
          "authorId": userTweets.authorId,
          "timestamp": userTweets.timestamp,
          'likes': userTweets.likes,
          'retweets': userTweets.retweets,
        });
      }
    });
  }

  static Future<List> getUserTweets(String userId) async {
    QuerySnapshot tweetSnap = await tweetRef
        // .doc(userId)
        // .collection("tweets")
        .doc(userId)
        .collection("userTweets")
        .orderBy('timestamp', descending: true)
        .get();
    // .orderBy('timestamp', descending: true)
    // .get();

    List<Tweets> userTweets =
        tweetSnap.docs.map((e) => Tweets.fromDoc(e)).toList();
    if (userTweets.isEmpty) {
      print("ERROR");
    }

    return userTweets;
  }

  static Future<List> getFeedTweets(String currentUser) async {
    QuerySnapshot snap = await feedRef
        .doc(currentUser)
        .collection("feed")
        .orderBy("timestamp", descending: true)
        .get();

    List<Tweets> followingTwts =
        snap.docs.map((e) => Tweets.fromDoc(e)).toList();

    return followingTwts;
  }
}
