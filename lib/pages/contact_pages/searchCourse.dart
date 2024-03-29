import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class SearchCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKeyGroupID = GlobalKey<FormState>();

  // TextEditingController courseIDTextEditingController =
  //     new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController courseNameTextEditingController =
      new TextEditingController();
  // TextEditingController sectionTextEditingController =
  // new TextEditingController();
  TextEditingController field = TextEditingController();

  String pasteValue;
  QuerySnapshot<Map<String, dynamic>> searchSnapshot;
  String _selectedSemester;
  bool searchBegin;
  String clipboardText;

  void _getClipboard() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    // https://www.meechu.app/#/course/03ef5517-52ae-4d99-ab81-c49552d8f47c
    // sectionTextEditingController.text = 'a';
    if (data != null) {
      setState(() {
        if (data.text.trim().startsWith('https://www.meechu.app/#/course/')) {
          clipboardText = data.text
              .trim()
              .replaceAll('https://www.meechu.app/#/course/', '');
        } else if (data.text.trim().startsWith('www.meechu.app/#/course/')) {
          clipboardText =
              data.text.trim().replaceAll('www.meechu.app/#/course/', '');
        } else if (data.text.trim().startsWith('meechu.app/#/course/')) {
          clipboardText =
              data.text.trim().replaceAll('meechu.app/#/course/', '');
        } else
          clipboardText = data.text.trim();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getClipboard();
    pasteValue = '';
    _selectedSemester = 'Spring';
    searchBegin = false;
  }

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<List<CourseInfo>>(context);

    // _getClipboard(course);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
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
      ),
    );
  }

  Widget _stateBody(BuildContext context, QuerySnapshot searchSnapshot,
      List<CourseInfo> course) {
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

    bool _validate() {
      //not v4 uuid
      return RegExp(
              r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$')
          .hasMatch(clipboardText == null ? '' : clipboardText.toUpperCase());
    }

    _addButton() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        height: 59,
        width: _width * 1,
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
            if (!_formKey.currentState.validate() && !_validate()) {
              print('both invalid');
              return;
            } else if (_validate() &&
                courseNameTextEditingController.text.isEmpty) {
              await initiateURLSearch(clipboardText, context);
              print(searchBegin);
            } else {
              print('valid');
              await initiateSearch(_selectedSemester, context);
              print(searchBegin);
            }
            _formKey.currentState.save();
            searchBegin
                ? showBottomPopSheet(context, searchList(context, course))
                : Center(child: CircularProgressIndicator());
          },
          child: Text(
            (_validate() && courseNameTextEditingController.text.isEmpty)
                ? 'Click to join'
                : 'Search',
            textAlign: TextAlign.center,
            style: largeTitleTextStyleBold(Colors.white, 16),
          ),
        ),
      );
    }

    // _urlForm() {
    //   return Form(
    //     key: _formKeyGroupID,
    //     child: Container(
    //       height: 100,
    //       child: TextFormField(
    //         controller: courseIDTextEditingController,
    //         decoration: buildInputDecorationPinky(
    //           false,
    //           Icon(
    //             Icons.access_time,
    //             color: Colors.black,
    //           ),
    //           'Course Group ID',
    //           11,
    //         ),
    //         validator: (String value) {
    //           if (!RegExp(
    //                   r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$')
    //               .hasMatch(clipboardText.toUpperCase())) {
    //             return "Group ID is not Valid";
    //           }
    //           return null;
    //         },
    //       ),
    //     ),
    //   );
    // }
    final userdata = Provider.of<UserData>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(
        left: _width * 0.12,
        right: _width * 0.12,
        top: 5,
        bottom: 5,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _getHeader(),
            // _urlForm(),
            SizedBox(
              height: 45,
            ),
            // Text(
            //   'OR',
            //   style: largeTitleTextStyleBold(themeOrange, 20),
            //   textAlign: TextAlign.center,
            // ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 55,
                    ),
                    Container(
                      height: 85,
                      child: DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        items:
                            _semesters.map<DropdownMenuItem<String>>((value) {
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
                          if ((value == "" || value == null) && !_validate()) {
                            return "Term is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 31,
                    ),
                    Container(
                      height: 85,
                      child: TextFormField(
                        controller: courseNameTextEditingController,
                        decoration: buildInputDecorationPinky(
                          false,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          'Course Name, e.g. CS111',
                          11,
                        ),
                        validator: (String value) {
                          if ((value.isEmpty) && !_validate()) {
                            return "Course name is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    // Container(
                    //   height: 85,
                    //   child: TextFormField(
                    //     controller: sectionTextEditingController,
                    //     decoration: buildInputDecorationPinky(
                    //       false,
                    //       Icon(
                    //         Icons.access_time,
                    //         color: Colors.black,
                    //       ),
                    //       'Section, e.g. A1',
                    //       11,
                    //     ),
                    //     // validator: (String value) {
                    //     //   if (!_validate()) {
                    //     //     return "Section is required";
                    //     //   }
                    //     //   return null;
                    //     // },
                    //   ),
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    //     children: <TextSpan>[
                    //       TextSpan(text: 'I Have Course Card '),
                    //       TextSpan(
                    //           text: 'URL',
                    //           style: TextStyle(color: Colors.blue),
                    //           recognizer: TapGestureRecognizer()
                    //             ..onTap = () async {
                    //               FlutterClipboard.paste().then((value) async {
                    //                 setState(() {
                    //                   field.text = value;
                    //                   pasteValue = value;
                    //                 });
                    //                 print('Clipboard Text: $pasteValue');
                    //                 bool urlValid = false;
                    //                 if (pasteValue
                    //                     .startsWith('https://na-cc.com/')) {
                    //                   searchBegin = true;
                    //                   print('start correct');
                    //                   var splitTemp = pasteValue.split('/');
                    //                   print(splitTemp[4]);
                    //                   urlValid = true;
                    //                   await initiateURLSearch(splitTemp[4]);
                    //                 }

                    //                 searchBegin
                    //                     ? showBottomPopSheet(context,
                    //                         searchList(context, course))
                    //                     : CircularProgressIndicator();
                    //               });
                    //             }),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    //     children: <TextSpan>[
                    //       TextSpan(text: 'Can\'t find your course? '),
                    //       TextSpan(
                    //           text: 'Tap here',
                    //           style: TextStyle(color: Colors.blue),
                    //           recognizer: TapGestureRecognizer()
                    //             ..onTap = () {
                    //               print('Search for course...');
                    //               Navigator.pushReplacement(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) {
                    //                     return Provider<UserData>.value(
                    //                       value: userdata,
                    //                       child: addCourse(),
                    //                     );
                    //                   },
                    //                 ),
                    //               );
                    //               // Navigator.pushReplacement(
                    //               //     context,
                    //               //     MaterialPageRoute(
                    //               //         builder: (context) => addCourse()));
                    //             }),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height:
                  (_validate() && courseNameTextEditingController.text.isEmpty)
                      ? 40
                      : 0,
            ),
            (_validate() && courseNameTextEditingController.text.isEmpty)
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Found',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // 03ef5517-52ae-4d99-ab81-c49552d8f47c
                        TextSpan(
                            text: ' Shared Course ID !',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: themeOrange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (!_formKey.currentState.validate() &&
                                    !_validate()) {
                                  print('both invalid');
                                  return;
                                } else if (_validate() &&
                                    courseNameTextEditingController
                                        .text.isEmpty) {
                                  await initiateURLSearch(
                                      clipboardText, context);
                                  print(searchBegin);
                                } else {
                                  print('valid');
                                  await initiateSearch(
                                      _selectedSemester, context);
                                  print(searchBegin);
                                }
                                _formKey.currentState.save();
                                searchBegin
                                    ? showBottomPopSheet(
                                        context, searchList(context, course))
                                    : Center(
                                        child: CircularProgressIndicator());
                              }),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            _addButton(),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Unable to find your course? ',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  TextSpan(
                      text: 'Create New',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            decoration: TextDecoration.underline,
                            color: themeOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Provider<UserData>.value(
                                  value: userdata,
                                  child: AddCourse(),
                                );
                              },
                            ),
                          );
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  initiateSearch(var _selectedSemester, BuildContext context) async {
    final userdata = Provider.of<UserData>(context, listen: false);
    // var a = _selectedSemester;
    final temp = await databaseMethods.getCourse(
      _selectedSemester.toUpperCase(),
      courseNameTextEditingController.text.toUpperCase(),
      // sectionTextEditingController.text.toUpperCase(),
      userdata.school.toUpperCase(),
    );
    print('get temp');
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      // if (searchSnapshot.docs != null) {
      //   if ((searchSnapshot.docs.length >= 1) &&
      //       (courseNameTextEditingController.text.isNotEmpty) &&
      //       (sectionTextEditingController.text.isNotEmpty)) {
      //     print('reached search');
      //     searchBegin = true;
      //   }
      // }
      if (courseNameTextEditingController.text.isNotEmpty) {
        print('reached search');
        searchBegin = true;
      }
    });
  }

  initiateURLSearch(String courseId, BuildContext context) async {
    final userdata = Provider.of<UserData>(context, listen: false);
    print('URL SEARCH START');
    print(courseId);
    var temp = await databaseMethods.getCourseInfoById(
      courseId,
      userdata.school.toUpperCase(),
    );
    setState(() {
      searchSnapshot = temp;
      print(searchSnapshot.docs);
      if (searchSnapshot.docs != null) {
        if ((searchSnapshot.docs.length >= 1) && (clipboardText.isNotEmpty)) {
          print('reached search');
          searchBegin = true;
        }
      }
    });
  }

  searchList(context, List<CourseInfo> course) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final userdata = Provider.of<UserData>(context, listen: false);

    print('SearchList create');
    print('searchBegin: ' + searchBegin.toString());
    print('searchSnapshot: ');
    // print(searchSnapshot.docs.first);
    return searchBegin && searchSnapshot.docs.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(
              top: 18,
            ),
            child: Container(
              // decoration: new BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: new BorderRadius.only(
              //       topLeft: const Radius.circular(30.0),
              //       topRight: const Radius.circular(30.0),
              //     )),
              height: _height * 0.6,
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
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Color(0xFFEBEBEB),
                            thickness: 0.8,
                          );
                        },
                        itemCount: searchSnapshot.docs.length,
                        shrinkWrap: true, //when you have listview in column
                        itemBuilder: (context, index) {
                          var id =
                              searchSnapshot.docs[index].data()['courseID'] ??
                                  '';

                          print('inside');
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
                                  searchSnapshot.docs[index]
                                          .data()['section'] ??
                                      '',
                              college:
                                  // "731957665@qq.com",
                                  searchSnapshot.docs[index]
                                          .data()['college'] ??
                                      '',
                              term: searchSnapshot.docs[index].data()['term'] ??
                                  '',
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
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              top: 18,
            ),
            child: Container(
              // decoration: new BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: new BorderRadius.only(
              //       topLeft: const Radius.circular(30.0),
              //       topRight: const Radius.circular(30.0),
              //     )),
              height: MediaQuery.of(context).size.height * 0.5,

              // decoration: BoxDecoration(
              //   color: Colors.blue,
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(30.0),
              //     topRight: Radius.circular(30.0),
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    topLineBar(),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        height: _height * 0.6 * 0.25,
                        width: _width * 0.73,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            FittedBox(
                              child: Image.asset('assets/icon/sorryBox.png'),
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: _width * 0.73 * 0.09),
                              child: Text(
                                "Sorry,we didn\'t find the course",
                                style: largeTitleTextStyle(Colors.black, 16),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: _width * 0.4,
                        width: _width * 0.4,
                        child: FittedBox(
                          child: Image.asset('assets/icon/failToFind.png'),
                          fit: BoxFit.fill,
                        )),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Check the info you entered\n or ',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          TextSpan(
                              text: 'Create a course group ',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: themeOrange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Provider<UserData>.value(
                                          value: userdata,
                                          child: AddCourse(),
                                        );
                                      },
                                    ),
                                  );
                                }),
                          TextSpan(
                            text: 'for others to join',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
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
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    // print('course name is ' + courseName);
    // print('section is ' + section);
    // print('is ${widget.isAdd}' + widget.courseID);
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(left: _width * 0.056, right: _width * 0.056, top: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                (widget.courseName + '  ' + widget.section) ?? '',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                widget.term ?? '',
                style: simpleTextStyle(Colors.black, 12),
              ),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: (widget.isAdd || add)
                ? RaisedButton(
                    hoverElevation: 0,
                    highlightColor: Color(0xDA6D39),
                    highlightElevation: 0,
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: themeOrange, width: 1.0),
                    ),
                    onPressed: () {
                      //TODO Nothing
                      if (!widget.isAdd) {
                        setState(() {
                          add = false;
                          print('set add is $add');
                        });
                        courseProvider.removeCourse(context, widget.courseID);
                      }
                    },
                    child: Text(
                      'Added',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeOrange,
                      ),
                    ),
                  )
                : RaisedButton(
                    hoverElevation: 0,
                    highlightColor: Color(0xDA6D39),
                    highlightElevation: 0,
                    elevation: 0,
                    color: themeOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
                      'Add',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
