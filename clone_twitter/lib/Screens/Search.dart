import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

Widget search() {
  return Container(
    height: 40,
    width: 250,
    color: Colors.red,
    child: TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        hintText: "Search",
      ),
    ),
  );
}

class _SearchState extends State<Search> {
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
        // title: TextField(
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(30.0),
        //     ),
        //     hintText: "Search",
        //   ),
        // ),
        title: Container(
          height: 40,
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.grey[850]),
          // color: Colors.red,
          //padding: EdgeInsets.only(top: 10),
          child: TextField(
            cursorColor: Colors.white70,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              contentPadding: EdgeInsets.only(top: 5),
              hintText: "Search",
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
