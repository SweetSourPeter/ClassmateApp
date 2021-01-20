import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/pages/my_pages/email_verify.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/my_pages/start_login.dart';
import 'package:app_test/services/auth.dart';

class Wrapper extends StatelessWidget {
  final bool verified;
  // Constructor, with syntactic sugar for assignment to members.
  Wrapper(this.verified) {
    // Initialization code goes here.
  }
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // AuthMethods
    authMethods = new AuthMethods();

    if (user == null) {
      // print('user Is null');
      return StartLoginPage();
      // StartLoginPage();
    }
    // else if (!firebaseUser.emailVerified) {
    //   return EmailVerifySent();
    // }
    else {
      Future<UserData> userData =
          databaseMethods.getUserDetailsByID(user.userID);

      return FutureBuilder(
          future: Future.wait([userData]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            // return either the Home or Authenticate widget
            print('user exist called');
            switch (snapshot.connectionState) {
              // Uncompleted State
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: themeOrange,
                ));
                break;
              default:
                // Completed with error
                if (snapshot.hasError)
                  return Center(child: Text(snapshot.error.toString()));
                // Completed with data
                return MultiProvider(
                    providers: [
                      StreamProvider(
                          create: (context) => DatabaseMethods().userDetails(
                              user.userID)), //Login user data details
                      // authMethods.isUserLogged().then((value) => null);
                      StreamProvider(
                          create: (context) => DatabaseMethods()
                              .getMyCourses(user.userID)), // get all course
                      StreamProvider(
                          create: (context) => UserDatabaseService()
                              .getMyContacts(user.userID)), // get all contacts
                      FutureProvider(
                          create: (context) =>
                              DatabaseMethods().getAllTage(user.userID)),
                    ],
                    child: (snapshot.data[0].profileColor == null)
                        ? Container(
                            color: themeOrange,
                            child: SafeArea(child: StartPage()))
                        : Container(
                            color: Colors.white,
                            child: SafeArea(child: MainMenu()))
                    // FriendProfile(
                    //   userID: user.userID, // to be modified to friend's ID
                    // ),
                    );
            }
          });
    }
  }
}
