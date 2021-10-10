import 'dart:math';

import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
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

class _AddCourseState extends State<AddCourse> {
  var currentSelectedValue;
  List<String> deviceTypes = ["Spring", "Fall", "Winter", "Summer1", "Summer2"];
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    //provider of the course
    final courseProvider = Provider.of<CourseProvider>(context);
    final currentUser = Provider.of<UserData>(context, listen: false);
    double _width = maxWidth;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 37),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Create Course',
            style: largeTitleTextStyleBold(Colors.black, 25),
            textAlign: TextAlign.center,
          ),
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
            //TODO create class in database
            if (formKey.currentState.validate()) {
              courseProvider.saveNewCourse(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Add to List',
            style: largeTitleTextStyleBold(Colors.white, 15),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: maxWidth,
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
                      Icons.close,
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
              body: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: _width * 0.12,
                    right: _width * 0.12,
                    top: 5,
                    bottom: 5,
                  ),
                  child: ListView(
                    children: <Widget>[
                      //Hint TextW
                      _getHeader(),
                      //College
                      SizedBox(
                        height: 30,
                      ),
                      DropdownButtonFormField<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        decoration: buildInputDecorationPinky(
                          false,
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
                          // print(currentSelectedValue);
                          courseProvider.changeTerm(currentSelectedValue);
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
                        onChanged: (value) =>
                            courseProvider.changeCourseCollege(value),
                        controller: collegeTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'College, e.g. CAS',
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
                        onChanged: (value) =>
                            courseProvider.changeCourseDepartment(value),
                        controller: departmentTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Department, e.g. CS',
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
                        onChanged: (value) =>
                            courseProvider.changeCourseName(value),
                        controller: courseNameTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'CourseName, e.g. CS111',
                          20,
                        ),
                        // InputDecoration(hintText: 'CourseName, ex:CS111'),
                        validator: (val) {
                          return val.length > 3
                              ? null
                              : "Please Enter a correct Course Name";
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Section
                      TextFormField(
                        onChanged: (value) =>
                            courseProvider.changeCourseSection(value),
                        controller: sectionTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Section, e.g. A1',
                          20,
                        ),
                        // InputDecoration(hintText: 'Section, ex:A1'),
                        validator: (val) {
                          return val.length > 1
                              ? null
                              : "Please Enter a correct Section";
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _addButton(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Create your class and invite your classmates.',
                        textAlign: TextAlign.center,
                        style: largeTitleTextStyle(Colors.black, 9),
                      ),
                      SizedBox(
                        height: 65,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // createGroupChatAndStartConversation(String courseID, String courseName, String userEmail){
  //   // if(userName != myName) {
  //
  //   List<String> users = [userEmail];
  //   Map<String, dynamic> chatRoomMap = {
  //     'users' : users,
  //     'chatRoomId' : courseID,
  //     'latestMessage' : '',
  //     'lastMessageTime' : 0
  //   };
  //
  //   databaseMethods.createChatRoom(courseID, chatRoomMap);
  //   // } else {
  //   //   print('This is your account!');
  //   // }
  // }
}
