import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String imageUrl;

  const User({
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.imageUrl,
    required this.uid,
    required this.username
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "imageUrl": imageUrl,
    "bio": bio,
    "followers": followers,
    "following": following
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      imageUrl: snapshot['imageUrl'] ?? '',
      following: snapshot['following'],
      followers: snapshot['followers'],
      email: snapshot['email'],
      bio: snapshot['bio']
    );
  }
}