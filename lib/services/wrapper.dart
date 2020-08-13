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
import 'package:app_test/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // AuthMethods authMethods = new AuthMethods();

    // return either the Home or Authenticate widget\
    var a = user.userID;
    print('$a');
    if (user == null) {
      return SignIn();
    } else {
      return MultiProvider(providers: [
        // authMethods.isUserLogged().then((value) => null);
        StreamProvider(
            create: (context) =>
                DatabaseMehods().getMyCourses(user.userID)), // get all course
      ], child: MainMenu());
    }
  }
}
