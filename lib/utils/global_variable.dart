import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rohagram/screens/add_post_screen.dart';
import 'package:rohagram/screens/feed_screen.dart';
import 'package:rohagram/screens/profile_screen.dart';
import 'package:rohagram/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> HomeScreenPages = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("notification"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];