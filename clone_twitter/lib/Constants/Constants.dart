import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final firestore = FirebaseFirestore.instance;
final userRef = firestore.collection("users");
final followersRef = firestore.collection("followers");
final followingRef = firestore.collection("followings");
