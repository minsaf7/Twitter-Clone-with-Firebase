import 'package:clone_twitter/Screens/Tweet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => print("object"),
          icon: Icon(
            CupertinoIcons.line_horizontal_3_decrease_circle_fill,
            size: 40,
            color: Colors.blue,
          ),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (builder) => Tweet())),
        child: Image.asset('assets/tweet1.png'),
        // child: Icon(
        //   CupertinoIcons.pencil_slash,
        //   color: Colors.white,
        //   size: 40.0,
        // ),
      ),
    );
  }
}
