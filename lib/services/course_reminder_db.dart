import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// {
//             "semester": "NEXTSEM",
//             "email": "731957665@qq.edu",
//             "college" : "CAS",
//             "department" : "AA",
//             "course" : "300",
//             "section" : "A1"
//         }
class CourseReminderDatabase {
  final colectURL = 'http://nacc-api.cf/admin/api/collect';
  final deleteURL = 'http://nacc-api.cf/admin/api/delete';
  Future<void> saveUserReminder(
    String school,
    String semester,
    String email,
    String college,
    String department,
    String course,
    String section,
    DateTime submitTime,
    String userID,
    String reminderID,
  ) {
    print('save Daily Reports to user');
    //First update in the user level
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('userCourseReminder')
        .document(reminderID)
        .setData({
      'submitTime': submitTime,
      'school': school,
      'semester': semester,
      'email': email,
      'college': college,
      'department': department,
      'course': course,
      'section': section,
      'reminderID': reminderID,
    }).catchError((e) {
      print(e.toString());
    });
    //also update in the api
  }

  //delete course reminder for user
  Future<void> deleteCourseReminder(String reminderID, String userID) {
    print('remove course reminder called....');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('userCourseReminder')
        .document(reminderID)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

// get all reminders
  Stream<List<Map<String, dynamic>>> getUserReminderLists(String userID) {
    print('called user reminder lister getter stream');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .collection('userCourseReminder')
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((document) => document.data).toList());
  }

  Future<http.Response> createReminder(
    String semester,
    String email,
    String college,
    String department,
    String course,
    String section,
  ) {
    return http.post(
      colectURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'semester': semester,
        'email': email,
        'college': college,
        'department': department,
        'course': course,
        'section': section,
      }),
    );
  }

  Future<http.Response> deleteReminder(
    String semester,
    String email,
    String college,
    String department,
    String course,
    String section,
  ) {
    return http.post(
      deleteURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'semester': semester,
        'email': email,
        'college': college,
        'department': department,
        'course': course,
        'section': section,
      }),
    );
  }
}
