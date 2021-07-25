import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/explore_pages/loadingSeatReminderList.dart';
import 'package:app_test/pages/explore_pages/seatNotifyAdd.dart';
import 'package:app_test/services/course_reminder_db.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/modals.dart';

class SeatNotifyDashboard extends StatefulWidget {
  final String userID;
  final String userSchool;
  final String userEmail;
  SeatNotifyDashboard({Key key, this.userID, this.userSchool, this.userEmail})
      : super(
          key: key,
        );

  @override
  _SeatNotifyDashboardState createState() => _SeatNotifyDashboardState();
}

class _SeatNotifyDashboardState extends State<SeatNotifyDashboard> {
  String subtitle;
  final databaseMehods = CourseReminderDatabase();
  List<String> fileLocation = [
    'assets/icon/catPaw1.png',
    'assets/icon/catPaw3.png',
    'assets/icon/catPaw2.png',
    'assets/icon/catPaw4.png',
  ];
  @override
  Widget build(BuildContext context) {
    Stream<List<Map<String, dynamic>>> data =
        databaseMehods.getUserReminderLists(widget.userID);
    double modal_height = MediaQuery.of(context).size.height - 60;
    _toastInfo(String info) {
      Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER,
      );
    }

    return Container(
        decoration: BoxDecoration(
          color: riceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            // bottomLeft: Radius.circular(30.0),
            // bottomRight: Radius.circular(30.0),
          ),
        ),
        height: modal_height,
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
            color: riceColor,
            child:
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
                        'Your notify list',
                        textAlign: TextAlign.center,
                        style: largeTitleTextStyleBold(Colors.black, 28),
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
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
                                  child:
                                      Text("You dont have a notification list"),
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
                                      menuWidth: getRealWidth(
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          0.80,
                                      menuBoxDecoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      onPressed: () {
                                        //press on the item
                                      },
                                      menuItems: <FocusedMenuItem>[
                                        FocusedMenuItem(
                                            title: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            trailingIcon: Icon(Icons.delete),
                                            backgroundColor: Colors.redAccent,
                                            onPressed: () async {
                                              print('delete reminder called');
                                              print(snapshot.data[index]
                                                      ['reminderID']
                                                  .toString());
                                              databaseMehods
                                                  .deleteCourseReminder(
                                                      snapshot.data[index]
                                                          ['reminderID'],
                                                      widget.userID);

                                              var response =
                                                  await databaseMehods
                                                      .deleteReminder(
                                                snapshot.data[index]
                                                    ['semester'],
                                                widget.userEmail,
                                                snapshot.data[index]['college'],
                                                snapshot.data[index]
                                                    ['department'],
                                                snapshot.data[index]['course'],
                                                snapshot.data[index]['section'],
                                              );
                                              print(
                                                  'Response status: ${response.statusCode}');
                                              print(
                                                  'Response body: ${response.body}');
                                              if (response.statusCode == 202) {
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  subtitle = response.body;
                                                });
                                              }
                                            }),
                                      ],
                                      child: ListTile(
                                        title: buildCard(
                                          context,
                                          //  '37', 'a',
                                          // Timestamp.now(), 'a',
                                          snapshot.data[index]['college'] +
                                              ' ' +
                                              snapshot.data[index]
                                                  ['department'] +
                                              snapshot.data[index]['course'],
                                          snapshot.data[index]['section'],
                                          snapshot.data[index]['submitTime'],
                                          snapshot.data[index]['semester'],
                                          fileLocation[index % 4],
                                        ),
                                      ),
                                    );
                                  },
                                );
                      }
                    }),
                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.add_circle_outline_sharp,
                    size: 38,
                    color: themeOrange,
                  ),
                  onTap: () {
                    _toastInfo('This feature is only available in Mobile App');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => SeatsNotification(
                    //             userID: widget.userID,
                    //             userSchool: widget.userSchool,
                    //             userEmail: widget.userEmail,
                    //           )),
                    // );
                  },
                )
              ],
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
    double _width = getRealWidth(MediaQuery.of(context).size.width);

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
