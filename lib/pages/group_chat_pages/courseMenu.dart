import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/searchCourse.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
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
    databaseMethods
        .getListOfNumberOfMembersInCourses(widget.course)
        .then((value) {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {
        listOfNumberOfMembers = value;
      });
    });

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

    // print('here');
    // print(course.length);
    // courseProvider.removeCourse(
    //     context, course[0].courseID);
    // var a = course.where((element) =>
    //     element.courseID == 'daae1bce-3124-4e60-b018-d6493b95e41c');
    // print('aaaaaa');
    // print(a.isNotEmpty);

    return
        // ReorderableListView(
        //   scrollDirection: Axis.vertical,
        //   children: course.map<Widget>((courses) {
        //     return Container(
        //       key: ValueKey(courses.courseID),
        //       margin:
        //           const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
        //       height: 130,
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //       decoration: BoxDecoration(
        //           // image: DecorationImage(
        //           //   image: courseImageAssets(courses.courseCategory),
        //           //   fit: BoxFit.cover,
        //           // ),
        //           gradient: LinearGradient(
        //             colors: [Colors.purple, Colors.red],
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: builtyPinkColor.withOpacity(1),
        //                 blurRadius: 8,
        //                 spreadRadius: 2,
        //                 offset: Offset(4, 4))
        //           ],
        //           borderRadius: BorderRadius.all(Radius.circular(24))),
        //       child: Column(
        //         children: <Widget>[
        //           SizedBox(
        //             height: 4,
        //           ),
        //           Row(
        //             children: <Widget>[
        //               SizedBox(
        //                 width: 9,
        //               ),
        //               Text(courses.myCourseName,
        //                   style: TextStyle(color: Colors.white, fontSize: 20)),
        //               SizedBox(
        //                 width: 9,
        //               ),
        //               Text('+' + courses.userNumbers.toString() + ' classmates',
        //                   style: TextStyle(color: orengeColor, fontSize: 18)),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   }).followedBy([
        //     Container(
        //       // color: Colors.red,
        //       key: ValueKey('addCourse1111111'),
        //       margin:
        //           const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
        //       height: 130,
        //       padding: const EdgeInsets.symmetric(horizontal: 118, vertical: 8),
        //       decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [darkBlueColor, lightBlueColor],
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: lightBlueColor.withOpacity(0.4),
        //                 blurRadius: 8,
        //                 spreadRadius: 2,
        //                 offset: Offset(4, 4))
        //           ],
        //           borderRadius: BorderRadius.all(Radius.circular(24))),
        //       child: Column(
        //         children: <Widget>[
        //           Padding(padding: const EdgeInsets.only(top: 5, bottom: 10)),
        //           Image.asset(
        //             'assets/images/add_course.png',
        //             scale: 1.2,
        //           ),
        //           SizedBox(
        //             height: 8,
        //           ),
        //           Text('Add Course',
        //               style: TextStyle(color: Colors.white, fontSize: 24))
        //         ],
        //       ),
        //     ),
        //   ]).toList(),
        //   onReorder: _onReorder,
        // );
        (course == null)
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: themeOrange,
              ))
            : Container(
                color: Colors.white,
                child: CustomScrollView(
                  slivers: <Widget>[
                    // SliverAppBar(
                    //   // expandedHeight: 150,
                    //   // flexibleSpace: FlexibleSpaceBar(),
                    //   // centerTitle: true,
                    //   // title: Text(
                    //   //   "My Courses",
                    //   //   style: largeTitleTextStyle(),
                    //   // ),
                    //   backgroundColor: Colors.white,
                    //   elevation: 0.0,
                    //   floating: true,
                    //   // leading: IconButton(
                    //   //   iconSize: 35,
                    //   //   color: darkBlueColor,
                    //   //   padding: EdgeInsets.only(left: kDefaultPadding),
                    //   //   icon: Icon(Icons.menu),
                    //   //   onPressed: () {
                    //   //     //todo
                    //   //     // setMenuOpenState(true);
                    //   //   },
                    //   // ),
                    //   // actions: <Widget>[
                    //   //   IconButton(
                    //   //       iconSize: 38,
                    //   //       color: darkBlueColor,
                    //   //       padding:
                    //   //           EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    //   //       icon: Icon(Icons.search),
                    //   //       onPressed: () {
                    //   //         //TODO add course
                    //   //         Navigator.push(
                    //   //           context,
                    //   //           // MaterialPageRoute(
                    //   //           //   builder: (context) {
                    //   //           //     return Provider<UserData>.value(
                    //   //           //       value: userdata,
                    //   //           //       child: SearchGroup(),
                    //   //           //     );
                    //   //           //   },
                    //   //           // ),
                    //   //           MaterialPageRoute(
                    //   //             builder: (context) {
                    //   //               return MultiProvider(
                    //   //                 providers: [
                    //   //                   Provider<UserData>.value(
                    //   //                     value: userdata,
                    //   //                   ),
                    //   //                   Provider<List<CourseInfo>>.value(
                    //   //                     value: course,
                    //   //                   ),
                    //   //                 ],
                    //   //                 child: SearchGroup(),
                    //   //               );
                    //   //             },
                    //   //           ),
                    //   //         );
                    //   //       })
                    //   // ],
                    // ),
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
                                      print(userdata.school);
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
                                                Provider<
                                                        List<CourseInfo>>.value(
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
                        databaseMethods
                            .getListOfNumberOfMembersInCourses(widget.course)
                            .then((value) {
                          if (!mounted) {
                            return; // Just do nothing if the widget is disposed.
                          }
                          setState(() {
                            listOfNumberOfMembers = value;
                          });
                        });

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
                          blurSize: 4,
                          // blurBackgroundColor: Colors.white60,
                          menuWidth: MediaQuery.of(context).size.width * 0.60,
                          menuBoxDecoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
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
                                                Text(
                                                    'The invite Link is copied.'),
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
                                backgroundColor: Colors.redAccent,
                                onPressed: () {
                                  var a = course[index].courseID;
                                  print('$a');
                                  courseProvider.removeCourse(
                                      context, course[index].courseID);
                                }),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              //TODO navigate into course fourm
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MultiProvider(
                                  providers: [
                                    Provider<UserData>.value(
                                      value: userdata,
                                    ),
                                    // 这个需要的话直接uncomment
                                    // Provider<List<CourseInfo>>.value(
                                    //   value: course,
                                    // ),
                                    // final courseProvider = Provider.of<CourseProvider>(context);
                                    // 上面这个courseProvider用于删除添加课程，可以直接在每个class之前define，
                                    // 不需要pass到push里面，直接复制上面这行即可
                                  ],
                                  child: GroupChat(
                                    courseId: course[index].courseID,
                                    myEmail: userdata.email,
                                    myName: userdata.userName,
                                    initialChat: 0,
                                  ),
                                );
                              }));
                            },
                            child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 16, top: 16, left: 38, right: 38),
                                width: 297,
                                height: 114.32,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 43.32,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Text(
                                                course[index].myCourseName ??
                                                    '',
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xffFF7E40),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(course[index].section ?? '',
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xffFF7E40),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 6,
                                            ),

                                            (listOfUnread.isNotEmpty &&
                                                    (listOfUnread[index] ??
                                                            0) ==
                                                        0)
                                                ? Container()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    width: 18,
                                                    height: 18,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: const Color(
                                                          0xffFF1717),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                    ),
                                                    child: Text(
                                                      listOfUnread.isNotEmpty &&
                                                              index <=
                                                                  listOfUnread
                                                                          .length -
                                                                      1
                                                          ? ('+' +
                                                              listOfUnread[
                                                                      index]
                                                                  .toString())
                                                          : '+0',
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  )
                                            // Text('+' + courses.userNumbers.toString() + '',
                                            //     style: TextStyle(
                                            //         color: orengeColor, fontSize: 18)),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                              listOfNumberOfMembers
                                                          .isNotEmpty &&
                                                      index <=
                                                          listOfUnread.length -
                                                              1
                                                  ? (listOfNumberOfMembers[
                                                              index] >
                                                          1
                                                      ? listOfNumberOfMembers[
                                                                  index]
                                                              .toString() +
                                                          ' ' +
                                                          'people'
                                                      : listOfNumberOfMembers[
                                                                  index]
                                                              .toString() +
                                                          ' ' +
                                                          'person')
                                                  : '0 people',
                                              style: GoogleFonts.openSans(
                                                color: Color(0xffFF7E40),
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child:
                                          Image.asset(fileLocation[index % 6]),
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
