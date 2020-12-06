import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/MainScreen.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/chat_pages/chatRoom.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // AuthMethods authMethods = new AuthMethods();
    // AuthMethods
    authMethods = new AuthMethods();
    print('wrapper called');

    // return either the Home or Authenticate widget\
    if (user == null) {
      return SignIn();
    } else {
      return MultiProvider(providers: [
        StreamProvider(
            create: (context) => DatabaseMethods()
                .userDetails(user.userID)), //Login user data details
        // authMethods.isUserLogged().then((value) => null);
        StreamProvider(
            create: (context) =>
                DatabaseMethods().getMyCourses(user.userID)), // get all course
        StreamProvider(
            create: (context) => UserDatabaseService()
                .getMyContacts(user.userID)), // get all contacts
        FutureProvider(
            create: (context) => DatabaseMethods().getAllTage(user.userID)),
      ], child: MainMenu()

          // FriendProfile(
          //   userID: user.userID, // to be modified to friend's ID
          // ),
          );
    }
  }
}
