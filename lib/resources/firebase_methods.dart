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

  Future<void> likePost(String postId, String uid, List likes, bool onPost) async{
    try{
      if(likes.contains(uid)){
        if(onPost) {
          return;
        }
        await _store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      }else{
        await _store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    }catch(err){
      print(err.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async{
    print("coming");
    String status = "Some error occured";
    try{
      if(text.isNotEmpty){
        String commendId = const Uuid().v1();
        await _store.collection('posts').doc(postId).collection('comments').doc(commendId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commendId,
          'datePublished': DateTime.now()
        });
        status = 'success';
      }else{
        print("No Text");
      }
    }catch(err){
      status = err.toString();
    }

    return status;
  }
  
  //Deleting a post

  Future<String> deleteAPost(String postId) async{
    String status = "Something went wrong";
    
    try{
      await _store.collection('posts').doc(postId).delete();
      status = "success";
    }catch(err){
      status = err.toString();
    }
    
    return status;
  }
}
