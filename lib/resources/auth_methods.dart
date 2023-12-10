import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rohagram/models/user.dart' as user_model;
import 'package:rohagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser!.uid).get();
    return user_model.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String imageUrl = await StorageMethods().uploadToStorage('profilePic', file, false);

        user_model.User user = user_model.User(
          username: username,
          bio: bio,
          email: email,
          followers: [],
          following: [],
          imageUrl: imageUrl,
          uid: userCredential.user!.uid
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
}) async{
    String result = "";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        UserCredential authenticate = await _auth.signInWithEmailAndPassword(email: email, password: password);
        result = 'success';
      }
    }catch(err){
      result = err.toString();
    }

    return result;
  }

  Future<void> signoutUser() async{
    await _auth.signOut();
  }
}
