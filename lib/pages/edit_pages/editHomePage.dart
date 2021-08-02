import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/pages/initialPage/second_page.dart';
import 'package:app_test/pages/initialPage/tagSelectingStepper.dart';
import 'package:app_test/pages/initialPage/third_page.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/pages/edit_pages/editNameModel.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';
import 'package:app_test/pages/my_pages/notification_page.dart';

import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_test/pages/initialPage/emailResend_page.dart';

class EditHomePage extends StatefulWidget {
  @override
  _EditHomePageState createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  AuthMethods authMethods = new AuthMethods();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String nickName;
  double userProfileColor;
  @override
  void initState() {
    super.initState();
    nickName = 'loading';
  }

  String emailVerifiedStatus() {
    var emailStatus;
    if (FirebaseAuth.instance.currentUser != null){
      if (FirebaseAuth.instance.currentUser.emailVerified) {
        emailStatus = 'Verified';
        return emailStatus;
      }else{
        emailStatus = 'Unverified';
        return emailStatus;
      }
    }
    return '';        //Bug may exist
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;
    final userdata = Provider.of<UserData>(context, listen: true);
    final databaseMethods = DatabaseMethods();
    // List<String> tags = (userTags.college == null ? [] : userTags.college) +
    //     (userTags.interest == null ? [] : userTags.interest) +
    //     (userTags.language == null ? [] : userTags.language) +
    //     (userTags.studyHabits == null ? [] : userTags.studyHabits);
    void resetInfo() {
      databaseMethods.getUserDetailsByID(userdata.userID).then((value) {
        setState(() {
          nickName = value.userName;
          userProfileColor = value.profileColor;
        });
      });
    }

    // void registerNotification(UserData currentUser) async {
    //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   //   RemoteNotification notification = message.notification;
    //   //   AndroidNotification android = message.notification?.android;
    //   //   // showNotification(notification);
    //   // });
    //
    //   messaging.getToken().then((token) {
    //     print('token: $token');
    //     FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(currentUser.userID)
    //         .update({'pushToken': token});
    //   }).catchError((err) {
    //     Fluttertoast.showToast(msg: err.message.toString());
    //   });
    // }
    //
    // void configLocalNotification() async {
    //   const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    //   final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    //   final InitializationSettings initializationSettings = InitializationSettings(
    //       android: initializationSettingsAndroid,
    //       iOS: initializationSettingsIOS);
    //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // }
    //
    // void requestNotificationPermission() async {
    //   NotificationSettings settings = await messaging.requestPermission(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
    //
    //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //     registerNotification(userdata);
    //     configLocalNotification();
    //   } else {
    //     print('User declined notification permission, so notification is not registered');
    //   }
    // }

    resetInfo();
    // TODO: implement build
    return Scaffold(
      backgroundColor: riceColor,
      body: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Setting',
                textAlign: TextAlign.start,
                style: largeTitleTextStyle(Colors.black, 16),
              ),
              backgroundColor: riceColor,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.navigate_before,
                    color: themeOrange,
                    size: 38,
                  )),
            ),
            body: Container(
              color: riceColor,
              height: mediaQuery.height,
              width: sidebarSize,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      //key: widget.key,
                      margin: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      height: mediaQuery.height / 1.25,
                      child: Column(
                        children: <Widget>[
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Name",
                            editText: nickName,
                            iconData: Icons.edit,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                  context,
                                  SecondPage(
                                    pageController:
                                    PageController(initialPage: 0),
                                    isEdit: true,
                                    valueChanged: (index) => {},
                                  )
                                // EditNameModel(
                                //     userName: nickName,
                                //     userId: userdata.userID)
                              );
                              setState(() {});
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Tags",
                            editText: 'College, Interest...',
                            iconData: Icons.edit,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                  context,
                                  TagSelecting(
                                      currentTags: (userdata.userTags.college ==
                                          null
                                          ? []
                                              : userdata.userTags.college
                                              .cast<dynamic>()) +
                                      (userdata.userTags.interest == null
                                      ? []
                                              : userdata.userTags.interest
                                          .cast<dynamic>()) +
                                  (userdata.userTags.language == null
                                  ? []
                                          : userdata.userTags.language
                                      .cast<String>()) +
                              (userdata.userTags.strudyHabits ==
                              null
                              ? []
                                  : userdata.userTags.strudyHabits
                                  .cast<String>()),
                              buttonColor: listProfileColor[
                              userProfileColor.toInt()],
                              pageController:
                              PageController(initialPage: 0),
                              isEdit: true));
                              //   setState(() {
                              //     print(userTagProvider.college);
                              //     tags = (userTagProvider.college == null
                              //             ? []
                              //             : userTagProvider.college
                              //                 .cast<String>()) +
                              //         (userTagProvider.interest == null
                              //             ? []
                              //             : userTagProvider.interest
                              //                 .cast<String>()) +
                              //         (userTagProvider.language == null
                              //             ? []
                              //             : userTagProvider.language
                              //                 .cast<String>()) +
                              //         (userTagProvider.strudyHabits == null
                              //             ? []
                              //             : userTagProvider.strudyHabits
                              //                 .cast<String>());
                              //   });
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Avatar",
                            editText: '',
                            userName: nickName,
                            iconData: Icons.edit,
                            textSize: 14,
                            userProfileColor: userProfileColor,
                            height: (menuContainerHeight) / 8,
                            isAvatar: true,
                            user: userdata,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                context,
                                ThirdPage(
                                  // buttonColor: Colors.amber,
                                    userName: userdata.userName,
                                    initialIndex: userProfileColor.toInt(),
                                    pageController:
                                    PageController(initialPage: 3),
                                    isEdit: true,
                                    valueChanged: (index) => {}),
                              );
                              setState(() {});
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          // ButtonLink(
                          //   text: "Notification",
                          //   editText: '',
                          //   textSize: 14,
                          //   height: (menuContainerHeight) / 8,
                          //   user: userdata,
                          //   isEdit: true,
                          //   onTap: () {
                          //     // requestNotificationPermission();
                          //     // showBottomPopSheet(
                          //     //   context,
                          //     //   NotificationPage(),
                          //     // );
                          //     // setState(() {});
                          //   },
                          // ),
                          // Divider(
                          //   height: 0,
                          //   thickness: 1,
                          //   color: dividerColor,
                          // ),
                          //
                          // ButtonLink(
                          //   text: "Email Status",
                          //   textSize: 14,
                          //   height: (menuContainerHeight) / 8,
                          //   isEdit: true,
                          //   editText: emailVerifiedStatus(),
                          //   onTap: () {
                          //     if (emailVerifiedStatus() == 'Verified'){
                          //       return null;
                          //     }
                          //     showBottomPopSheet(
                          //         context,
                          //         EmailResendPage(
                          //           pageController:
                          //           PageController(initialPage: 0),
                          //           isEdit: true,
                          //           valueChanged: (index) => {},
                          //         ));
                          //     setState(() {});
                          //   },
                          // ),
                          // Divider(
                          //   height: 0,
                          //   thickness: 1,
                          //   color: dividerColor,
                          // ),

                          Expanded(
                            child: Container(),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            onTap: () {
                              authMethods.signOut().then((value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper(false)),
                                );
                              });
                            },
                            text: "Log Out",
                            iconData: Icons.login,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isSimple: true,
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}