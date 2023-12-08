import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
   final String description;
   final String uid;
   final String username;
   final String postId;
   final DateTime datePublished;
   final String postUrl;
   final String profImg;
   final List likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImg,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'uid': uid,
    'username': username,
    'postId': postId,
    'datePublished': datePublished,
    'postUrl': postUrl,
    'profImg': profImg,
    'likes': likes
  };

  static Post fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
      username: snap['username'],
      uid: snap['uid'],
      description: snap['description'],
      postId: snap['postId'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      profImg: snap['profImg'],
      likes: snap['likes']
    );
  }
}