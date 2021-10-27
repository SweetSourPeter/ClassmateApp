import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/explore_pages/loadingSeatReminderList.dart';
import 'package:app_test/pages/explore_pages/seatNotifyAdd.dart';
import 'package:app_test/services/course_reminder_db.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:flutter/scheduler.dart';
import 'inviteNotifyRules.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeatNotifyDashboard extends StatefulWidget {
  SeatNotifyDashboard({Key key})
      : super(
          key: key,
        );

  @override
  _SeatNotifyDashboardState createState() => _SeatNotifyDashboardState();
}

class _SeatNotifyDashboardState extends State<SeatNotifyDashboard> {
  String subtitle;
  // final databaseMethods = CourseReminderDatabase();
  List<String> fileLocation = [
    'assets/icon/catPaw1.png',
    'assets/icon/catPaw3.png',
    'assets/icon/catPaw2.png',
    'assets/icon/catPaw4.png',
  ];
  CourseReminderDatabase courseReminderDatabaseMethods =
      CourseReminderDatabase();
  bool loading = false;
  bool close = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context, listen: true);
    if (close) {
      Navigator.of(
        context,
      ).pop();
    }
    print('--------------------');
    print(userdata.myChargeNumber);
    Stream<List<Map<String, dynamic>>> data =
        courseReminderDatabaseMethods.getUserReminderLists(userdata.userID);
    double modelHeight = MediaQuery.of(context).size.height - 60;
    _toastInfo(String info) {
      Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 8.0,
        timeInSecForIosWeb: 20,
        gravity: ToastGravity.TOP,
        webBgColor: 'linear-gradient(to right, #ff7e40, #ff7e40)',
        webPosition: "center",
      );
    }

    Widget addCourseButton() {
      return GestureDetector(
        child: Icon(
          Icons.add_circle_outline_sharp,
          size: 38,
          color: themeOrange,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MultiProvider(providers: [
              Provider<UserData>.value(
                value: userdata,
              ),
            ], child: SeatsNotification());
          }));
        },
      );
    }

    Widget unlockCourseButton() {
      return GestureDetector(
        child: Icon(
          Icons.lock_outline,
          size: 38,
          color: themeOrange,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MultiProvider(providers: [
              Provider<UserData>.value(
                value: userdata,
              ),
            ], child: InviteNotifyRules());
          }));
        },
      );
    }

    Widget levelCounter() {
      if (userdata.invitedUserID == null) {
        if (userdata.myChargeNumber < 2) {
          // number of notify added
          // 添加charge+1 删除-1
          // print('here   sdfasdfsdf');
          return addCourseButton();
        } else {
          print('here   sdfasdfsdf');
          return unlockCourseButton();
        }
      } else {
        if (userdata.invitedUserID.length == 0) {
          if (userdata.myChargeNumber < 2) {
            return addCourseButton();
          } else {
            return unlockCourseButton();
          }
        } else if (userdata.invitedUserID.length == 1) {
          if (userdata.myChargeNumber < 4) {
            return addCourseButton();
          } else {
            return unlockCourseButton();
          }
        } else if (userdata.invitedUserID.length == 2) {
          if (userdata.myChargeNumber < 6) {
            return addCourseButton();
          } else {
            return unlockCourseButton();
          }
        } else if (userdata.invitedUserID.length >= 3) {
          return addCourseButton(); //大于三个邀请免费
        }
      }
      return addCourseButton();
    }

    return loading
        ? LoadingScreen(Colors.white)
        : Container(
            decoration: BoxDecoration(
              color: riceColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                // bottomLeft: Radius.circular(30.0),
                // bottomRight: Radius.circular(30.0),
              ),
            ),
            height: modelHeight,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: SizedBox(
                  width: maxWidth,
                  child: Scaffold(
                    backgroundColor: riceColor,
                    body:
                        // RefreshIndicator(
                        // key: refreshKey,
                        // onRefresh: () async {
                        //   await refreshList();
                        // },
                        // child:
                        Column(
                      children: [
                        topLineBar(),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 22,
                            ),
                            child: Container(
                              child: Text(
                                'Your Alert List',
                                textAlign: TextAlign.center,
                                style:
                                    largeTitleTextStyleBold(Colors.black, 28),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: data,
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return Center(
                                    child: Text("Error"),
                                  );
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Loading();
                                  default:
                                    return !snapshot.hasData
                                        ? Center(
                                            child: Text(
                                                "You dont have a notification list"),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return FocusedMenuHolder(
                                                blurSize: 4,
                                                menuOffset: 8,
                                                menuItemExtent: 45,
                                                menuWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.80,
                                                menuBoxDecoration:
                                                    BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                onPressed: () {
                                                  //press on the item
                                                },
                                                menuItems: <FocusedMenuItem>[
                                                  FocusedMenuItem(
                                                      title: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      trailingIcon:
                                                          Icon(Icons.delete),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      onPressed: () async {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        await databaseMethods
                                                            .changeUserChargeNumber(
                                                                userdata.userID,
                                                                userdata
                                                                    .myChargeNumber,
                                                                -1.0)
                                                            .then(
                                                                (value) async {
                                                          courseReminderDatabaseMethods
                                                              .deleteCourseReminder(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'reminderID'],
                                                                  userdata
                                                                      .userID);

                                                          var response =
                                                              await courseReminderDatabaseMethods
                                                                  .deleteReminder(
                                                            snapshot.data[index]
                                                                ['semester'],
                                                            userdata.email,
                                                            snapshot.data[index]
                                                                ['college'],
                                                            snapshot.data[index]
                                                                ['department'],
                                                            snapshot.data[index]
                                                                ['course'],
                                                            snapshot.data[index]
                                                                ['section'],
                                                          );
                                                          print(userdata
                                                              .myChargeNumber);
                                                          print(
                                                              'Response status: ${response.statusCode}');
                                                          print(
                                                              'Response body: ${response.body}');
                                                          if (response
                                                                  .statusCode ==
                                                              202) {
                                                            _toastInfo(
                                                                'Deleted');
                                                            setState(() {
                                                              loading = false;
                                                              close = true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              subtitle =
                                                                  response.body;
                                                              loading = false;
                                                              close = true;
                                                            });
                                                            _toastInfo(
                                                                subtitle);
                                                          }
                                                        }).then((value) {
                                                          // print('called here');
                                                          // SchedulerBinding.instance
                                                          //     .addPostFrameCallback(
                                                          //         (_) {
                                                          //   Navigator.of(
                                                          //     context,
                                                          //   ).pop();
                                                          // });
                                                        });
                                                      }),
                                                ],
                                                child: ListTile(
                                                  title: buildCard(
                                                    context,
                                                    //  '37', 'a',
                                                    // Timestamp.now(), 'a',
                                                    snapshot.data[index]
                                                            ['college'] +
                                                        ' ' +
                                                        snapshot.data[index]
                                                            ['department'] +
                                                        snapshot.data[index]
                                                            ['course'],
                                                    snapshot.data[index]
                                                        ['section'],
                                                    snapshot.data[index]
                                                        ['submitTime'],
                                                    snapshot.data[index]
                                                        ['semester'],
                                                    fileLocation[index % 4],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: levelCounter(),
                        ),
                        // GestureDetector(
                        //   child: Icon(
                        //     Icons.add_circle_outline_sharp,
                        //     size: 38,
                        //     color: themeOrange,
                        //   ),
                        //   onTap: () {
                        //     Navigator.push(context,
                        //         MaterialPageRoute(builder: (context) {
                        //       return MultiProvider(
                        //           providers: [
                        //             Provider<UserData>.value(
                        //               value: userdata,
                        //             ),
                        //           ],
                        //           child: SeatsNotification(
                        //             userID: userdata.userID,
                        //             userSchool: userdata.school,
                        //             userEmail: userdata.email,
                        //           ));
                        //     }));
                        //     // MaterialPageRoute(
                        //     //     builder: (context) => SeatsNotification(
                        //     //           userID: userdata.userID,
                        //     //           userSchool: userdata.school,
                        //     //           userEmail: userdata.email,
                        //     //         )),
                        //     // );
                        //   },
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget buildCard(
    BuildContext context,
    String course,
    String section,
    Timestamp submittedTime,
    String semester,
    String imageLocation,
  ) {
    double _width = maxWidth;

    // var date = new DateTime.fromMillisecondsSinceEpoch(1000 * submittedTime);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: _width * 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.only(left: 32),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        course.toUpperCase(),
                        style: largeTitleTextStyleBold(themeOrange, 25),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      AutoSizeText(
                        section.toUpperCase() + '  ' + semester,
                        style: largeTitleTextStyle(themeOrange, 17),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    imageLocation,
                    width: 100.0,
                    height: 100.0,
                    scale: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
