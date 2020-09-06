// import 'dart:html';
// import 'dart:ffi';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMehods {
  Stream<UserData> userDetails(String userID) {
    print('called userdetails stream');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot.data, userID));
  }

  // Stream<List<CourseInfo>> getMyCourses(String userID) {
  //   print('gettre cources called');
  //   return Firestore.instance
  //       .collection('users')
  //       .document(userID)
  //       .collection('courses')
  //       .snapshots()
  //       .map((snapshot) => snapshot.documents
  //           .map((document) => CourseInfo.fromFirestore(document.data))
  //           .toList());
  // }

  //--------search user methods-----------
  getUsersByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUsersByEmail(String email) async {
    print('$email');
    return await Firestore.instance
        .collection("users")
        // .where("email", isEqualTo: email)
        .where(
          'email',
          isGreaterThanOrEqualTo: email,
          isLessThan: email.substring(0, email.length - 1) +
              String.fromCharCode(email.codeUnitAt((email.length - 1)) + 1),
        )
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  //---------search Course----------
  getCourse(String term, String courseName, String section) async {
    print('term is ' + term);
    print('courseName is ' + courseName);
    print('section is ' + section);
    return await Firestore.instance
        .collection("courses")
        .where("section", isEqualTo: section.toUpperCase())
        .where("term", isEqualTo: term.toUpperCase())
        .where(
          'myCourseName',
          isGreaterThanOrEqualTo: courseName,
          isLessThan: courseName.substring(0, courseName.length - 1) +
              String.fromCharCode(
                  courseName.codeUnitAt((courseName.length - 1)) + 1),
        )
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  //give suggestions not used, this might increase the cost
  Future getSuggestionsByName(String emailSugestion) {
    Firestore.instance
        .collection('users')
        .where('name', arrayContains: emailSugestion)
        .getDocuments()
        .then((snap) {
      return snap.documents;
    });
  }

  //----------update user in database---------
  uploadUserInfo(userMap, String userId) {
    // Firestore.instance.collection("users").add(userMap);
    Firestore.instance
        .collection("users")
        .document(userId)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  //--------The Course Database Methods---------
  Future<void> saveCourseToUser(CourseInfo course, String userID) {
    print('saveCourseToUser');
    print('$userID');
    //First update in the user level
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('courses')
        .document(course.courseID)
        .setData(course.toMapIntoUsers())
        .catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }

  Future<void> saveCourseToCourse(CourseInfo course) {
    print('saveCourseToCourse');
    //First update in the user level
    return Firestore.instance
        .collection('courses')
        .document(course.courseID)
        .setData(course.toMapIntoCourses(), merge: true)
        .catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }

  Future<void> addUserToCourse(String courseID, User user) {
    //First update in the user level
    print('add user to course called');
    return Firestore.instance
        .collection('courses')
        .document(courseID)
        .collection('users')
        .document(user.userID)
        .setData(user.toJson(), merge: true)
        .catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }

  //get all my courses from firestore
  Stream<List<CourseInfo>> getMyCourses(String userID) {
    print('gettre cources called');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('courses')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => CourseInfo.fromFirestore(document.data))
            .toList());
  }

  //delete course for user
  Future<void> removeCourseFromUser(String courseID, String userID) {
    print('remove course called....');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('courses')
        .document(courseID)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  //delete course in course
  Future<void> removeUserFromCourse(String courseID, String userID) {
    return Firestore.instance
        .collection('courses')
        .document(courseID)
        .collection('users')
        .document(userID)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
  //----------School database methods----------//
  //create a new school

  //report save to satabase
  Future<void> saveReports(
      String reports, String badUserID, String goodUserID) {
    print('saveReports');
    //First update in the user level

    return Firestore.instance.collection('reports').add({
      'reportMessage': reports,
      'isSolved': false,
      'reportedBadUserID': badUserID,
      'reportGoodUser': goodUserID,
    }).catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }
}
