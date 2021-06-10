import 'package:clone_twitter/Model/TweetModel.dart';
import 'package:clone_twitter/Model/Users.dart';
import 'package:clone_twitter/Services/DBServices.dart';
import 'package:flutter/material.dart';

class AllTweets extends StatefulWidget {
  final Tweets tweets;
  final UsersModel auther;
  final String currentUserId;
  const AllTweets(
      {Key? key,
      required this.tweets,
      required this.auther,
      required this.currentUserId})
      : super(key: key);

  @override
  _AllTweetsState createState() => _AllTweetsState();
}

class _AllTweetsState extends State<AllTweets> {
  int likeCount = 0;
  bool isLiked = false;

  initLikeTweets() async {
    bool isLikedTweet =
        await DBServices.isLikedTweet(widget.currentUserId, widget.tweets);

    setState(() {
      isLiked = isLikedTweet;
    });
  }

  likeTweets() {
    if (isLiked) {
      DBServices.unLikeTweets(widget.currentUserId, widget.tweets);
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      DBServices.likeTweets(widget.currentUserId, widget.tweets);
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLikeTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    // backgroundImage:  NetworkImage(widget.auther.profilePicture),
                    backgroundImage: NetworkImage(widget.auther.profilePicture),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.auther.lname,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.tweets.text,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 10,
              ),
              widget.tweets.image.isNotEmpty
                  ? Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(widget.tweets.image),
                              fit: BoxFit.cover)),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: likeTweets,
                          icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border),
                          color: isLiked ? Colors.red : Colors.blue,
                        ),
                        Text(
                          widget.tweets.likes.toString(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.repeat),
                        ),
                        Text(
                          widget.tweets.retweets.toString(),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.comment_outlined),
                    ),
                    // Text(widget.tweets.timestamp.toString().substring(0, 19))
                  ],
                ),
              ),
              Divider(
                height: 5,
                thickness: 5.0,
                indent: 5,
                endIndent: 5,
              )
            ],
          )),
    );
  }
}
