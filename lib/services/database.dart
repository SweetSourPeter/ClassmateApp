import 'package:app_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMehods {
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
}
