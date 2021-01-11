import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';
import 'package:app_test/services/database.dart';
import './searchGroupChat.dart';

class CourseDetail extends StatefulWidget {
  final String courseId;
  final String myEmail;
  final String myName;

  CourseDetail({
    this.courseId,
    this.myEmail,
    this.myName,
  });

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool isSwitched = false;
  int numberOfMembers = 0;
  String courseName;
  String courseSection;
  String courseTerm;
  List<List<dynamic>> members;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    databaseMethods.getCourseInfo(widget.courseId).then((value) {
      setState(() {
        courseName = value.documents[0].data()['myCourseName'];
        courseSection = value.documents[0].data()['section'];
        courseTerm = value.documents[0].data()['term'];
      });
    });
    print('here');
    databaseMethods.getNumberOfMembersInCourse(widget.courseId).then((value) {
      setState(() {
        numberOfMembers = value.documents.length;
      });
    });

    databaseMethods.getInfoOfMembersInCourse(widget.courseId).then((value) {
      // if (this.mounted) {
      //   return;
      // }
      setState(() {
        members = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    double gridWidth = (size - 40 - 4 * 15) / 10;
    double gridRatio = gridWidth / (gridWidth + 10);
    final currentUser = Provider.of<UserData>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context);
    List<Widget> _renderMemberInfo(radius) {
      return List.generate(numberOfMembers, (index) {
        // if (index > 9) {
        //   return GestureDetector(
        //     child: Container(
        //       child: Column(
        //         children: <Widget>[
        //           creatAddIconImage(radius),
        //           Text(
        //             'Invite',
        //             style:
        //                 GoogleFonts.montserrat(color: orengeColor, fontSize: 15),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }
        if (members == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: themeOrange,
            ),
          );
        } else {
          final memberName = members[index][0];

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
                          // 这个需要的话直接uncomment
                          // Provider<List<CourseInfo>>.value(
                          //   value: course,F
                          // ),
                          // final courseProvider = Provider.of<CourseProvider>(context);
                          // 上面这个courseProvider用于删除添加课程，可以直接在每个class之前define，
                          // 不需要pass到push里面，直接复制上面这行即可
                        ],
                        child: FriendProfile(
                          userID: members[index]
                              [1], // to be modified to friend's ID
                        ),
                      );
                    }));
                  },
                  child: CircleAvatar(
                    backgroundColor: listProfileColor[
                        members != null ? members[index][2].toInt() : 1],
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
                    members != null ? members[index][0] : '',
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff9f6f1),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 73,
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 13.7, left: 8),
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
                      Center(
                        child: Text(
                          (courseName ?? '') + (courseSection ?? ''),
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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
                                                ? numberOfMembers.toString() +
                                                    ' ' +
                                                    'people'
                                                : numberOfMembers.toString() +
                                                    ' ' +
                                                    'person',
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
                                    ? (gridWidth * 2 / gridRatio) * 2 + 10 + 30
                                    : (gridWidth * 2 / gridRatio) * 3 + 10 + 40,
                            padding: EdgeInsets.only(top: 30),
                            child: GridView.count(
                              primary: false,
                              shrinkWrap: true,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              crossAxisCount: 5,
                              childAspectRatio: gridRatio,
                              children: _renderMemberInfo(gridWidth - 5),
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
                                        "Chat Search",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MultiProvider(
                                    providers: [
                                      Provider<UserData>.value(
                                        value: currentUser,
                                      )
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
                            // Divider(
                            //                             //   height: 0,
                            //                             //   thickness: 1,
                            //                             // )
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
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 21.0),
                                  child: Text(
                                    "Exit Group",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14, color: Color(0xffFF7E40)),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
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
            )),
      ),
    );
  }
}
