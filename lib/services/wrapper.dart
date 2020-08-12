import 'package:app_test/MainScreen.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/MainScreen.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/providers/courseProvider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return SignIn();
    } else {
      return MultiProvider(providers: [
        StreamProvider(
            create: (context) =>
                DatabaseMehods().getMyCourses(user.userID)), // get all course
      ], child: MainMenu());
    }
  }
}
