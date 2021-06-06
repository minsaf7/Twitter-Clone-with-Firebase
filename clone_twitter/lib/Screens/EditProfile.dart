import 'dart:io';

import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:flutter/material.dart';

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

  File profileImage = File("assets/placeholder.png");
  late File coverImage = File("assets/placeholder.png");

  late String imagePickedType;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

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
                    image: DecorationImage(image: AssetImage("assets/blue.jpg"))
                    // image: coverImage.toString().isEmpty &&
                    //         widget.user.coverPicture.isEmpty
                    //     ? null
                    //     : DecorationImage(
                    //         fit: BoxFit.cover,
                    //         image: displayCoverImage(),
                    //       ),
                    ),
              ),

              //edit profile pic
              Container(
                height: 150,
                color: Colors.grey[200],
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
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            transform: Matrix4.translationValues(0, -40, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                        radius: 45.0,
                        // backgroundImage: usersModel.profilePicture.isNotEmpty ? NetworkImage(usersModel.profilePicture) : Image.asset('assets/placeholder.png'),

                        backgroundImage: displayProfileImage()),
                    GestureDetector(
                      // onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => EditProfile(
                      //               user: usersModel,
                      //             ))),
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
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  displayCoverImage() {}
  displayProfileImage() {
    if (profileImage == null) {
      if (widget.user.profilePicture.isEmpty) {
        return AssetImage("assets/placeholder.png");
      } else {}
    } else {
      return FileImage(profileImage);
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
