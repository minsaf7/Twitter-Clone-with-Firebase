import 'dart:io';

import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:clone_twitter/Services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;

class EditProfile extends StatefulWidget {
  final UsersModel user;
  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String fname = "";
  late String lname = "";
  late String bio = "";

  late File profileImage = File(
      "/data/user/0/com.example.clone_twitter/cache/image_picker9179270098455350113.jpg");
  late File coverImage = File(
      "/data/user/0/com.example.clone_twitter/cache/image_picker9179270098455350113.jpg");

  late String imagePickedType;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fname = widget.user.fname;
    lname = widget.user.lname;
    bio = widget.user.bio;
    // coverImage = File("");
    // profileImage = File("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // image: NetworkImage(widget.user.coverPicture),
                    image: displayCoverImage(),
                  ),
                ),
              ),

              // edit cover pic
              GestureDetector(
                onTap: () {
                  setState(() {
                    imagePickedType = "cover";
                  });
                  handleImageFromGallery();
                },
                child: Container(
                  height: 150,
                  // color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70.0,
                        color: Colors.grey[850],
                      ),
                      Text(
                        "Change cover pic",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          //profile image
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            transform: Matrix4.translationValues(0, -40, 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imagePickedType = "profile";
                });
                handleImageFromGallery();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 45.0,
                              backgroundImage: displayProfileImage()
                              // NetworkImage(widget.user.profilePicture),
                              ),
                          CircleAvatar(
                            radius: 30.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Icon(Icons.camera_alt)),
                                Text(
                                  "Select image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => savePic(),
                        child: Container(
                          height: 35,
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // color: Colors.amber,
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2.0,
                              color: Colors.blue,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //first name
                          TextFormField(
                            initialValue: fname,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            validator: (input) => input!.trim().length < 2
                                ? 'please enter valid name'
                                : null,
                            onSaved: (value) {
                              fname = value!;
                            },
                          ),

                          //last name
                          TextFormField(
                            initialValue: lname,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            validator: (input) => input!.trim().length < 2
                                ? 'please enter valid last name'
                                : null,
                            onSaved: (value) {
                              lname = value!;
                            },
                          ),

                          //bio
                          SizedBox(height: 30),
                          TextFormField(
                            initialValue: bio,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            onSaved: (value) {
                              bio = value!;
                            },
                          ),
                          //email
                          SizedBox(height: 30),
                          Text(widget.user.email),
                          //indicator
                          SizedBox(height: 30),
                          isLoading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  displayCoverImage() {
    if (coverImage.path.isEmpty) {
      if (widget.user.coverPicture.isEmpty) {
        return AssetImage("assets/blue.png");
      } else {
        return NetworkImage(widget.user.coverPicture);
      }
    } else {
      return FileImage(coverImage);
    }

    // return AssetImage(widget.user.coverPicture);
  }

  displayProfileImage() {
    if (profileImage.path.isEmpty) {
      if (widget.user.profilePicture.isEmpty) {
        return AssetImage("assets/blue.png");
      } else {
        return NetworkImage(widget.user.profilePicture);
      }
    } else {
      return FileImage(profileImage);
    }
  }

  handleImageFromGallery() async {
    // try {
    //   final imagePicker = ImagePicker();
    //   PickedFile? imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    // } catch (e) {}
    print(imagePickedType);
    try {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        if (imagePickedType == 'profile') {
          setState(() {
            //profileImage = pickedImage;
            profileImage = File(pickedImage.path);
          });
        } else if (imagePickedType == 'cover') {
          setState(() {
            coverImage = File(pickedImage.path);
          });
          print(coverImage.path);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  savePic() async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });

      String profileUrl = "";
      String coverUrl = "";

      if (profileImage.path.isEmpty) {
        profileUrl = widget.user.profilePicture;
      } else {
        profileUrl = await StorageService.uploadProfilePic(
            widget.user.profilePicture, profileImage);
      }

      if (coverImage.path.isEmpty) {
        coverUrl = widget.user.coverPicture;
      } else {
        coverUrl = await StorageService.uploadPCoverPic(
            widget.user.coverPicture, coverImage);
      }
      UsersModel users = UsersModel(
        id: widget.user.id,
        bio: bio,
        coverPicture: coverUrl,
        email: widget.user.email,
        fname: fname,
        lname: lname,
        profilePicture: profileUrl,
      );

      DBServices.updateData(users);
      Navigator.pop(context);
    }
  }
  // saveProfile() async {
  //   formKey.currentState!.save();
  //   if (formKey.currentState!.validate() && !isLoading) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     String profilePictureUrl = '';
  //     String coverPictureUrl = '';
  //     if (profileImage == null) {
  //       profilePictureUrl = widget.user.profilePicture;
  //     } else {
  //       profilePictureUrl = await StorageService.uploadProfilePicture(
  //           widget.user.profilePicture, profileImage);
  //     }
  //     if (coverImage == null) {
  //       coverPictureUrl = widget.user.coverPicture;
  //     } else {
  //       coverPictureUrl = await StorageService.uploadCoverPicture(
  //           widget.user.coverPicture, coverImage);
  //     }
  //     UsersModel user = UsersModel(
  //       id: widget.user.id,
  //       fname: fname,
  //       lname: lname,
  //       profilePicture: profilePictureUrl,
  //       bio: bio,
  //       coverPicture: coverPictureUrl,
  //        email: widget.user.email,
  //     );

  //     DBServices.updateUserData(user);
  //     Navigator.pop(context);
  //   }
  // }
}
