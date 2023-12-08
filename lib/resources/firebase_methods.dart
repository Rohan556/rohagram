import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rohagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirebaseMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String uid, Uint8List file, String username, String profImg) async{
    String res = 'some error occured';

    try{
      String photoUrl = await StorageMethods().uploadToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        postUrl: photoUrl,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profImg: profImg,
        likes: []
      );

      _store.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    }catch(err){
      res = err.toString();
    }

    return res;
  }
}
