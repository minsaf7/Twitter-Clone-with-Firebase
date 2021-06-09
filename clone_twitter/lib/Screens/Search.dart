import 'package:clone_twitter/Constants/Constants.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Screens/Profile.dart';
import 'package:clone_twitter/Screens/Tweet.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String currentUserId;
  const Search({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late String name = "";
  TextEditingController search = new TextEditingController();
  late Future<QuerySnapshot> users = userRef.get();
  //late Future<QuerySnapshot> users = DBServices.searchUsers(name);

  late Future<QuerySnapshot> usersSearch = DBServices.searchUsers(name);

  clearSearch() {
    WidgetsBinding.instance!
        .addPostFrameCallback((timeStamp) => search.clear());
    setState(() {
      // ignore: unnecessary_statements
      users == (null);
    });
  }

  buildUserTile(UsersModel usersModel) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        // backgroundImage: AssetImage("assets/placeholder.png"),
        backgroundImage: NetworkImage(usersModel.profilePicture),
      ),
      title: Text(usersModel.fname),
      subtitle: Text(usersModel.lname),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => Profile(
                currentUserId: widget.currentUserId,
                visitedUserId: usersModel.id)));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // searchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => print("object"),
        //   icon: Icon(
        //     CupertinoIcons.line_horizontal_3_decrease_circle_fill,
        //     size: 40,
        //     color: Colors.blue,
        //   ),
        // ),
        title: Container(
          height: 40,
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.grey[850]),
          child: TextField(
            controller: search,
            cursorColor: Colors.white70,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              contentPadding: EdgeInsets.only(top: 5),
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  search.clear();
                },
                icon: Icon(Icons.clear),
              ),
              filled: true,
            ),
            onChanged: (String input) {
              if (input.isNotEmpty) {
                setState(() {
                  //name = input;
                  print("object");
                  users = DBServices.searchUsers(input);
                  //usersSearch = DBServices.searchUsers(input);
                });
              }
            },
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => Tweet(
                      currentUserId: widget.currentUserId,
                    ))),
        child: Image.asset('assets/tweet1.png'),
        // child: Icon(
        //   CupertinoIcons.pencil_slash,
        //   color: Colors.white,
        //   size: 40.0,
        // ),
      ),
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
            future: userRef.doc(widget.currentUserId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                );
              }
              UsersModel usersModel = UsersModel.fromDoc(snapshot.data!);
              return ListView(
                children: [
                  Center(
                    child: UserAccountsDrawerHeader(
                        currentAccountPicture: CircleAvatar(
                          backgroundImage:
                              NetworkImage(usersModel.profilePicture),
                        ),
                        accountName: Text(usersModel.lname),
                        accountEmail: Text(usersModel.email)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "This is a Twitter clone application developed using flutter & firebase by Mohamed Misaf, an undergraduate of Coventry University, UK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          // textAlign: TextAlignVertical.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Container(
                    // width: 100,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red),
                    child: TextButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              );
            }),
      ),
      body: users == (null)
          ? Container()
          : Container(
              child: FutureBuilder(
                  future: users,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      print("No data");
                      return CircularProgressIndicator();
                    }
                    if (snapshot.data.docs.length == 0) {
                      print(snapshot.data.docs.length.toString());
                      return Text("No users but has data");
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          UsersModel userModel =
                              UsersModel.fromDoc(snapshot.data.docs[index]);
                          return buildUserTile(userModel);
                        });
                  }),
            ),
    );
  }

  Future<QuerySnapshot> searchUser() async {
    Future<QuerySnapshot> user =
        userRef.where('first name', isGreaterThanOrEqualTo: "bill").get();
    print("USER " + user.toString());
    return user;
  }
}
