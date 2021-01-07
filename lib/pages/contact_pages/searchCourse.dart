import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';
import 'package:string_validator/string_validator.dart';

class SearchCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController courseIDTextEditingController =
      new TextEditingController();
  TextEditingController courseNameTextEditingController =
      new TextEditingController();
  TextEditingController sectionTextEditingController =
      new TextEditingController();
  TextEditingController field = TextEditingController();
  String pasteValue = '';
  QuerySnapshot searchSnapshot;
  var _selectedSemester;
  @override
  Widget build(BuildContext context) {
    final course = Provider.of<List<CourseInfo>>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: Container(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: themeOrange,
              onPressed: () {
                //return to previous page;
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: _stateBody(context, searchSnapshot, course),
      ),
    );
  }

  Widget _stateBody(BuildContext context, QuerySnapshot searchSnapshot,
      List<CourseInfo> course) {
    print('aaaaa');
    print(RegExp(
            r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$')
        .hasMatch('9d1bca5c-0df4-4bef-814a-d26fbab9d1ad'.toUpperCase()));
    final userdata = Provider.of<UserData>(context);

    List<String> _semesters = [
      "Spring",
      "Fall",
      "Winter",
      "Summer1",
      "Summer2"
    ];
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 37),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Search for the course group',
            style: largeTitleTextStyleBold(Colors.black, 20),
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
            'Add to List',
            style: largeTitleTextStyleBold(Colors.white, 15),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _getHeader(),
            Flexible(
              child: TextFormField(
                maxLines: 4,
                controller: courseNameTextEditingController,
                decoration: buildInputDecorationPinky(
                  false,
                  Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  'Course Group ID',
                  11,
                ),
                validator: (String value) {
                  if (!RegExp(
                          r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$')
                      .hasMatch(value.toUpperCase())) {
                    return "Group ID is not Valid";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              'OR',
              style: largeTitleTextStyleBold(themeOrange, 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 17,
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
                decoration: buildInputDecorationPinky(
                  false,
                  Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  'Term',
                  11,
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
              height: 31,
            ),
            Flexible(
              child: TextFormField(
                controller: courseIDTextEditingController,
                decoration: buildInputDecorationPinky(
                  false,
                  Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  'Course Name, e.g. 111',
                  11,
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
              height: 31,
            ),
            Flexible(
              child: TextFormField(
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
                  TextSpan(text: 'I Have Course Card '),
                  TextSpan(
                      text: 'URL',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          FlutterClipboard.paste().then((value) async {
                            setState(() {
                              field.text = value;
                              pasteValue = value;
                            });
                            print('Clipboard Text: $pasteValue');
                            bool urlValid = false;
                            if (pasteValue.startsWith('https://na-cc.com/')) {
                              searchBegain = true;
                              print('start correct');
                              var splitTemp = pasteValue.split('/');
                              print(splitTemp[4]);
                              urlValid = true;
                              await initiateURLSearch(splitTemp[4]);
                            }

                            searchBegain
                                ? showBottomPopSheet(
                                    context, searchList(context, course))
                                : CircularProgressIndicator();
                          });
                        }),
                ],
              ),
            ),
            SizedBox(
              height: 5,
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
            _addButton(),
          ],
        ),
      ),
    );
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool searchBegain = false;

  initiateSearch(var _selectedSemester) async {
    var a = _selectedSemester;
    var temp = await databaseMethods.getCourse(
      _selectedSemester.toUpperCase(),
      courseNameTextEditingController.text.toUpperCase(),
      sectionTextEditingController.text.toUpperCase(),
    );
    print('get temp');
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.docs != null) {
        if ((searchSnapshot.docs.length >= 1) &&
            (courseNameTextEditingController.text.isNotEmpty) &&
            (sectionTextEditingController.text.isNotEmpty)) {
          print('reached search');
          searchBegain = true;
        }
      }
    });
  }

  initiateURLSearch(String courseId) async {
    var temp = await databaseMethods.getCourseInfo(
      courseId,
    );
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.docs != null) {
        if ((searchSnapshot.docs.length >= 1) &&
            (courseNameTextEditingController.text.isNotEmpty) &&
            (sectionTextEditingController.text.isNotEmpty)) {
          print('reached search');
          searchBegain = true;
        }
      }
    });
  }

  Widget searchList(context, List<CourseInfo> course) {
    print(searchBegain);

    return searchBegain && true
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
                      itemCount: searchSnapshot.docs.length,
                      shrinkWrap: true, //when you have listview in column
                      itemBuilder: (context, index) {
                        var id =
                            searchSnapshot.docs[index].data()['courseID'] ?? '';
                        return Provider<List<CourseInfo>>.value(
                          value: course,
                          child: CourseSearchTile(
                            courseName:
                                // "peter",
                                searchSnapshot.docs[index]
                                        .data()['myCourseName'] ??
                                    '',
                            section:
                                // "731957665@qq.com",
                                searchSnapshot.docs[index].data()['section'] ??
                                    '',
                            college:
                                // "731957665@qq.com",
                                searchSnapshot.docs[index].data()['college'] ??
                                    '',
                            term:
                                searchSnapshot.docs[index].data()['term'] ?? '',
                            department: searchSnapshot.docs[index]
                                    .data()['department'] ??
                                '',
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
