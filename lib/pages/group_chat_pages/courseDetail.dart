import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
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
  List<String> members;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    databaseMethods.getCourseInfo(widget.courseId).then((value) {
      setState(() {
        courseName = value.documents[0].data['myCourseName'];
        courseSection = value.documents[0].data['section'];
        courseTerm = value.documents[0].data['term'];
      });
    });

    databaseMethods.getNumberOfMembersInCourse(widget.courseId).then((value) {
      setState(() {
        numberOfMembers = value.documents.length;
      });
    });

    databaseMethods.getMembersInCourse(widget.courseId).then((value) {
      setState(() {
        members = value;
      });
    });

    super.initState();
  }

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
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: radius,
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg')),
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(
                members != null ? members[index] : '',
                overflow: TextOverflow.ellipsis,
                style:
                    GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    var size = MediaQuery.of(context).size.width;
    double gridWidth = (size - 40 - 4 * 15) / 10;
    double gridRatio = gridWidth / (gridWidth + 10);
    final currentUser = Provider.of<UserData>(context, listen: false);

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/back_arrow.pic',
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFFB811),
                            onPressed: () {
                              // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (courseName ?? '') +
                                ' ' +
                                (courseSection ?? '') +
                                ' ' +
                                (courseTerm ?? ''),
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              numberOfMembers > 1
                                  ? numberOfMembers.toString() + ' ' + 'people'
                                  : numberOfMembers.toString() + ' ' + 'person',
                              style: GoogleFonts.montserrat(
                                color: Colors.black38,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              )),
                        ],
                      ),
                      Container(width: 48)
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 8.0),
                      //   child: IconButton(
                      //     icon: Image.asset(
                      //         'assets/images/group_more.png',
                      //         height: 26,
                      //         width: 50
                      //     ),
                      //     // iconSize: 10.0,
                      //     onPressed: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (context) {
                      //             return MultiProvider(
                      //               providers: [
                      //                 Provider<UserData>.value(
                      //                   value: currentUser,
                      //                 )
                      //               ],
                      //               child: CourseDetailPage(),
                      //             );
                      //           }));
                      //     },
                      //   ),
                      // ),
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
                                        fontSize: 18)),
                                top: 0,
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
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black38,
                                              fontSize: 15,
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
                              children: _renderMemberInfo(gridWidth),
                            ),
                          )
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            // ButtonLink(
                            //   text: "Media, Links, and Docs",
                            //   iconData: Icons.folder,
                            //   textSize: 18,
                            //   height: 50,
                            // ),
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            ButtonLink(
                              text: "Chat Search",
                              iconData: Icons.search,
                              textSize: 18,
                              height: 50,
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
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            // ButtonLink(
                            //     text: "Mute",
                            //     iconData: Icons.notifications_off,
                            //     textSize: 18,
                            //     height: 50,
                            //     isSwitch: true),
                            Divider(
                              height: 0,
                              thickness: 1,
                            )
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
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            ButtonLink(
                                onTap: () {
                                  var a = widget.courseId;
                                  print('delete $a');
                                  courseProvider.removeCourse(
                                      context, widget.courseId);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                text: "Exit Group",
                                iconData: Icons.cleaning_services,
                                textSize: 18,
                                height: 50,
                                isSimple: true),
                            Divider(
                              height: 0,
                              thickness: 1,
                            )
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
