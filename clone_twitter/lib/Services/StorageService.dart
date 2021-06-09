import 'dart:io';

import 'package:clone_twitter/Constants/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadProfilePic(String url, File fileImage) async {
    print("0");
    String? uniquePhotoId = Uuid().v4();
    print("1");
    File? image = await compressImage(uniquePhotoId, fileImage);
    print("3");
    // if (url.isNotEmpty) {
    //   print("4");
    //   RegExp? exp = RegExp(r'userProfile_(.*).jpg');
    //   print("5");
    //   uniquePhotoId = exp.firstMatch(url)![1];
    // }
    print("6");
    UploadTask uploadTask = storageRef
        .child("images/users/userProfile_$uniquePhotoId.jpg")
        .putFile(fileImage);
    print("7");
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("complete"));
    print("8");
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print("9");
    return downloadUrl;
  }

  static Future<String> uploadPCoverPic(String url, File fileImage) async {
    String? uniquePhotoId = Uuid().v4();
    File? image = await compressImage(uniquePhotoId, fileImage);

    // if (url.isNotEmpty) {
    //   RegExp exp = RegExp(r'userCover_(.*).jpg');
    //   uniquePhotoId = exp.firstMatch(url)![1];
    // }
    UploadTask uploadTask = storageRef
        .child("images/users/userCover_$uniquePhotoId.jpg")
        .putFile(fileImage);

    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("complete"));
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File?> compressImage(String photoId, File image) async {
    final tempDirectory = await getTemporaryDirectory();
    final path = tempDirectory.path;

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, '$path/img_$photoId.jpg',
        quality: 70);

    return compressedImage;
  }

  static Future<String> uploadTweetPic(File fileImage) async {
    String? uniquePhotoId = Uuid().v4();
    File? image = await compressImage(uniquePhotoId, fileImage);

    // if (url.isNotEmpty) {
    //   RegExp exp = RegExp(r'userCover_(.*).jpg');
    //   uniquePhotoId = exp.firstMatch(url)![1];
    // }
    UploadTask uploadTask = storageRef
        .child("images/tweets/tweets_$uniquePhotoId.jpg")
        .putFile(fileImage);

    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("complete"));
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
