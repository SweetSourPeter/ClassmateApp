import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CourseProvider with ChangeNotifier {
  final databaseMehods = DatabaseMehods();
  String _term;
  String _myCourseSchool;
  String _myCourseCollege;
  String _courseDepartment;
  String _myCourseName;
  String _courseSection;

  String _courseID;
  int _userNumbers;
  var uuid = Uuid(); // create a unique ID for this new course

  //getters not used yet
  String get term => _term;
  String get myCourseSchool => _myCourseSchool;
  String get myCourseCollege => _myCourseCollege;
  String get myCourseName => _myCourseName;
  String get courseID => _courseID;
  int get userNumbers => _userNumbers;
  String get courseDepartment => _courseDepartment;
  String get courseSection => _courseSection;

  //setters
  changeTerm(String value) {
    _term = value;
    notifyListeners();
  }

  changeCourseSchool(String value) {
    _myCourseSchool = value;
    notifyListeners();
  }

  changeCourseCollege(String value) {
    _myCourseSchool = value;
    notifyListeners();
  }

  changeCourseName(String value) {
    _myCourseName = value;
    notifyListeners();
  }

  changeCourseID(String value) {
    _courseID = value;
    notifyListeners();
  }

  changeCourseDepartment(String value) {
    _courseDepartment = value;
    notifyListeners();
  }

  changeCourseSection(String value) {
    _courseSection = value;
    notifyListeners();
  }

  //save this course into firestore
  saveCourse(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    String userId = user.userID;
    // String courseId = user.school.toUpperCase() +
    //     '_' +
    //     term.toUpperCase() +
    //     '_' +
    //     myCourseCollege.toUpperCase() +
    //     myCourseName.toUpperCase() +
    //     courseSection.toUpperCase();
    //save to Users Document
    String courseId = uuid.v4();
    var newCourseToUser = CourseInfo(
      myCourseName: myCourseName,
      courseID: courseId,
    );
    databaseMehods.saveCourseToUser(newCourseToUser, userId);
    //save to Courses Document
    var newCourseToCourse = CourseInfo(
      myCourseName: myCourseName,
      courseID: courseId,
      department: courseDepartment,
      userNumbers: 1,
    );
    databaseMehods.saveCourseToCourse(newCourseToCourse);
    var newUser = User(userID: userId, admin: true);
    databaseMehods.addUserToCourse(courseId, newUser);
  }

  removeCourse(BuildContext context, String courseID) {
    final user = Provider.of<User>(context, listen: false);
    databaseMehods.removeCourseFromUser(courseID, user.userID);
    databaseMehods.removeCourseFromCourse(courseID, user.userID);
  }
}
