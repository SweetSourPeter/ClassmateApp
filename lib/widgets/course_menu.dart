import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/searchGroup.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';

class CourseMainMenu extends StatefulWidget {
  const CourseMainMenu({
    Key key,
  }) : super(key: key);

  @override
  _CourseMainMenuState createState() => _CourseMainMenuState();
}

class _CourseMainMenuState extends State<CourseMainMenu> {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final course = Provider.of<List<CourseInfo>>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
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
            ? CircularProgressIndicator()
            : Container(
                color: riceColor,
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
                              children: [
                                Text(
                                  'My Courses',
                                  textAlign: TextAlign.left,
                                  style: largeTitleTextStyle(Colors.black),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2, top: 10),
                                  //TODO replace Icon
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    size: 28,
                                  ),
                                )
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
                        delegate: SliverChildListDelegate(
                            course.map<Widget>((courses) {
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
                              title: Text('Open'),
                              trailingIcon: Icon(Icons.open_in_new),
                              onPressed: () {}),
                          FocusedMenuItem(
                              title: Text('Share'),
                              trailingIcon: Icon(Icons.share),
                              onPressed: () {}),
                          FocusedMenuItem(
                              title: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                              trailingIcon: Icon(Icons.delete),
                              backgroundColor: Colors.redAccent,
                              onPressed: () {
                                var a = courses.courseID;
                                print('$a');
                                courseProvider.removeCourse(
                                    context, courses.courseID);
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
                                  courseId: courses.courseID,
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
                              height: 150,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: courseImageAssets(courses.courseCategory),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  color: Colors.white,
                                  // gradient: LinearGradient(
                                  //   colors: [Colors.white, builtyPinkColor],
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  // ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                        offset: Offset(4, 4))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 45,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Text(courses.myCourseName ?? '',
                                          style: TextStyle(
                                              color: lightOrangeColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800)),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Text(courses.section ?? '',
                                          style: TextStyle(
                                              color: lightOrangeColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800)),
                                      // Text('+' + courses.userNumbers.toString() + '',
                                      //     style: TextStyle(
                                      //         color: orengeColor, fontSize: 18)),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    }).followedBy([
                      GestureDetector(
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
                                    Provider<List<CourseInfo>>.value(
                                        value: course)
                                  ],
                                  child: SearchGroup(),
                                );
                              },
                            ),
                          );

                          // MaterialPageRoute(
                          //     builder: (context) => SearchGroup()));
                        },
                        child: Container(
                          // color: Colors.red,
                          margin: const EdgeInsets.only(
                              bottom: 16, top: 16, left: 38, right: 38),
                          height: 150,
                          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [lightYellowColor, builtyPinkColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: Offset(4, 4))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10)),
                              Image.asset(
                                'assets/images/add_course.png',
                                scale: 2,
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Text('Add Course',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 28))
                            ],
                          ),
                        ),
                      ),
                    ]).toList()))
                  ],
                ),
              );
    //       ListView(
    //     children:
    // course.map((courses) {
    //       return Container(
    //         margin:
    //             const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
    //         height: 130,
    //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: courseImageAssets(courses.courseCategory),
    //               fit: BoxFit.cover,
    //             ),
    //             // gradient: LinearGradient(
    //             //   colors: [Colors.white, colorSelection(courses.courseCategory)],
    //             //   begin: Alignment.centerLeft,
    //             //   end: Alignment.centerRight,
    //             // ),
    //             boxShadow: [
    //               BoxShadow(
    //                   color: Colors.black.withOpacity(0.2),
    //                   blurRadius: 8,
    //                   spreadRadius: 2,
    //                   offset: Offset(4, 4))
    //             ],
    //             borderRadius: BorderRadius.all(Radius.circular(24))),
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 4,
    //             ),
    //             Row(
    //               children: <Widget>[
    //                 SizedBox(
    //                   width: 9,
    //                 ),
    //                 Text(courses.myCourseName,
    //                     style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 26,
    //                         fontWeight: FontWeight.w500)),
    //                 SizedBox(
    //                   width: 9,
    //                 ),
    //                 Text('+' + courses.userNumbers.toString() + ' classmates',
    //                     style: TextStyle(color: orengeColor, fontSize: 18)),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     }).followedBy([
    //       Container(
    //         // color: Colors.red,
    //         margin:
    //             const EdgeInsets.only(bottom: 16, top: 16, left: 25, right: 25),
    //         height: 120,
    //         // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //         decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [darkBlueColor, lightBlueColor],
    //               begin: Alignment.centerLeft,
    //               end: Alignment.centerRight,
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                   color: Colors.black.withOpacity(0.2),
    //                   blurRadius: 8,
    //                   spreadRadius: 2,
    //                   offset: Offset(4, 4))
    //             ],
    //             borderRadius: BorderRadius.all(Radius.circular(24))),
    //         child: Column(
    //           children: <Widget>[
    //             Padding(padding: const EdgeInsets.only(top: 10, bottom: 10)),
    //             Image.asset(
    //               'assets/images/add_course.png',
    //               scale: 1.1,
    //             ),
    //             SizedBox(
    //               height: 8,
    //             ),
    //             Text('Add Course',
    //                 style: TextStyle(color: Colors.white, fontSize: 28))
    //           ],
    //         ),
    //       ),
    //     ]).toList(),
    //   );
    // }

    void _onReorder(int oldIndex, int newIndex) {
      setState(
        () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final CourseInfo item = course.removeAt(oldIndex);
          course.insert(newIndex, item);
        },
      );
    }

    Color colorSelection(String type) {
      switch (type) {
        case 'CS':
          {
            return Colors.lightGreen;
          }
          break;
        case 'WR':
          {
            return Colors.yellow;
          }
          break;
        case 'PH':
          {
            return Colors.black12;
          }
          break;
        case 'ECON':
          {
            return Colors.blue;
          }
          break;
        default:
          {
            return Colors.black12;
          }
          break;
      }
    }
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
