import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/my_pages/start_login.dart';
import 'package:app_test/services/auth.dart';

class Wrapper extends StatelessWidget {
  final bool reset;
  // Constructor, with syntactic sugar for assignment to members.
  Wrapper(this.reset) {
    // Initialization code goes here.
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // AuthMethods
    authMethods = new AuthMethods();
    print('wrapper called');

    // return either the Home or Authenticate widget
    if (user == null) {
      return SignIn();
      // StartLoginPage();
    }
    // else if (user != null || reset) {
    //   return MultiProvider(providers: [
    //     StreamProvider(
    //         create: (context) => DatabaseMehods()
    //             .userDetails(user.userID)), //Login user data details
    //     // authMethods.isUserLogged().then((value) => null);
    //     StreamProvider(
    //         create: (context) =>
    //             DatabaseMehods().getMyCourses(user.userID)), // get all course
    //     StreamProvider(
    //         create: (context) => UserDatabaseService()
    //             .getMyContacts(user.userID)), // get all contacts
    //     FutureProvider(
    //         create: (context) => DatabaseMehods().getAllTage(user.userID)),
    //   ], child: StartPage()

    //       // FriendProfile(
    //       //   userID: user.userID, // to be modified to friend's ID
    //       // ),
    //       );
    // }
    else {
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
      ], child: reset ? StartPage() : MainMenu()

          // FriendProfile(
          //   userID: user.userID, // to be modified to friend's ID
          // ),
          );
    }
  }
}
