import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/addCourse.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';

class SearchGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController courseNameTextEditingController =
      new TextEditingController();
  TextEditingController sectionTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;
  var _selectedSemester;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: orengeColor,
        leading: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              //TODO
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                //return to previous page;

                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text('Search Course'),
        centerTitle: true,
      ),
      body: _stateBody(context, searchSnapshot),
    );
  }

  Widget _stateBody(BuildContext context, QuerySnapshot searchSnapshot) {
    final userdata = Provider.of<UserData>(context);
    // var _selectedYear;
    // List<String> _years = [
    //   "2019",
    //   "2020",
    //   "2021",
    // ];

    List<String> _semesters = [
      "Spring",
      "Fall",
      "Winter",
      "Summer1",
      "Summer2"
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // Flexible(
                //   child: DropdownButtonFormField<String>(
                //     value: _selectedYear,
                //     items: _years.map<DropdownMenuItem<String>>((value) {
                //       return DropdownMenuItem(
                //         child: Text(value),
                //         value: value,
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         _selectedYear = value;
                //       });
                //     },
                //     decoration: InputDecoration(
                //       labelText: 'Year',
                //     ),
                //     validator: (String value) {
                //       if (value == "") {
                //         return "Year is required";
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                // SizedBox(
                //   width: 25,
                // ),
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
              ],
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
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: orengeColor,
                child: Text("Search"),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  } else {
                    initiateSearch(_selectedSemester);
                  }
                  _formKey.currentState.save();
                },
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }

  DatabaseMehods databaseMehods = new DatabaseMehods();
  bool searchBegain = false;
  initiateSearch(var _selectedSemester) async {
    var a = _selectedSemester;
    print('aaaa' + '$a');
    var temp = await databaseMehods.getCourse(
      _selectedSemester.toUpperCase(),
      courseNameTextEditingController.text.toUpperCase(),
      sectionTextEditingController.text.toUpperCase(),
    );
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.documents != null) {
        if ((searchSnapshot.documents.length >= 1) &&
            (courseNameTextEditingController.text.isNotEmpty) &&
            (sectionTextEditingController.text.isNotEmpty)) {
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

  Widget searchList() {
    // var count = searchSnapshot.documents.length;
    // print('index length is ' + '$count');
    return searchBegain
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true, //when you have listview in column
            itemBuilder: (context, index) {
              return SearchTile(
                courseName:
                    // "peter",
                    searchSnapshot.documents[index].data['myCourseName'],
                section:
                    // "731957665@qq.com",
                    searchSnapshot.documents[index].data['section'],
              );
            })
        : Container();
  }
}

class SearchTile extends StatelessWidget {
  final String courseName;
  final String section;
  SearchTile({this.courseName, this.section});

  @override
  Widget build(BuildContext context) {
    // print('course name is ' + courseName);
    // print('section is ' + section);
    return Container(
      color: orengeColor,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                courseName ?? '',
                style: simpleTextStyleBlack(),
              ),
              Text(
                section ?? '',
                style: simpleTextStyleBlack(),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
