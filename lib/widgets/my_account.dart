import 'package:app_test/models/user.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/pages/edit_pages/editHomePage.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/pages/explore_pages/seatNotifyDashboard.dart';
import 'package:app_test/pages/explore_pages/aboutTheApp.dart';
import 'package:app_test/pages/explore_pages/help&feedback.dart';
import 'package:app_test/widgets/course_menu.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/constant.dart';

class MyAccount extends StatefulWidget {
  final GlobalKey key;
  final Function(int) getSize;

  MyAccount({this.key, this.getSize});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;

    // TODO: implement build
    return Scaffold(
      backgroundColor: riceColor,
      body: Container(
        height: mediaQuery.height,
        width: sidebarSize,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              //color: Colors.white,
              height: mediaQuery.height * 0.25,

              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(45, 45, 0, 0),
                    child:
                        // Container(
                        //   height: 10,
                        //   width: 10,
                        //   color: Colors.black,
                        // )

                        createUserImage(sidebarSize / 10, userdata),
                  ),
                  // Image.asset(
                  //   "assets/images/olivia.jpg",
                  //   width: sidebarSize / 2,
                  // ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(sidebarSize / 20,
                        mediaQuery.height * 0.15 - 10, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userdata.userName ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(userdata.email ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(sidebarSize / 20,
                          mediaQuery.height * 0.15 - 25, 15, 30),
                      child: QrImage(
                        data: userdata.userID,
                        version: QrVersions.auto,
                        size: mediaQuery.width / 8.43,
                        gapless: false,
                        // embeddedImage: AssetImage(
                        //     'assets/images/my_embedded_image.png'),
                        // embeddedImageStyle:
                        //     QrEmbeddedImageStyle(
                        //   size: Size(80, 80),
                        // ),
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Row(
                children: [
                  userInfoDetailsBox(mediaQuery, '8', 'My tags'),
                  userInfoDetailsBox(mediaQuery, '26', 'My posts'),
                  userInfoDetailsBox(mediaQuery, '4', 'My classes'),
                ],
              ),
            ),

            // Divider(
            //   thickness: 1,
            // ),
            Container(
              //key: widget.key,
              width: double.infinity,
              height: menuContainerHeight,
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  ButtonLink(
                    text: "Edit Profile",
                    iconData: Icons.edit,
                    textSize: widget.getSize(3),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(
                            providers: [
                              Provider<UserData>.value(
                                value: userdata,
                              )
                            ],
                            child: EditHomePage(
                                getSize: widget.getSize));
                      }));
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 45,
                  ),
                  ButtonLink(
                    text: "Seats Notification",
                    iconData: Icons.event_seat,
                    textSize: widget.getSize(1),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      showBottomPopSheet(
                          context,
                          SeatNotifyDashboard(
                            userID: userdata.userID,
                            userSchool: userdata.school,
                            userEmail: userdata.email,
                          ));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           SeatNotifyDashboard(
                      //             userID: userdata.userID,
                      //             userSchool:
                      //                 userdata.school,
                      //             userEmail:
                      //                 userdata.email,
                      //           )),
                      // );
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 45,
                  ),
                  ButtonLink(
                    text: "Help & Feedback",
                    iconData: Icons.help,
                    textSize: widget.getSize(2),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      showBottomPopSheet(context, HelpFeedback());
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 45,
                  ),
                  ButtonLink(
                    text: "About the app",
                    iconData: Icons.info,
                    textSize: widget.getSize(0),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutTheAPP()),
                      );
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
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
                    textSize: widget.getSize(3),
                    height: (menuContainerHeight) / 6,
                    isSimple: true,
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
