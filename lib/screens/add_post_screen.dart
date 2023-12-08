import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rohagram/providers/user_provider.dart';
import 'package:rohagram/resources/firebase_methods.dart';
import 'package:rohagram/screens/home_screen.dart';
import 'package:rohagram/utils/colors.dart';
import 'package:rohagram/utils/navigation.dart';
import 'package:rohagram/utils/utils.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  SimpleDialogOption dialogOptions(String optionName, pressedAction) {
    return SimpleDialogOption(
      padding: const EdgeInsets.all(20),
      onPressed: pressedAction,
      child: Text(optionName),
    );
  }

  void handleTakePhoto(ImageSource source) async {
    Navigator.of(context).pop();
    Uint8List file = await pickImage(source);
    setState(() {
      _file = file;
    });
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              dialogOptions(
                  "Take a photo", () => handleTakePhoto(ImageSource.camera)),
              dialogOptions("Choose from gallery",
                  () => handleTakePhoto(ImageSource.gallery)),
              dialogOptions("Cancel", () => Navigator.of(context).pop()),
            ],
          );
        });
  }

  void postImage(String uid, String username, String profImg) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirebaseMethods().uploadPost(
          textEditingController.text, uid, _file!, username, profImg);

      if (res == 'success') {
        if (!context.mounted) return;
        showToast("Posted!", context);
        clearImage();
      }
    } catch (err) {
      if (!context.mounted) return;
      showToast(err.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.imageUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.imageUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
