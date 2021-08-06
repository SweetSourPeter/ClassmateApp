import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../models/constant.dart';
import 'package:app_test/services/database.dart';
import './searchGroupChat.dart';
import 'package:flutter/services.dart';

import 'chooseGroupLeader.dart';
import 'groupNotice.dart';

class CourseDetail extends StatefulWidget {
  final String courseId;
  final String myEmail;
  final String myName;
  final List<dynamic> members;

  CourseDetail({
    this.courseId,
    this.myEmail,
    this.myName,
    this.members
  });

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  //bool isSwitched = false;
  int numberOfMembers = 0;
  String courseName;
  String courseSection;
  String courseTerm;
  String groupNoticeText;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String adminId;
  String adminName;
  List<dynamic> memberInfo;
  String reloadAdminId;

  @override
  void initState() {
    super.initState();
    databaseMethods.getCourseInfo(widget.courseId).then((value) {
      setState(() {
        courseName = value.docs[0].data()['myCourseName'];
        courseSection = value.docs[0].data()['section'];
        courseTerm = value.docs[0].data()['term'];
        groupNoticeText = value.docs[0].data()['groupNoticeText'];
        adminId = value.docs[0].data()['adminId'];
      });

      // Unused in this class
      databaseMethods.getUserDetailsByID(value.docs[0].data()['adminId']).then((info) {
        setState(() {
          adminName = info.userName;
        });
      });
    });

    memberInfo = widget.members;
    numberOfMembers = memberInfo.length;
  }


  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    var sidebarSize = _width * 0.05;
    double gridWidth = (_width - 40 - 4 * 15) / 10;
    double gridRatio = gridWidth / (gridWidth + 10);
    final currentUser = Provider.of<UserData>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context);
    final course = Provider.of<List<CourseInfo>>(context);

    List<Widget> _renderMemberInfo(radius) {
      return List.generate(numberOfMembers, (index) {
        if (memberInfo == null) {
          return PictureLoadingScreen(Colors.white);
        } else {
          final memberName = memberInfo[index][0];

          return Container(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MultiProvider(
                        providers: [
                          Provider<UserData>.value(
                            value: currentUser,
                          ),
                          Provider<List<CourseInfo>>.value(value: course),
                        ],
                        child: FriendProfile(
                          userID: memberInfo[index]
                              [1], // to be modified to friend's ID
                        ),
                      );
                    }));
                  },
                  child: CircleAvatar(
                    backgroundColor: listProfileColor[
                    memberInfo != null ? memberInfo[index][2].toInt() : 1],
                    radius: radius,
                    child: Container(
                      child: Text(
                        memberName.split(' ').length >= 2
                            ? memberName.split(' ')[0][0].toUpperCase() +
                                memberName
                                    .split(' ')[
                                        memberName.split(' ').length - 1][0]
                                    .toUpperCase()
                            : memberName[0].toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize:
                                memberName.split(' ').length >= 2 ? 14 : 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Text(
                    memberInfo != null ? memberInfo[index][0] : '',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        }
      });
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: const Color(0xfff9f6f1),
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: _height * 0.10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sidebarSize * 0.55),
                            child: Container(
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/images/arrow-back.png',
                                  height: 17.96,
                                  width: 10.26,
                                ),
                                // iconSize: 30.0,
                                color: const Color(0xFFFF7E40),
                                onPressed: () {
                                  // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              (courseName ?? '') + (courseSection ?? ''),
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            //TODO replace Icon
                            child: GestureDetector(
                              onTap: () {
                                Share.share(
                                    'Course Name: ${courseName + courseSection}\nID: ${widget.courseId}\n\nDownload "Meechu" on mobile and search your course groups with group ID or course name',
                                    subject:
                                        'Join ${courseName + courseSection} chat at Meechu');

                                // Clipboard.setData(new ClipboardData(
                                //         text:
                                //             'Course Name: ${courseName + courseSection}\nID: ${widget.courseId}\n\nDownload "Meechu" on mobile and search your course groups with group ID or course name'))
                                //     .then((result) {
                                //   showDialog<void>(
                                //     context: context,
                                //     barrierDismissible:
                                //         false, // user must tap button!
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         content: SingleChildScrollView(
                                //           child: ListBody(
                                //             children: <Widget>[
                                //               Text('The invite Link is copied.'),
                                //             ],
                                //           ),
                                //         ),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             child: Text('OK'),
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // });
                              },
                              child: Text(
                                'share',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.openSans(
                                  color: themeOrange,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: riceColor,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                right: 20, left: 20, top: 20, bottom: 30),
                            margin: EdgeInsets.only(top: 25),
                            color: Colors.white,
                            child: Column(children: <Widget>[
                              Container(
                                height: 20,
                                //color: Colors.black,
                                child: Stack(children: <Widget>[
                                  Positioned(
                                    child: Text('Group Members',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                    top: 0,
                                    left: 0,
                                  ),
                                  Positioned(
                                      child: GestureDetector(
                                        child: Row(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Text(
                                                numberOfMembers > 1
                                                    ? numberOfMembers.toString() + ' ' + 'people'
                                                    : numberOfMembers.toString() + ' ' + 'person',
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black38,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                          // Container(
                                          //   margin: EdgeInsets.only(top: 3),
                                          //   child: Icon(
                                          //     Icons.navigate_next,
                                          //     color: Colors.black38,
                                          //   ),
                                          // )
                                          ],
                                        ),
                                      ),
                                      top: 0,
                                      right: 0),
                                ]),
                              ),
                              Container(
                                //color: Colors.green,
                                height: numberOfMembers <= 5
                                    ? (gridWidth * 2 / gridRatio) + 10 + 20
                                    : numberOfMembers <= 10
                                        ? (gridWidth * 2 / gridRatio) * 2 +
                                            10 +
                                            30
                                        : (gridWidth * 2 / gridRatio) * 3 +
                                            10 +
                                            40,
                                padding: EdgeInsets.only(top: 30),
                                child: Scrollbar(
                                  thickness: 4,
                                  child: GridView.count(
                                    primary: false,
                                    shrinkWrap: true,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 5,
                                    childAspectRatio: gridRatio,
                                    children: _renderMemberInfo(gridWidth - 5),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            width: double.infinity,
                            child: Column(
                              children: [
                                // Divider(
                                //   height: 0,
                                //   thickness: 1,
                                // ),
                                // ButtonLink(
                                //   text: "Media, Links, and Docs",
                                //   iconData: Icons.folder,
                                //   textSize: 18,
                                //   height: 50,
                                // ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: _height * 0.07,
                                    width: _width,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 21.0),
                                          child: Text(
                                            "Chat Search",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 21.0),
                                          child: Image.asset(
                                              'assets/images/arrow-forward.png',
                                              height: 9.02,
                                              width: 4.86,
                                              color: const Color(0xFF949494)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return MultiProvider(
                                            providers: [
                                              Provider<UserData>.value(
                                                value: currentUser,
                                              ),
                                              Provider<List<CourseInfo>>.value(
                                                  value: course)
                                            ],
                                            child: SearchGroupChat(
                                              courseId: widget.courseId,
                                              myEmail: widget.myEmail,
                                              myName: widget.myName,
                                            ),
                                          );
                                        }));
                                    },
                                ),
                                // ButtonLink(
                                //     text: "Mute",
                                //     iconData: Icons.notifications_off,
                                //     textSize: 18,
                                //     height: 50,
                                //     isSwitch: true),
                                Container(
                                  margin:
                                  EdgeInsets.only(left: sidebarSize),
                                  child: Divider(
                                    height: 0,
                                    thickness: 1,
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: _height * 0.1,
                                    width: _width,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 21.0),
                                              child: Text(
                                                "Group Notice",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 21.0),
                                              child: Image.asset(
                                                  'assets/images/arrow-forward.png',
                                                  height: 9.02,
                                                  width: 4.86,
                                                  color: const Color(0xFF949494)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 21.0),
                                              child: Container(
                                                width: _width*0.85,
                                                child: Text(
                                                  (groupNoticeText == null) ? 'Loading...' : (groupNoticeText.isEmpty ? 'Not Set' : groupNoticeText),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFF949494)),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 21.0),
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MultiProvider(
                                        providers: [
                                          Provider<UserData>.value(
                                            value: currentUser,
                                          ),
                                          Provider<List<CourseInfo>>.value(
                                              value: course),
                                        ],
                                        child: GroupNotice(
                                          courseId: widget
                                              .courseId, // to be modified to friend's ID
                                        ),
                                      );
                                    })).then((_) {
                                      databaseMethods.getCourseInfo(widget.courseId).then((value) {
                                        setState(() {
                                          groupNoticeText = value.docs[0].data()['groupNoticeText'];
                                        });
                                      });
                                    });
                                  },
                                ),
                                Container(
                                  margin:
                                  EdgeInsets.only(left: sidebarSize),
                                  child: Divider(
                                    height: 0,
                                    thickness: 1,
                                  ),
                                ),
                                //if (currentUser.userID == adminId)
                                Visibility(
                                  visible: true,
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 50,
                                            width: MediaQuery.of(context).size.width,
                                            color: Colors.white,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(left: 21.0),
                                                  child: Text(
                                                    "Administrator Transfer",
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),

                                                // Padding(
                                                //     padding:
                                                //     const EdgeInsets.only(right: 30.0),
                                                //     child: Text(adminName == null ? 'Loading...' : adminName)
                                                // ),

                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(right: 21.0),
                                                  child: Image.asset(
                                                      'assets/images/arrow-forward.png',
                                                      height: 9.02,
                                                      width: 4.86,
                                                      color: const Color(0xFF949494)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            if (memberInfo == null){
                                              return null;
                                            }
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return MultiProvider(
                                                    providers: [
                                                      Provider<UserData>.value(
                                                        value: currentUser,
                                                      ),
                                                    ],
                                                    child: ChooseGroupLeader(
                                                      groupMembers: memberInfo,
                                                      courseId: widget.courseId,
                                                      myEmail: widget.myEmail,
                                                      myName: widget.myName,
                                                      adminCallback: (String val) => setState(()=>reloadAdminId=val),
                                                    ),
                                                  );
                                                }));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //     margin: EdgeInsets.only(top: 25),
                          //     child: Column(
                          //       children: [
                          //         Divider(
                          //           height: 0,
                          //           thickness: 1,
                          //         ),
                          //         // ButtonLink(
                          //         //     text: "Clear Chat",
                          //         //     iconData: Icons.cleaning_services,
                          //         //     textSize: 18,
                          //         //     height: 50,
                          //         //     isSimple: true),
                          //         Divider(
                          //           height: 0,
                          //           thickness: 1,
                          //         )
                          //       ],
                          //     )),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Column(
                              children: [
                                // Divider(
                                //   height: 0,
                                //   thickness: 1,
                                // ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    width: _width,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 21.0),
                                      child: Text(
                                        "Exit Group",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            color: Color(0xffFF7E40)),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (currentUser.userID != reloadAdminId)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    'Are you sure you want to delete this course?',
                                                    style: simpleTextStyle(
                                                        Colors.black, 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'Yes',
                                                  style: simpleTextStyle(
                                                      Colors.black87, 16),
                                                ),
                                                onPressed: () {
                                                  courseProvider.removeCourse(
                                                      context, widget.courseId);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: simpleTextStyle(
                                                      themeOrange, 16),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    else
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    'You are now the group leader, please choose a new leader before exiting',
                                                    style: simpleTextStyle(
                                                        Colors.black, 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: simpleTextStyle(
                                                      themeOrange, 16),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                  },
                                ),
                                // Divider(
                                //   height: 0,
                                //   thickness: 1,
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
