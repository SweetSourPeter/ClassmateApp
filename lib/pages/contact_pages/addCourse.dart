import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addCourse extends StatefulWidget {
  @override
  _addCourseState createState() => _addCourseState();
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

class _addCourseState extends State<addCourse> {
  var currentSelectedValue;
  List<String> deviceTypes = ["Spring", "Fall", "Winter", "Summer1", "Summer2"];

  @override
  Widget build(BuildContext context) {
    //provider of the course
    final courseProvider = Provider.of<CourseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: orengeColor,
        title: Text("Create Course"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: ListView(
            children: <Widget>[
              //Hint Text
              Text('Create your class and invite your classmates.'),
              //College
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                hint: Text("Select Term"),
                value: currentSelectedValue,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    currentSelectedValue = newValue;
                  });
                  print(currentSelectedValue);
                  courseProvider.changeTerm(currentSelectedValue);
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
              TextFormField(
                onChanged: (value) => courseProvider.changeCourseCollege(value),
                controller: collegeTextEditingController,
                decoration: InputDecoration(hintText: 'College, ex:CAS'),
                validator: (val) {
                  return val.length > 1
                      ? null
                      : "Please Enter a correct College";
                },
              ),
              //Department
              TextFormField(
                onChanged: (value) =>
                    courseProvider.changeCourseDepartment(value),
                controller: departmentTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Department, ex:CS',
                ),
                validator: (val) {
                  return val.length > 1
                      ? null
                      : "Please Enter a correct Department";
                },
              ),
              //Course Name
              TextFormField(
                onChanged: (value) => courseProvider.changeCourseName(value),
                controller: courseNameTextEditingController,
                decoration: InputDecoration(hintText: 'CourseName, ex:CS111'),
                validator: (val) {
                  return val.length > 3
                      ? null
                      : "Please Enter a correct Course Name";
                },
              ),
              //Section
              TextFormField(
                onChanged: (value) => courseProvider.changeCourseSection(value),
                controller: sectionTextEditingController,
                decoration: InputDecoration(hintText: 'Section, ex:A1'),
                validator: (val) {
                  return val.length > 1
                      ? null
                      : "Please Enter a correct Section";
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: lightOrangeColor,
                child: Text('Create'),
                onPressed: () {
                  //TODO create class in database
                  if (formKey.currentState.validate()) {
                    courseProvider.saveCourse(context);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
