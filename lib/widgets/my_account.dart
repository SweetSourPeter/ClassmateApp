import 'package:app_test/models/user.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/edit_pages/editHomePage.dart';
import 'package:app_test/pages/explore_pages/seatNotifyDashboard.dart';
import 'package:app_test/pages/explore_pages/aboutTheApp.dart';
import 'package:app_test/pages/explore_pages/help&feedback.dart';
import 'package:app_test/pages/group_chat_pages/courseMenu.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAccount extends StatefulWidget {
  final GlobalKey key;

  MyAccount({this.key});

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
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final userdata = Provider.of<UserData>(context);
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: mediaQuery.height,
        width: sidebarSize,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(right: 19, top: 29),
                      child: Text(
                        'Share',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: themeOrange),
                      ),
                    )),
              ],
            ),
            Container(
                margin: EdgeInsets.only(
                    bottom: 0.03 * _height, top: _height * 0.043),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icon/earCircle.png',
                      color: themeOrange,
                      width: sidebarSize / 3.8,
                    ),
                    Positioned(
                        child: createUserImage(
                          sidebarSize / 8,
                          userdata,
                          largeTitleTextStyleBold(Colors.white, 25),
                        ),
                        top: 13,
                        left: 3)
                  ],
                )),
            // Image.asset(
            //   "assets/images/olivia.jpg",
            //   width: sidebarSize / 2,
            // ),

            Container(
              child: Column(
                children: [
                  Text(
                    userdata.userName ?? '',
                    style: largeTitleTextStyleBold(Colors.black, 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    userdata.email ?? '',
                    style: simpleTextStyle(Color(0xFF636363), 16),
                  ),
                ],
              ),
            ),
            // Divider(
            //   thickness: 1,
            // ),
            Container(
              margin: EdgeInsets.only(top: _height * 0.05),
              padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
              //key: widget.key,
              width: double.infinity,
              height: menuContainerHeight,
              child: Column(
                children: <Widget>[
                  ButtonLink(
                    text: "Setting",
                    iconData: Icons.settings_outlined,
                    textSize: 14,
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(providers: [
                          Provider<UserData>.value(
                            value: userdata,
                          )
                        ], child: EditHomePage());
                      }));
                    },
                  ),
                  Divider(
                      height: 0,
                      thickness: 1,
                      indent: 50,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "Seats Notification",
                    iconData: Icons.notifications_outlined,
                    textSize: 14,
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
                      indent: 50,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "Help & Feedback",
                    iconData: Icons.help_outline,
                    textSize: 14,
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      showBottomPopSheet(
                          context, HelpFeedback(userEmail: userdata.email));
                    },
                  ),
                  Divider(
                      height: 0,
                      thickness: 1,
                      indent: 50,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "About the app",
                    iconData: Icons.info_outline,
                    textSize: 14,
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
                      indent: 50,
                      endIndent: 30,
                      thickness: 1,
                      color: dividerColor),
                  SizedBox(
                    height: 20,
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
