import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;

  static Future<bool> signUp(
      String fname, String lname, String email, String pword) async {
    print("0");
    try {
      // UserCredential result = await auth.createUserWithEmailAndPassword(
      //     email: email, password: pword);

      print("1");
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: pword);
      print("2");
      print("email: " + email);
      print("pword: " + pword);

      User? signedUser = result.user;
      print("3");
      if (signedUser != null) {
        firestore.collection("users").doc(signedUser.uid).set({
          "first name": fname,
          "last name": lname,
          "email": email,
          "profile picture": "",
        });
        print("Done");
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
