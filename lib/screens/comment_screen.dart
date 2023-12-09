import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rohagram/Widget/comment_card.dart';
import 'package:rohagram/resources/firebase_methods.dart';
import 'package:rohagram/utils/colors.dart';
import 'package:rohagram/utils/utils.dart';

import '../models/user.dart';

class CommentScreen extends StatefulWidget {
  final User user;
  final snap;
  const CommentScreen({super.key, required this.user, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postData = widget.snap;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.user.imageUrl
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8, ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${widget.user.username}',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  String status = await FirebaseMethods().postComment(postData['postId'], controller.text, widget.user.uid, widget.user.username, widget.user.imageUrl);

                  if(status == 'success'){
                    if (!context.mounted) return;
                    showToast('Comment posted successfully', context);
                  }

                  else{
                    if (!context.mounted) return;
                    showToast(status, context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8,),
                  child: const Text("Post", style: TextStyle(color: Colors.blueAccent),),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished', descending: true).snapshots(),
        builder: (context, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(snap: snapshots.data!.docs[index]),
          );
        },
      ),
    );
  }
}
