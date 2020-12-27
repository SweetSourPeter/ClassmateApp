import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';
// import 'dart:developer' as dev;

class SearchCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController courseNameTextEditingController =
      new TextEditingController();
  TextEditingController sectionTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;
  var _selectedSemester;
  @override
  Widget build(BuildContext context) {
    final course = Provider.of<List<CourseInfo>>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              //return to previous page;
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _stateBody(context, searchSnapshot, course),
    );
  }

  Widget _stateBody(BuildContext context, QuerySnapshot searchSnapshot,
      List<CourseInfo> course) {
    final userdata = Provider.of<UserData>(context);

    List<String> _semesters = [
      "Spring",
      "Fall",
      "Winter",
      "Summer1",
      "Summer2"
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //Title
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                child: Container(
                  // color: orengeColor,
                  child: Text(
                    'Search Course',
                    textAlign: TextAlign.left,
                    style: largeTitleTextStyle(Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: DropdownButtonFormField<String>(
                value: _selectedSemester,
                items: _semesters.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Semester',
                ),
                validator: (String value) {
                  if (value == "") {
                    return "Semester is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: TextFormField(
                controller: courseNameTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: orengeColor),
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Course name is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: TextFormField(
                controller: sectionTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Section',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: orengeColor),
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Section is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                children: <TextSpan>[
                  TextSpan(text: 'Can\'t find your course? '),
                  TextSpan(
                      text: 'Tap here',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Search for course...');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Provider<UserData>.value(
                                  value: userdata,
                                  child: addCourse(),
                                );
                              },
                            ),
                          );
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => addCourse()));
                        }),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedGradientButton(
                width: 100,
                height: 40,
                gradient: LinearGradient(
                  colors: <Color>[Colors.red, orengeColor],
                ),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  } else {
                    print('valid');
                    await initiateSearch(_selectedSemester);
                    print(searchBegain);
                  }
                  _formKey.currentState.save();
                  searchBegain
                      ? showBottomPopSheet(context, searchList(context, course))
                      : CircularProgressIndicator();
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              // RaisedButton(
              //   color: orengeColor,
              //   child: Text("Search"),
              //   onPressed: () {
              //     if (!_formKey.currentState.validate()) {
              //       return;
              //     } else {
              //       initiateSearch(_selectedSemester);
              //     }
              //     _formKey.currentState.save();
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool searchBegain = false;

  initiateSearch(var _selectedSemester) async {
    var a = _selectedSemester;
    print('aaaa' + '$a');
    var temp = await databaseMethods.getCourse(
      _selectedSemester.toUpperCase(),
      courseNameTextEditingController.text.toUpperCase(),
      sectionTextEditingController.text.toUpperCase(),
    );
    print('get temp');
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.documents != null) {
        if ((searchSnapshot.documents.length >= 1) &&
            (courseNameTextEditingController.text.isNotEmpty) &&
            (sectionTextEditingController.text.isNotEmpty)) {
          print('reached search');
          searchBegain = true;
        }
      }

      //   searchSnapshot = temp;
      //   print('aaaa');
      //   // print(searchSnapshot.toString() + 'aaaaaaaaaaa');
      // print(searchSnapshot.documents.length);
      //   // print(searchTextEditingController.text);
    });
  }

  Widget searchList(context, List<CourseInfo> course) {
    print(searchBegain);
    // var count = searchSnapshot.documents.length;
    // print('index length is ' + '$count');
    return searchBegain
        ? Container(
            height: MediaQuery.of(context).size.height * 0.6,
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(30.0),
            //     topRight: Radius.circular(30.0),
            //   ),
            // ),
            child: Column(
              children: [
                topLineBar(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: searchSnapshot.documents.length,
                      shrinkWrap: true, //when you have listview in column
                      itemBuilder: (context, index) {
                        var id =
                            searchSnapshot.documents[index].data['courseID'];
                        return Provider<List<CourseInfo>>.value(
                          value: course,
                          child: CourseSearchTile(
                            courseName:
                                // "peter",
                                searchSnapshot
                                    .documents[index].data['myCourseName'],
                            section:
                                // "731957665@qq.com",
                                searchSnapshot.documents[index].data['section'],
                            college:
                                // "731957665@qq.com",
                                searchSnapshot.documents[index].data['college'],
                            term: searchSnapshot.documents[index].data['term'],
                            department: searchSnapshot
                                .documents[index].data['department'],
                            courseID: id,
                            isAdd: course
                                .where((element) => element.courseID == id)
                                .isNotEmpty,
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.7,
          );
  }
}

class CourseSearchTile extends StatefulWidget {
  final String courseName;
  final String section;
  final String college;
  final String term;
  final String department;
  final String courseID;
  bool isAdd;
  CourseSearchTile({
    this.courseName,
    this.section,
    this.college,
    this.term,
    this.department,
    this.courseID,
    this.isAdd,
  });

  @override
  _CourseSearchTileState createState() => _CourseSearchTileState();
}

class _CourseSearchTileState extends State<CourseSearchTile> {
  // bool add = widget.isAdd;
  bool add = false;

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<List<CourseInfo>>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    // final course = Provider.of<List<CourseInfo>>(context);

    // print('course name is ' + courseName);
    // print('section is ' + section);
    // print('is ${widget.isAdd}' + widget.courseID);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                (widget.courseName + '  ' + widget.section) ?? '',
                style: simpleTextStyleBlack(),
              ),
              Text(
                widget.college ?? '',
                style: simpleTextStyleBlack(),
              ),
            ],
          ),
          Spacer(),
          Expanded(
            child: (widget.isAdd || add)
                ? RaisedGradientButton(
                    width: 30,
                    height: 40,
                    gradient: LinearGradient(
                      colors: <Color>[Colors.red, orengeColor],
                    ),
                    onPressed: () {
                      //TODO Nothing
                    },
                    //TODO
                    child: Text(
                      'Added',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                : RaisedGradientButton(
                    width: 30,
                    height: 40,
                    gradient: LinearGradient(
                      colors: <Color>[Colors.red, orengeColor],
                    ),
                    onPressed: () {
                      //TODO
                      // print(term);
                      // print(college);
                      // print(department);
                      // print(courseName);
                      // print(courseID);
                      setState(() {
                        add = true;
                        print('set add is $add');
                      });

                      courseProvider.changeTerm(widget.term);
                      courseProvider.changeCourseCollege(widget.college);
                      courseProvider.changeCourseDepartment(widget.department);
                      courseProvider.changeCourseName(widget.courseName);
                      courseProvider.changeCourseSection(widget.section);
                      courseProvider.saveCourseToUser(context, widget.courseID);
                    },
                    //之后需要根据friendsProvider改这部分display
                    //TODO
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          // Spacer(),
        ],
      ),
    );
  }
}
