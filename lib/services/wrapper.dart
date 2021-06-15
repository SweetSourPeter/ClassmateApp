import 'dart:async';

import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/MainMenu.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/redirect.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:app_test/web_initial_pages/web_whole.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/my_pages/start_login.dart';
import 'package:app_test/services/auth.dart';

class Wrapper extends StatelessWidget {
  final bool reset;
  final bool needRedirect;
  final String classid;
  // Constructor, with syntactic sugar for assignment to members.
  Wrapper(this.reset, this.needRedirect, this.classid) {
    // Initialization code goes here.
  }
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print("user 1111");
    print(user);
    // AuthMethods
    authMethods = new AuthMethods();
    print('wrapper called');
    if (user == null) {
      print('user Is null');
      // return NavPage();
      return StartLoginPage();
    } else if (this.needRedirect == true) {
      Future<UserData> userData =
          databaseMethods.getUserDetailsByID(user.userID);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: Future.wait([userData]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              // return either the Home or Authenticate widget
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
                                .getMyContacts(
                                    user.userID)), // get all contacts
                        FutureProvider(
                            create: (context) =>
                                DatabaseMethods().getAllTage(user.userID)),
                      ],
                      // child: (user.email == null)
                      //     ? Center(
                      //         child: CircularProgressIndicator(
                      //         backgroundColor: themeOrange,
                      //       ))
                      //     : GroupChat(
                      //         courseId: classid,
                      //         myEmail: user.email,
                      //         myName: user.userName,
                      //         initialChat: 0,
                      //         isRedirect: true,
                      //       )
                      child: RedirectPage(
                        courseId: classid,
                      )

                      // child: GroupChat(
                      //   courseId: classid,
                      //   myEmail: user.email,
                      //   myName: user.userName,
                      //   initialChat: 0,
                      //   isRedirect: true,
                      // )

                      // child: switch (user.email) {
                      //   case null {
                      //     Center(
                      //     child: CircularProgressIndicator(
                      //     backgroundColor: themeOrange,
                      //     ));
                      //     break;
                      //   }
                      //   default:
                      //     GroupChat(
                      //       courseId: classid,
                      //       myEmail: user.email,
                      //       myName: user.userName,
                      //       initialChat: 0,
                      //       isRedirect: true,
                      //     ),
                      // }
                      );
              }
            }),
      );
    } else {
      Future<UserData> userData =
          databaseMethods.getUserDetailsByID(user.userID);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: Future.wait([userData]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              // return either the Home or Authenticate widget
              print('user exist called');
              print(reset);
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
                                .getMyContacts(
                                    user.userID)), // get all contacts
                        FutureProvider(
                            create: (context) =>
                                DatabaseMethods().getAllTage(user.userID)),
                      ],
                      child: (snapshot.data[0].profileColor == null)
                          ? StartPage()
                          : MainMenu()
                      // FriendProfile(
                      //   userID: user.userID, // to be modified to friend's ID
                      // ),
                      );
              }
            }),
      );
    }
  }
}

Future delay() async {
  await new Future.delayed(new Duration(seconds: 1));
}
