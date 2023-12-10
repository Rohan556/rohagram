import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohagram/providers/user_provider.dart';
import 'package:rohagram/resources/auth_methods.dart';
import 'package:rohagram/resources/firebase_methods.dart';
import 'package:rohagram/utils/colors.dart';
import 'package:rohagram/utils/utils.dart';
import 'package:rohagram/models/user.dart' as current_user;

import '../Widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};
  var postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      setState(() {
        userData = snapshot.data()!;
        followers = snapshot.data()!['followers'].length;
        following = snapshot.data()!['following'].length;
        isFollowing = snapshot.data()!['following'].contains(FirebaseAuth.instance.currentUser!.uid);
      });
      print(snapshot.data()!['following']);
      print(FirebaseAuth.instance.currentUser!.uid);
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();
      setState(() {
        postLen = postSnap.docs.length;
      });
    }catch(err){
      if (!context.mounted) return;
      showToast(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    current_user.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username'] ?? ''),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'] ?? ''
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "Posts"),
                              buildStatColumn(followers, "Followers"),
                              buildStatColumn(following, "Following")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              user.uid == widget.uid ? FollowButton(
                                buttonText: 'Sign Out',
                                backgroundColor: mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: () {
                                  AuthMethods().signoutUser();
                                },
                              ) : isFollowing ? FollowButton(
                                buttonText: 'Unfollow',
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.grey,
                                function: () async{
                                  String status = await FirebaseMethods().handleUserFollow(user.uid, widget.uid, false);
                                  if (!context.mounted) return;
                                  showToast(status, context);
                                  setState(() {
                                    followers = followers - 1;
                                    isFollowing = false;
                                  });
                                },
                              ) : FollowButton(
                                buttonText: 'Follow',
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                borderColor: Colors.blue,
                                  function: () async{
                                    String status = await FirebaseMethods().handleUserFollow(user.uid, widget.uid, true);
                                    if (!context.mounted) return;
                                    showToast(status, context);
                                    setState(() {
                                      followers = followers + 1;
                                      isFollowing = true;
                                    });
                                  },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData['username'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'] ?? '',
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }

              if(snapshot.data!.docs.isEmpty){
                return const Center(
                  child: Text(
                    "No posts yet!"
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                itemBuilder: (context, index){
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  return Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      snap['postUrl'],
                    ),
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
