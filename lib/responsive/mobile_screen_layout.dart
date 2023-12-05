import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohagram/models/user.dart' as user_model;
import 'package:rohagram/providers/user_provider.dart';
import 'package:rohagram/utils/colors.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int page = 0;
  late PageController pageController;

  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  BottomNavigationBarItem BarItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: page == index ? primaryColor : secondaryColor,
      ),
    );
  }

  handlePageChange(int pageNum) {
    pageController.jumpToPage(pageNum);
  }

  handlePageStateChange(int pageNum){
    setState(() {
      page = pageNum;
    });
  }

  @override
  Widget build(BuildContext context) {
    user_model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body:  SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: handlePageStateChange,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text("home"),
            Text("search"),
            Text("add"),
            Text("notification"),
            Text("profile"),
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BarItem(Icons.home, 0),
          BarItem(Icons.search, 1),
          BarItem(Icons.add_circle_outline, 2),
          BarItem(Icons.notifications, 3),
          BarItem(Icons.person, 4)
        ],
        onTap: handlePageChange,
      ),
    );
  }
}
