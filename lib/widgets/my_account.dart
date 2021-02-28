import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/edit_pages/editHomePage.dart';
import 'package:app_test/pages/explore_pages/seatNotifyDashboard.dart';
import 'package:app_test/pages/explore_pages/aboutTheApp.dart';
import 'package:app_test/pages/explore_pages/help&feedback.dart';
import 'package:app_test/pages/chat_pages/confirmImage.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

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
    double _width = getRealWidth(MediaQuery.of(context).size.width);
    final userdata = Provider.of<UserData>(context);
    final userTags = Provider.of<UserTags>(context);
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = getRealWidth(mediaQuery.width) * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        height: mediaQuery.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        print(userTags.college);
                        Clipboard.setData(
                          new ClipboardData(
                              text:
                                  'Join me on Meechu!!!\nDownload "Meechu" on mobile and search your classmates with email.\n\nEmail: ${userdata.email}'),
                        ).then((result) {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Your profile invitation has been copied.'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 39, top: 29),
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
              // Container(
              //     margin: EdgeInsets.only(
              //         bottom: 0.03 * _height, top: _height * 0.043),
              //     child: Stack(
              //       children: [
              //         Image.asset(
              //           'assets/icon/earCircle.png',
              //           color: themeOrange,
              //           width: sidebarSize / 3.8,
              //         ),
              //         Positioned(
              //             child: createUserImage(
              //               sidebarSize / 8,
              //               userdata,
              //               largeTitleTextStyleBold(Colors.white, 25),
              //             ),
              //             top: 13,
              //             left: 3)
              //       ],
              //     )),
              Padding(
                padding: EdgeInsets.only(top: _height * 0.033),
                child: Container(
                  color: Colors.transparent,
                  height: _height * 0.1465 * 1.0924,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: (MediaQuery.of(context).size.width / 2) - (_height * 0.1465 / 2),
                        child: CircleAvatar(
                          backgroundColor: themeOrange,
                          radius: _height * 0.1465 / 2,
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - (_height * 0.1465 / 2) + 4,
                        bottom: 4,
                        child: createUserImage(
                          (_height * 0.1465 - 8) / 2,
                          userdata,
                          largeTitleTextStyleBold(Colors.white, 25),
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - (_height * 0.1465 / 2),
                        bottom: 0,
                        child: Container(
                            height: _height * 0.1465 * 1.0924,
                            width: _height * 0.1465,
                            child: FittedBox(
                              child: Image.asset('assets/icon/earCircle.png'),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: Column(
                  children: [
                    AutoSizeText(
                      userdata.userName ?? '',
                      style: largeTitleTextStyleBold(Colors.black, 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
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
                            ),
                            Provider<UserTags>.value(
                              value: userTags,
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
                          MaterialPageRoute(
                              builder: (context) => AboutTheAPP()),
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
      ),
    );
  }
}
