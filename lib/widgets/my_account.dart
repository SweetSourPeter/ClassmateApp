import 'package:app_test/models/user.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/edit_pages/editHomePage.dart';
import 'package:app_test/pages/explore_pages/seatNotifyDashboard.dart';
import 'package:app_test/pages/explore_pages/aboutTheApp.dart';
import 'package:app_test/pages/explore_pages/help&feedback.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        elevation: 0,
        actions: [
          GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(right: 19, top: 11),
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
      body: Container(
        height: mediaQuery.height,
        width: sidebarSize,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 24, top: 35),
                child:
                    // Container(
                    //   height: 10,
                    //   width: 10,
                    //   color: Colors.black,
                    // )
                    Stack(
                  children: [
                    SvgPicture.asset(
                      './assets/images/cat_ears.svg',
                      color: themeOrange,
                      width: sidebarSize / 3.8,
                    ),
                    Positioned(
                        child: createUserImage(sidebarSize / 8, userdata),
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
            // Divider(
            //   thickness: 1,
            // ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 10, right: 10),
              //key: widget.key,
              width: double.infinity,
              height: menuContainerHeight,
              child: Column(
                children: <Widget>[
                  ButtonLink(
                    text: "Setting",
                    iconData: Icons.settings_outlined,
                    textSize: widget.getSize(3),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(providers: [
                          Provider<UserData>.value(
                            value: userdata,
                          )
                        ], child: EditHomePage(getSize: widget.getSize));
                      }));
                    },
                  ),
                  Divider(
                      height: 0,
                      thickness: 1,
                      indent: 60,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "Seats Notification",
                    iconData: Icons.notifications_outlined,
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
                      indent: 60,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "Help & Feedback",
                    iconData: Icons.help_outline,
                    textSize: widget.getSize(2),
                    height: (menuContainerHeight) / 6,
                    onTap: () {
                      showBottomPopSheet(context, HelpFeedback());
                    },
                  ),
                  Divider(
                      height: 0,
                      thickness: 1,
                      indent: 60,
                      endIndent: 30,
                      color: dividerColor),
                  ButtonLink(
                    text: "About the app",
                    iconData: Icons.info_outline,
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
                      indent: 60,
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
