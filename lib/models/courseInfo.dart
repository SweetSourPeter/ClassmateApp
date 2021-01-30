// import 'dart:html';

import 'package:app_test/services/database.dart';

class CourseInfo {
  String term;
  String school;
  String myCourseCollge;
  String department;
  String myCourseName;
  String section;

  String courseID;
  int userNumbers;
  String imageUrl; //not used
  List subChats;

  CourseInfo({
    this.term,
    this.school,
    this.myCourseCollge,
    this.department,
    this.myCourseName,
    this.section,
    this.courseID,
    this.userNumbers,
    this.imageUrl,
  });

  Map<String, dynamic> toMapIntoUsers() {
    return {
      'myCourseName': myCourseName,
      'courseID': courseID,
      'section': section,
    };
  }

  Map<String, dynamic> toMapIntoCourses() {
    print('to map intocourse called');
    return {
      'school': school,
      'term': term,
      'college': myCourseCollge,
      'department': department,
      'myCourseName': myCourseName,
      'section': section,
      'courseID': courseID,
      'userNumbers': userNumbers,
      //       school: user.school,
      // term: term,
      // myCourseCollge: myCourseCollege,
      // department: courseDepartment,
      // myCourseName: myCourseName,
      // section: courseSection,
      // userNumbers: 1,
      // courseID: courseId,
    };
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  CourseInfo.fromFirestore(Map<String, dynamic> firestore)
      : school = firestore['school'],
        term = firestore['term'],
        myCourseCollge = firestore['college'],
        department = firestore['department'],
        myCourseName = firestore['myCourseName'],
        section = firestore['section'],
        courseID = firestore['courseID'],
        userNumbers = firestore['userNumbers'] ?? null;
}

//TEMP LIST FOR THE BUILDER
// List<CourseInfo> course = [
//   CourseInfo(
//     myCourseName: 'CS111A1',
//     courseID: 'AFDBVP12sdfad3F2113',
//     userNumbers: 26,
//     department: 'CS',
//     // imageUrl: 'assets/courseimage/cs_course_BG.jpg'
//   ),
//   // CourseInfo(
//   //     myCourseName: 'MA125A3',
//   //     courseID: 'AFDBVP123Fdssd213',
//   //     userNumbers: 6,
//   //     courseCategory: 'MATH',
//   //     imageUrl: 'assets/courseimage/ec_course_BG.jpg'),
//   CourseInfo(
//     myCourseName: 'WR111C1',
//     courseID: 'asdsdfag32231',
//     userNumbers: 16,
//     department: 'WR',
//     // imageUrl: 'assets/courseimage/wr_course_BG.jpg'
//   ),
//   CourseInfo(
//     myCourseName: 'PH123A5',
//     courseID: 'AFDBVP123F2113',
//     userNumbers: 26,
//     department: 'PH',
//     // imageUrl: 'assets/courseimage/ph_course_BG.jpg'
//   ),
//   CourseInfo(
//     myCourseName: 'EC112A2',
//     courseID: 'sadfsg2315ybi8u8h',
//     userNumbers: 56,
//     department: 'ECON',
//     // imageUrl: 'assets/courseimage/econ_course_BG.jpg'
//   ),
// ];

// // final CourseInfo ma123 = CourseInfo(
// //     myCourseName: 'ma123',
// //     courseID: 'AFDBVP123F2113',
// //     userNumbers: 26,
// //     courseCategory: 'MATH');

// // final CourseInfo wr111 = CourseInfo(
// //     myCourseName: 'wr111',
// //     courseID: 'asdsdfag32231',
// //     userNumbers: 16,
// //     courseCategory: 'writing');

// // final CourseInfo ma125 = CourseInfo(
// //     myCourseName: 'MA125',
// //     courseID: 'AFDBVP123Fdssd213',
// //     userNumbers: 6,
//     courseCategory: 'MATH');

// final CourseInfo cs111 = CourseInfo(
//     myCourseName: 'cs111',
//     courseID: 'AFDBVP12sdfad3F2113',
//     userNumbers: 26,
//     courseCategory: 'CS');

// final CourseInfo currentUser = CourseInfo(
//     myCourseName: 'ec112',
//     courseID: 'sadfsg2315ybi8u8h',
//     userNumbers: 56,
//     courseCategory: 'ECON');
