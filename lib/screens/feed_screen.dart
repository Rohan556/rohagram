import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rohagram/Widget/post_card.dart';
import 'package:rohagram/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor, height: 32,),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.messenger_outline,),)
        ],
      ),
      body: PostCard(),
    );
  }
}
