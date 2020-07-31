import 'package:app_test/MainScreen.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/MainScreen.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:flutter/material.dart';
// import 'package:app_test/services/provider.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return SignIn();
    } else {
      return MainMenu();
    }
  }
}
