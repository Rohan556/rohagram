import 'package:flutter/material.dart';
import 'package:rohagram/models/user.dart';
import 'package:rohagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}