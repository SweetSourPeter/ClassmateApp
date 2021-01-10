import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/course_reminder_db.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SeatsNotification extends StatefulWidget {
  final String userID;
  final String userSchool;
  final String userEmail;
  const SeatsNotification(
      {Key key, this.userID, this.userSchool, this.userEmail})
      : super(key: key);

  @override
  _SeatsNotificationState createState() => _SeatsNotificationState();
}

final formKey = GlobalKey<FormState>();

TextEditingController collegeTextEditingController =
    new TextEditingController();
TextEditingController departmentTextEditingController =
    new TextEditingController();
TextEditingController courseNameTextEditingController =
    new TextEditingController();
TextEditingController sectionTextEditingController =
    new TextEditingController();

class _SeatsNotificationState extends State<SeatsNotification> {
  var currentSelectedValue;
  String subtitle = '*Notification would be sent to associated emails';
  List<String> deviceTypes = ["NextSem", "Summer1", "Summer2"];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final databaseMehods = CourseReminderDatabase();
    var uuid = Uuid();
    _getHeader() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Add Notify List',
              textAlign: TextAlign.center,
              style: largeTitleTextStyleBold(Colors.black, 25),
            ),
          ],
        ),
      );
    }

    _addButton() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        height: 59,
        width: _width * 0.7,
        child: RaisedButton(
          hoverElevation: 0,
          highlightColor: Color(0xDA6D39),
          highlightElevation: 0,
          elevation: 0,
          color: themeOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async {
            String reminderID = uuid.v4();
            //TODO create class in database
            if (formKey.currentState.validate()) {
              databaseMehods.saveUserReminder(
                widget.userSchool,
                currentSelectedValue,
                widget.userEmail,
                collegeTextEditingController.text,
                departmentTextEditingController.text,
                courseNameTextEditingController.text,
                sectionTextEditingController.text,
                DateTime.now(),
                widget.userID,
                reminderID,
              );
              var response = await databaseMehods.createReminder(
                currentSelectedValue,
                widget.userEmail,
                collegeTextEditingController.text,
                departmentTextEditingController.text,
                courseNameTextEditingController.text,
                sectionTextEditingController.text,
              );
              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');
              if (response.statusCode == 202) {
                Navigator.pop(context);
              } else {
                if (mounted) {
                  return;
                }
                setState(() {
                  subtitle = response.body;
                });
              }
            }
          },
          child: Text(
            'Add to List',
            style: largeTitleTextStyleBold(Colors.white, 15),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                color: themeOrange,
                size: 30,
              ),
            ),
          ),
          // centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          // title: Text("Create Course"),
        ),
        body: widget.userSchool == 'Boston University'
            ? Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                  child: ListView(
                    children: <Widget>[
                      //Hint Text
                      _getHeader(),
                      //College
                      SizedBox(
                        height: 37,
                      ),
                      DropdownButtonFormField<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: themeOrange,
                          size: 30,
                        ),
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Term',
                          11,
                        ),
                        value: currentSelectedValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedValue = newValue;
                          });
                          print(currentSelectedValue);
                        },
                        validator: (String val) {
                          return (val == null)
                              ? "Please select the term"
                              : null;
                        },
                        items: deviceTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toUpperCase(),
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: collegeTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'College, e.g. CAS',
                          11,
                        ),
                        // InputDecoration(hintText: 'College, ex:CAS'),
                        validator: (val) {
                          return val.length > 1
                              ? null
                              : "Please Enter a correct College";
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Department
                      TextFormField(
                        controller: departmentTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Department, e.g. CS',
                          11,
                        ),
                        // InputDecoration(
                        //   hintText: 'Department, ex:CS',
                        // ),
                        validator: (val) {
                          return val.length > 1
                              ? null
                              : "Please Enter a correct Department";
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Course Name
                      TextFormField(
                        controller: courseNameTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Course Name, e.g. 111',
                          11,
                        ),
                        // InputDecoration(hintText: 'CourseName, ex:CS111'),
                        validator: (val) {
                          return val.length > 2
                              ? null
                              : "Please Enter a correct Course Name";
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Section
                      TextFormField(
                        controller: sectionTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Section, e.g. A1',
                          11,
                        ),
                        // InputDecoration(hintText: 'Section, ex:A1'),
                        validator: (val) {
                          if (widget.userSchool == 'Boston University') {
                            return val.length > 1
                                ? null
                                : "Please Enter a correct Section";
                          } else {
                            return 'We only provide this service to BU students';
                          }
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _addButton(),
                      // RaisedGradientButton(
                      //   width: 100,
                      //   height: 40,
                      //   gradient: LinearGradient(
                      //     colors: <Color>[Colors.red, orengeColor],
                      //   ),
                      //   onPressed: () async {
                      //     String reminderID = uuid.v4();
                      //     //TODO create class in database
                      //     if (formKey.currentState.validate()) {
                      //       databaseMehods.saveUserReminder(
                      //         widget.userSchool,
                      //         currentSelectedValue,
                      //         widget.userEmail,
                      //         collegeTextEditingController.text,
                      //         departmentTextEditingController.text,
                      //         courseNameTextEditingController.text,
                      //         sectionTextEditingController.text,
                      //         DateTime.now(),
                      //         widget.userID,
                      //         reminderID,
                      //       );
                      //       var response = await databaseMehods.createReminder(
                      //         currentSelectedValue,
                      //         widget.userEmail,
                      //         collegeTextEditingController.text,
                      //         departmentTextEditingController.text,
                      //         courseNameTextEditingController.text,
                      //         sectionTextEditingController.text,
                      //       );
                      //       print('Response status: ${response.statusCode}');
                      //       print('Response body: ${response.body}');
                      //       if (response.statusCode == 202) {
                      //         Navigator.pop(context);
                      //       } else {
                      //         setState(() {
                      //           subtitle = response.body;
                      //         });
                      //       }
                      //     }
                      //   },
                      //   child: Text(
                      //     'Add to List',
                      //     style: largeTitleTextStyleBold(Colors.white, 15),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: largeTitleTextStyle(Colors.black, 9),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 56),
                  child: Text(
                    'Sorry we dont have seat reminder service in your school yet.',
                    textAlign: TextAlign.center,
                    style: simpleTextStyle(Colors.black, 16),
                  ),
                ),
              ),
      ),
    );
  }
}
