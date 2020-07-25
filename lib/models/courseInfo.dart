// import 'dart:html';

class CourseInfo {
  String myCourseName;
  String courseID;
  int userNumbers;
  String courseCategory;
  String imageUrl;

  CourseInfo(
      {this.myCourseName,
      this.courseID,
      this.courseCategory,
      this.userNumbers,
      this.imageUrl});
}

//TEMP LIST FOR THE BUILDER
List<CourseInfo> course = [
  CourseInfo(
      myCourseName: 'CS111A1',
      courseID: 'AFDBVP12sdfad3F2113',
      userNumbers: 26,
      courseCategory: 'CS',
      imageUrl: 'assets/courseimage/cs_course_BG.jpg'),
  // CourseInfo(
  //     myCourseName: 'MA125A3',
  //     courseID: 'AFDBVP123Fdssd213',
  //     userNumbers: 6,
  //     courseCategory: 'MATH',
  //     imageUrl: 'assets/courseimage/ec_course_BG.jpg'),
  CourseInfo(
      myCourseName: 'WR111C1',
      courseID: 'asdsdfag32231',
      userNumbers: 16,
      courseCategory: 'WR',
      imageUrl: 'assets/courseimage/wr_course_BG.jpg'),
  CourseInfo(
      myCourseName: 'PH123A5',
      courseID: 'AFDBVP123F2113',
      userNumbers: 26,
      courseCategory: 'PH',
      imageUrl: 'assets/courseimage/ph_course_BG.jpg'),
  CourseInfo(
      myCourseName: 'EC112A2',
      courseID: 'sadfsg2315ybi8u8h',
      userNumbers: 56,
      courseCategory: 'ECON',
      imageUrl: 'assets/courseimage/econ_course_BG.jpg'),
];

// final CourseInfo ma123 = CourseInfo(
//     myCourseName: 'ma123',
//     courseID: 'AFDBVP123F2113',
//     userNumbers: 26,
//     courseCategory: 'MATH');

// final CourseInfo wr111 = CourseInfo(
//     myCourseName: 'wr111',
//     courseID: 'asdsdfag32231',
//     userNumbers: 16,
//     courseCategory: 'writing');

// final CourseInfo ma125 = CourseInfo(
//     myCourseName: 'MA125',
//     courseID: 'AFDBVP123Fdssd213',
//     userNumbers: 6,
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
