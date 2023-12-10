import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rohagram/screens/profile_screen.dart';
import 'package:rohagram/utils/colors.dart';

import '../models/user.dart';
import '../utils/navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  bool isShowUsers = false;
  List<User> users = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Search for user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isLessThanOrEqualTo: controller.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: (){
                      Navigation().navigateTo(ProfileScreen(uid: snapshot.data!.docs[index]!['uid']), context);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]!['photoUrl']! ?? ''),
                      ),
                      title: Text(snapshot.data!.docs[index]['username'] ?? ''),
                    ),
                  ),
                );
              },
            )
          : const Center(
        child: Text("No searched users yet"),
      ),
    );
  }
}
