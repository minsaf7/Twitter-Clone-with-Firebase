import 'package:cloud_firestore/cloud_firestore.dart';

class Tweets {
  late String id;
  late String authorId;
  late String text;
  late String image;
  late Timestamp timestamp;
  late int likes;
  late int retweets;

  Tweets(
      {this.id = "",
      required this.authorId,
      required this.text,
      required this.image,
      required this.timestamp,
      required this.likes,
      required this.retweets});

  factory Tweets.fromDoc(DocumentSnapshot doc) {
    return Tweets(
      id: doc.id,
      authorId: doc["authorId"],
      text: doc["text"],
      image: doc["image"],
      timestamp: doc["timestamp"],
      likes: doc["likes"],
      retweets: doc["retweets"],
    );
  }
}
