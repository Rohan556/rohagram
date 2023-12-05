import 'package:flutter/material.dart';

class Navigation{
  navigateTo(Widget screen,BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => screen),
    );
  }
}

