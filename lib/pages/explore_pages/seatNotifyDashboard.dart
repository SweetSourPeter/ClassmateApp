import 'dart:math';

import 'package:app_test/pages/explore_pages/loadingSeatReminderList.dart';
import 'package:app_test/pages/explore_pages/seatNotifyAdd.dart';
import 'package:app_test/services/course_reminder_db.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
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
  @override
  Widget build(BuildContext context) {
    Stream<List<Map<String, dynamic>>> data =
        databaseMehods.getUserReminderLists(widget.userID);
    double modal_height = MediaQuery.of(context).size.height - 50;

    return Container(
        height: modal_height,
        child: Container(
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
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25, top: 20, bottom: 0),
                  child: Container(
                    // color: orengeColor,
                    child: Row(
                      children: [
                        Text(
                          'Your notify list',
                          textAlign: TextAlign.left,
                          style: largeTitleTextStyle(Colors.black, 26),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 28,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeatsNotification(
                                        userID: widget.userID,
                                        userSchool: widget.userSchool,
                                        userEmail: widget.userEmail,
                                      )),
                            );
                          },
                        )
                      ],
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
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return FocusedMenuHolder(
                                        blurSize: 4,
                                        menuItemExtent: 45,
                                        menuWidth:
                                            MediaQuery.of(context).size.width *
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
                                                  snapshot.data[index]
                                                      ['college'],
                                                  snapshot.data[index]
                                                      ['department'],
                                                  snapshot.data[index]
                                                      ['course'],
                                                  snapshot.data[index]
                                                      ['section'],
                                                );
                                                print(
                                                    'Response status: ${response.statusCode}');
                                                print(
                                                    'Response body: ${response.body}');
                                                if (response.statusCode ==
                                                    202) {
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
                                                  snapshot.data[index]
                                                      ['course'],
                                              snapshot.data[index]['section'],
                                              snapshot.data[index]
                                                  ['submitTime'],
                                              snapshot.data[index]['semester']),
                                        ),
                                      );
                                    },
                                  );
                        }
                      }))
            ],
          ),
          // ),
        ));
  }

  Widget buildCard(
    BuildContext context,
    String course,
    String section,
    Timestamp submittedTime,
    String semester,
  ) {
    // var date = new DateTime.fromMillisecondsSinceEpoch(1000 * submittedTime);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: <Widget>[
            AutoSizeText(
              course.toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              maxLines: 1,
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Section: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Semester: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Submit Date:  ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        section.toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        semester.toLowerCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        submittedTime.toDate().month.toString() +
                            ' / ' +
                            submittedTime.toDate().day.toString(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ],
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
