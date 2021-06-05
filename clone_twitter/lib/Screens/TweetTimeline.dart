import 'package:clone_twitter/Screens/Tweet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => sideMenu(),
          icon: Icon(
            CupertinoIcons.line_horizontal_3_decrease_circle_fill,
            size: 40,
            color: Colors.blue,
          ),
        ),
        title: Image.asset(
          "assets/logo.png",
          height: 40,
          width: 40,
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

  sideMenu() {
    return Drawer(
      elevation: 5.0,
      child: Text("This is a drawer"),
    );
  }
}
