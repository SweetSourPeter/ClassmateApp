// import 'dart:html';

import 'dart:ffi';

import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMehods {
  //search user methods
  getUsersByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUsersByEmail(String email) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
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

  //update user in database
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
    //First update in the user level
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('courses')
        .document(course.courseID)
        .setData(course.toMapIntoUsers());
    //also update in the course level
  }

  Future<void> saveCourseToCourse(CourseInfo course) {
    //First update in the user level
    return Firestore.instance
        .collection('courses')
        .document(course.courseID)
        .setData(course.toMapIntoCourses(), merge: true);
    //also update in the course level
  }

  Future<void> addUserToCourse(String courseID, User user) {
    //First update in the user level
    return Firestore.instance
        .collection('courses')
        .document(courseID)
        .collection('users')
        .document(user.userID)
        .setData(user.toJson(), merge: true);
    //also update in the course level
  }

  //get all my courses from firestore
  Stream<List<CourseInfo>> getMyCourses(String userID) {
    print('gettre called');
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
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('courses')
        .document(courseID)
        .delete();
  }

  //delete course in course
  Future<void> removeCourseFromCourse(String courseID, String userID) {
    return Firestore.instance
        .collection('courses')
        .document(courseID)
        .collection('users')
        .document(userID)
        .delete();
  }
  //----------School database methods----------//
  //create a new school

  //
}
