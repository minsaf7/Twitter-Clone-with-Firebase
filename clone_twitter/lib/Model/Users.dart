import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  late String email;
  late String fname;
  late String lname;
  late String profilePicture;
  late String coverPicture;
  late String id;
  late String bio;

  UsersModel({
    required this.bio,
    required this.coverPicture,
    required this.email,
    required this.id,
    required this.fname,
    required this.lname,
    required this.profilePicture,
  });

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      bio: doc['bio'],
      coverPicture: doc['cover picture'],
      email: doc['email'],
      id: doc.id,
      fname: doc['first name'],
      lname: doc['last name'],
      profilePicture: doc['profile picture'],
    );
  }
}
