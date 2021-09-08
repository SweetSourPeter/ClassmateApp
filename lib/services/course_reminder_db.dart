import 'dart:convert';
<<<<<<< HEAD
=======
import 'dart:ffi';
>>>>>>> master
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
<<<<<<< HEAD
  final colectURL = 'http://nacc-api.cf/admin/api/collect';
  final deleteURL = 'http://nacc-api.cf/admin/api/delete';
=======
  final colectURL = 'http://nacc-api.tk/admin/api/collect';
  final deleteURL = 'http://nacc-api.tk/admin/api/delete';
>>>>>>> master
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
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('userCourseReminder')
        .doc(reminderID)
        .set({
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

<<<<<<< HEAD
=======
  Future<double> getCourseReminderNumbers(String userID) async {
    print('remove course reminder called....');
    // double temp;
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userID)
    //     .collection('userCourseReminder')
    //     .get()
    //     .then((value) {
    //   print('aaaaaaaaaaaaaa');
    //   print(value.docs.length.toDouble());
    //   temp = value.docs.length.toDouble();
    // });
    // print(temp);
    // return temp;
    int temp = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('userCourseReminder')
        .snapshots()
        .length;
    return temp.toDouble();
  }

>>>>>>> master
  //delete course reminder for user
  Future<void> deleteCourseReminder(String reminderID, String userID) {
    print('remove course reminder called....');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('userCourseReminder')
        .doc(reminderID)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

// get all reminders
  Stream<List<Map<String, dynamic>>> getUserReminderLists(String userID) {
    print('called user reminder lister getter stream');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('userCourseReminder')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => document.data()).toList());
  }

  Future<http.Response> createReminder(
    String semester,
    String email,
    String college,
    String department,
    String course,
    String section,
  ) {
<<<<<<< HEAD
    return http.post(
      colectURL,
=======
    print('semester:');

    print(semester);
    return http.post(
      Uri.parse(colectURL),
>>>>>>> master
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
<<<<<<< HEAD
      deleteURL,
=======
      Uri.parse(deleteURL),
>>>>>>> master
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
