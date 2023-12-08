import 'package:flutter/material.dart';
import 'package:rohagram/screens/add_post_screen.dart';
import 'package:rohagram/screens/feed_screen.dart';

const webScreenSize = 600;

const HomeScreenPages = [
  FeedScreen(),
  Text("search"),
  AddPostScreen(),
  Text("notification"),
  Text("profile"),
];