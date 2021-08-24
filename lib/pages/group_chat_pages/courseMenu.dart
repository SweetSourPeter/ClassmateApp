import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/searchCourse.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class CourseMainMenu extends StatefulWidget {
  const CourseMainMenu({Key key, this.course, this.userData}) : super(key: key);

  final course;
  final userData;

  @override
  _CourseMainMenuState createState() => _CourseMainMenuState();
}

class _CourseMainMenuState extends State<CourseMainMenu> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  List<int> listOfNumberOfMembers = [];
  List<int> listOfUnread = [];

  List<String> fileLocation = [
    'assets/icon/courseIcon1.png',
    'assets/icon/courseIcon2.png',
    'assets/icon/courseIcon3.png',
    'assets/icon/courseIcon4.png',
    'assets/icon/courseIcon5.png',
    'assets/icon/courseIcon6.png',
  ];

  @override
  void initState() {
    // databaseMethods
    //     .getListOfNumberOfMembersInCourses(widget.course)
    //     .then((value) {
    //   if (!mounted) {
    //     return; // Just do nothing if the widget is disposed.
    //   }
    //   setState(() {
    //     listOfNumberOfMembers = value;
    //   });
    // });

    databaseMethods
        .getListOfUnreadInCourses(widget.course, widget.userData.userID)
        .then((value) {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        listOfUnread = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final course = Provider.of<List<CourseInfo>>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return (course == null)
        ? LoadingScreen(Colors.white)
        : Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 35,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 33, top: 5),
                      child: Container(
                        // color: orengeColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                'My Courses',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5, right: 39),
                              //TODO replace Icon
                              child: GestureDetector(
                                onTap: () {
                                  // print(userdata.school);
                                  //TODO add course
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MultiProvider(
                                          providers: [
                                            Provider<UserData>.value(
                                              value: userdata,
                                            ),
                                            Provider<List<CourseInfo>>.value(
                                                value: course)
                                          ],
                                          child: SearchCourse(),
                                        );
                                      },
                                    ),
                                  );

                                  // MaterialPageRoute(
                                  //     builder: (context) => SearchGroup()));
                                },
                                child: Text(
                                  'add course',
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
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // databaseMethods
                    //     .getListOfNumberOfMembersInCourses(widget.course)
                    //     .then((value) {
                    //   if (!mounted) {
                    //     return; // Just do nothing if the widget is disposed.
                    //   }
                    //   setState(() {
                    //     listOfNumberOfMembers = value;
                    //   });
                    // });

                    databaseMethods
                        .getListOfUnreadInCourses(
                            widget.course, widget.userData.userID)
                        .then((value) {
                      if (!mounted) {
                        return; // Just do nothing if the widget is disposed.
                      }
                      setState(() {
                        listOfUnread = value;
                      });
                    });
                    return FocusedMenuHolder(
                      blurSize: 0,
                      menuOffset: 0,
                      // blurBackgroundColor: Colors.white60,
                      menuWidth: MediaQuery.of(context).size.width * 0.50,
                      menuBoxDecoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(60.0))),
                      onPressed: () {
                        //press on the item
                      },
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(
                            title: Text('Mark as unread'),
                            trailingIcon: Icon(Icons.mark_chat_unread),
                            onPressed: () {
                              databaseMethods.setUnreadGroupChatNumberToOne(
                                  course[index].courseID, userdata.userID);
                            }),
                        FocusedMenuItem(
                            title: Text('Share'),
                            trailingIcon: Icon(Icons.share),
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(
                                      text:
                                          'Download "Meechu" on mobile and search your course groups with group ID or course name\n\nID: ${course[index].courseID}\nCourse Name: ${course[index].myCourseName + course[index].section}'))
                                  .then((result) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('The invite Link is copied.'),
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
                            }),
                        FocusedMenuItem(
                            title: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailingIcon: Icon(Icons.delete),
                            backgroundColor: Colors.orange,
                            onPressed: () {
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
                                          var a = course[index].courseID;
                                          // print('$a');
                                          courseProvider.removeCourse(
                                              context, course[index].courseID);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style:
                                              simpleTextStyle(themeOrange, 16),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                      ],
                      child: GestureDetector(
                        onTap: () {
                          //TODO navigate into course fourm
                          databaseMethods.setUnreadGroupChatNumberToZero(
                              course[index].courseID, userdata.userID);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MultiProvider(
                              providers: [
                                Provider<UserData>.value(
                                  value: userdata,
                                ),
                                Provider<List<CourseInfo>>.value(
                                  value: course,
                                ),
                              ],
                              child: GroupChat(
                                courseId: course[index].courseID,
                                myEmail: userdata.email,
                                myName: userdata.userName,
                                myId: userdata.userID,
                                initialChat: 0,
                              ),
                            );
                          }));
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                              bottom: 0.02 * _height,
                              top: 0.02 * _height,
                              left: 0.101 * _width,
                              right: 0.101 * _width,
                            ),
                            width: 0.792 * _width,
                            height: 0.15 * _height,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  // BoxShadow(
                                  //     color: Colors.black.withOpacity(0.15),
                                  //     blurRadius: 6,
                                  //     spreadRadius: 3,
                                  //     offset: Offset(4, 4))
                                  //neumorphic light
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    offset: Offset(-6.0, -6.0),
                                    blurRadius: 16.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(6.0, 6.0),
                                    blurRadius: 16.0,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: _height * 0.05,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: _width * 0.0271,
                                        ),
                                        AutoSizeText(
                                            course[index].myCourseName ?? '',
                                            style: GoogleFonts.montserrat(
                                                color: Color(0xffFF7E40),
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: _width * 0.012,
                                        ),
                                        AutoSizeText(
                                            course[index].section ?? '',
                                            style: GoogleFonts.montserrat(
                                                color: Color(0xffFF7E40),
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: _width * 0.016,
                                        ),
                                        listOfUnread.isEmpty ||
                                                (index >
                                                    listOfUnread.length - 1) ||
                                                listOfUnread[index] == 0
                                            ? Container()
                                            : Container(
                                                alignment: Alignment.center,
                                                width: _width * 0.048,
                                                height: _width * 0.048,
                                                decoration: new BoxDecoration(
                                                  color:
                                                      const Color(0xffFF1717),
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child: AutoSizeText(
                                                  ('+' +
                                                      listOfUnread[index]
                                                          .toString()),
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 8,
                                                      color: Colors.white),
                                                ),
                                              )
                                        // Text('+' + courses.userNumbers.toString() + '',
                                        //     style: TextStyle(
                                        //         color: orengeColor, fontSize: 18)),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: _width * 0.0266),
                                      child: AutoSizeText(
                                          course[index].userNumbers != null
                                              ? (course[index].userNumbers > 1
                                                  ? course[index]
                                                          .userNumbers
                                                          .toString() +
                                                      ' ' +
                                                      'people'
                                                  : course[index]
                                                          .userNumbers
                                                          .toString() +
                                                      ' ' +
                                                      'person')
                                              : 'Loading...',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xffFF7E40),
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                ((course[index].myCourseName.length +
                                            course[index].section.length) >
                                        10)
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            right: _width * 0.05),
                                        child: Container(
                                            child: Image.asset(
                                                fileLocation[index % 6])),
                                      ),
                              ],
                            )),
                      ),
                    );
                  }, childCount: course.length),
                )
                //           .followedBy([
                //         GestureDetector(
                //           onTap: () {
                //             print(userdata.school);
                //             //TODO add course
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) {
                //                   return MultiProvider(
                //                     providers: [
                //                       Provider<UserData>.value(
                //                         value: userdata,
                //                       ),
                //                       Provider<List<CourseInfo>>.value(
                //                           value: course)
                //                     ],
                //                     child: SearchCourse(),
                //                   );
                //                 },
                //               ),
                //             );
                //
                //             // MaterialPageRoute(
                //             //     builder: (context) => SearchGroup()));
                //           },
                //           child: Container(
                //             // color: Colors.red,
                //             margin: const EdgeInsets.only(
                //                 bottom: 16, top: 16, left: 38, right: 38),
                //             height: 90,
                //             width: 50,
                //             // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //             decoration: BoxDecoration(
                //                 gradient: LinearGradient(
                //                   colors: [lightYellowColor, builtyPinkColor],
                //                   begin: Alignment.centerLeft,
                //                   end: Alignment.centerRight,
                //                 ),
                //                 boxShadow: [
                //                   BoxShadow(
                //                       color: Colors.black.withOpacity(0.2),
                //                       blurRadius: 8,
                //                       spreadRadius: 2,
                //                       offset: Offset(4, 4))
                //                 ],
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(24))),
                //             child: Column(
                //               children: <Widget>[
                //                 Padding(
                //                     padding: const EdgeInsets.only(
                //                         top: 10, bottom: 10)),
                //                 Image.asset(
                //                   'assets/images/add_course.png',
                //                   scale: 5,
                //                 ),
                //                 SizedBox(
                //                   height: 2,
                //                 ),
                //                 Text('Add Course',
                //                     style: simpleTextStyle(Colors.black, 20))
                //               ],
                //             ),
                //           ),
                //         ),
                //       ]).toList()
              ],
            ),
          );
  }

  AssetImage courseImageAssets(String type) {
    switch (type) {
      case 'CS':
        {
          return AssetImage('assets/courseimage/cs_course_BG.jpg');
        }
        break;
      case 'WR':
        {
          return AssetImage('assets/courseimage/wr_course_BG.jpg');
        }
        break;
      case 'PH':
        {
          return AssetImage('assets/courseimage/ph_course_BG.jpg');
        }
        break;
      case 'ECON':
        {
          return AssetImage('assets/courseimage/econ_course_BG.jpg');
        }
        break;
      default:
        {
          return AssetImage('assets/courseimage/econ_course_BG.jpg');
        }
        break;
    }
  }
}
