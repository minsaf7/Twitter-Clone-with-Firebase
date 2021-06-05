import 'package:clone_twitter/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServices {
  static Future<int> followersNum(String userID) async {
    QuerySnapshot followers =
        await followersRef.doc(userID).collection("userFollowers").get();

    return followers.docs.length;
  }

  static Future<int> followingNum(String userID) async {
    QuerySnapshot followers =
        await followingRef.doc(userID).collection("userFollowing").get();

    return followers.docs.length;
  }
}
