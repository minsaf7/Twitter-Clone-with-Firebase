import 'package:flutter/material.dart';

class Tweet extends StatefulWidget {
  const Tweet({Key? key}) : super(key: key);

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tweet"),
      ),
    );
  }
}
