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
  String subtitle = 'Notification will send to your account associated Email.';
  List<String> deviceTypes = ["NextSem", "Summer1", "Summer2"];

  @override
  Widget build(BuildContext context) {
    final databaseMehods = CourseReminderDatabase();
    var uuid = Uuid();
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
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
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: ListView(
                  children: <Widget>[
                    //Hint Text
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                        child: Container(
                          // color: orengeColor,
                          child: Text(
                            'Add notify list',
                            textAlign: TextAlign.left,
                            style: largeTitleTextStyle(Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Text(subtitle),
                    //College
                    SizedBox(
                      height: 30,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: buildInputDecorationPinky(
                        true,
                        Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                        'Select Term',
                        20,
                      ),
                      // hint: Text("Select Term"),
                      value: currentSelectedValue,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() {
                          currentSelectedValue = newValue;
                        });
                        print(currentSelectedValue);
                      },
                      validator: (String val) {
                        return (val == null) ? "Please select the term" : null;
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
                        'College, ex:CAS',
                        20,
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
                        'Department, ex:CS',
                        20,
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
                        'CourseName, ex:111',
                        20,
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
                        'Section, ex:A1',
                        20,
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
                    RaisedGradientButton(
                      width: 100,
                      height: 40,
                      gradient: LinearGradient(
                        colors: <Color>[Colors.red, orengeColor],
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
                            setState(() {
                              subtitle = response.body;
                            });
                          }
                        }
                      },
                      //之后需要根据friendsProvider改这部分display
                      //TODO
                      child: Text(
                        'Start Notify',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
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
    );
  }
}
