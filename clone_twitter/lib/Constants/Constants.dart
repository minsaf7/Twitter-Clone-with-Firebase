import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = FirebaseFirestore.instance;
final userRef = firestore.collection("users");
final followersRef = firestore.collection("followers");
final followingRef = firestore.collection("followings");
final storageRef = FirebaseStorage.instance.ref();
final tweetRef = firestore.collection("tweets");
final feedRef = firestore.collection("feed");
final likesRef = firestore.collection("likes");
