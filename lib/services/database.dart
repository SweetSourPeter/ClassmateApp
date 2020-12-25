// import 'dart:html';
// import 'dart:ffi';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods {
  Stream<UserData> userDetails(String userID) {
    print('called userdetails stream');
    return Firestore.instance
        .collection('users')
        .document(userID)
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot.data, userID));
  }
//  Future<UserTags> getAllTage(String userID) async {
//     //used to remove a single Tag from the user

//     DocumentReference docRef =
//         Firestore.instance.collection('users').document(userID);
//     DocumentSnapshot doc = await docRef.get();
//     return UserTags.fromFirestoreTags(doc.data['tags']);
//     // .catchError((e) {
//     //   print(e.toString());
//     // }));
//   }
  Future<UserData> getUserDetailsByID(String userID) async {
    print('called userdetails stream');
    // return Firestore.instance
    //     .collection('users')
    //     .document(userID)
    //     .snapshots()
    //     .map((snapshot) => UserData.fromFirestore(snapshot.data, userID));

    DocumentReference docRef =
        Firestore.instance.collection('users').document(userID);
    DocumentSnapshot doc = await docRef.get();
    var userData = UserData(
      email: doc.data['email'],
      school: doc.data['school'],
      userID: doc.data[userID],
      userName: doc.data['userName'],
      userImageUrl: doc.data['userImageUrl'],
    );
    return userData;
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
        .map((snapshot) =>
        snapshot.documents
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

  //

  //--------The Chat Room Database Methods---------//
  // create a new chat room
  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addGroupChatMessages(String courseID, messageMap) {
    Firestore.instance
        .collection('courses')
        .document(courseID)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }
  
  setUnreadNumber(String chatRoomId, String userEmail, int unreadNumber) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .updateData({
          (userEmail.substring(0, userEmail.indexOf('@')) + 'unread'): unreadNumber
    }).catchError((e) {
      print(e.toString());
    });
  }
  
  getUnreadNumber(String chatRoomId, String userEmail) async {
    return Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .get();
  }

  //-------User report save to satabase---------
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
    //    .document(badUserID)
    //     .setData({
    //   'reportMessage': reports,
    //   'isSolved': false,
    //   'reportedBadUserID': badUserID,
    //   'reportGoodUser': goodUserID,
    // }).catchError((e) {
    //   print(e.toString());
    // });
    //also update in the course level
  }

  //---------UserTags---------

  Future<void> removeSingleTag(
      String userID, String removeTag, String tagCategory) async {
    //used to remove a single Tag from the user
    //tag category includes: major, gpa, language, studyHabits, other

    DocumentReference docRef =
        Firestore.instance.collection('users').document(userID);
    DocumentSnapshot doc = await docRef.get();
    List tags = doc.data['tags'];
    if (tags.contains(tagCategory.contains(removeTag))) {
      docRef.updateData({
        'tags': {
          tagCategory: FieldValue.arrayRemove([removeTag])
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  Future<void> updateAllTags(String userID, UserTags userTags) async {
    //used to remove a single Tag from the user
    DocumentReference docRef =
        Firestore.instance.collection('users').document(userID);
    docRef.updateData({
      'tags': {
        'college': userTags.college,
        'gpa': userTags.gpa,
        'language': userTags.language,
        'strudyHabits': userTags.strudyHabits,
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  getChatMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  getGroupChatMessages(String chatRoomId) async {
    return Firestore.instance
        .collection('courses')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return Firestore.instance
        .collection('chatroom')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  getFriendCourses(String userEmail) async {
    String friendID;
    await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .getDocuments().then((value) {
          friendID = value.documents.first.documentID;
    });
    return Firestore.instance
        .collection('users')
        .document(friendID)
        .collection('courses')
        .getDocuments();
    // return Firestore.instance
    //     .collection('users')
    //     .document('wm7cwLR8OTPvDeGJwYf3B3pv1E73')
    //     .collection('courses')
    //     .getDocuments();
  }

  setLastestMessage(String chatRoomId, String latestMessage, int lastMessageTime) async {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .updateData({
          'latestMessage' : latestMessage,
          'lastMessageTime' : lastMessageTime
        }).catchError((e) {
          print(e.toString());
        });
  }

  Future<UserTags> getAllTage(String userID) async {
    //used to remove a single Tag from the user

    DocumentReference docRef =
        Firestore.instance.collection('users').document(userID);
    DocumentSnapshot doc = await docRef.get();
    return UserTags.fromFirestoreTags(doc.data['tags']);
  }
}
