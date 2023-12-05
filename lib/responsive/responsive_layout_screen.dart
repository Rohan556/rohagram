import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohagram/providers/user_provider.dart';
import 'package:rohagram/responsive/mobile_screen_layout.dart';
import 'package:rohagram/responsive/web_screen_layout.dart';
import 'package:rohagram/utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState(){
    super.initState();
    addData();
  }

  addData() async{
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return const WebScreen();
        }
        return const MobileScreen();
      },
    );
  }
}
