import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CourseProvider with ChangeNotifier {
  final databaseMethods = DatabaseMethods();
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
    _myCourseCollege = value;
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

  //save this course into firestore for both user and course collection
  saveNewCourse(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final userdata = Provider.of<UserData>(context, listen: false);
    String userId = user.userID;
    // String courseId = user.school.toUpperCase() +
    //     '_' +
    //     term.toUpperCase() +
    //     '_' +
    //     myCourseCollege.toUpperCase() +
    //     myCourseName.toUpperCase() +
    //     courseSection.toUpperCase();
    // save to Users Document
    String courseId = uuid.v4();
    var newCourseToUser = CourseInfo(
      myCourseName: myCourseName.toUpperCase(),
      section: courseSection.toUpperCase(),
      courseID: courseId,
    );
    databaseMethods.saveCourseToUser(newCourseToUser, userId);
    //save to Courses Document
    var newCourseToCourse = CourseInfo(
      school: userdata.school.toUpperCase(),
      term: term.toUpperCase(),
      myCourseCollege: myCourseCollege.toUpperCase(),
      department: courseDepartment.toUpperCase(),
      myCourseName: myCourseName.toUpperCase(),
      section: courseSection.toUpperCase(),
      userNumbers: 1,
      courseID: courseId,
      adminId: userId,
      groupNoticeText: ''
    );

    databaseMethods.saveCourseToCourse(newCourseToCourse);
    // var newUser = User(userID: userId, admin: true);
    databaseMethods.addUserToCourse(courseId, user);
  }

  removeCourse(BuildContext context, String courseID) {
    final user = Provider.of<User>(context, listen: false);
    // print(user.userID);
    // print(courseID);
    databaseMethods.removeCourseFromUser(courseID, user.userID);
    databaseMethods.removeUserFromCourse(courseID, user.userID);
  }

  //add course to user
  saveCourseToUser(BuildContext context, String courseId) {
    final user = Provider.of<User>(context, listen: false);
    String userId = user.userID;

    var newCourseToUser = CourseInfo(
      myCourseName: myCourseName.toUpperCase(),
      section: courseSection.toUpperCase(),
      courseID: courseId,
    );
    databaseMethods.saveCourseToUser(newCourseToUser, userId);
    // var newUser = User(userID: userId, admin: true);
    databaseMethods.addUserToCourse(courseId, user);
  }
}
