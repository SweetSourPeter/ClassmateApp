import 'package:app_test/modals/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMehods {
  getUsersByUsername(String username) {}

  uploadUserInfo(userMap, String userId) {
    // Firestore.instance.collection("users").add(userMap);
    Firestore.instance.collection("users").document(userId).setData(userMap);
  }
}
