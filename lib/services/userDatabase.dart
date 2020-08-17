import 'package:app_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final String userID;
  UserDatabaseService({this.userID});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<void> updateUserData(
      String userName, String email, String school) async {
    return await userCollection.document(userID).setData({
      'userName': userName,
      'email': email,
      'school': school,
    });
  }

  // brew list from snapshot
  // List<User> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc){
  //     //print(doc.data);
  //     return Brew(
  //       name: doc.data['name'] ?? '',
  //       strength: doc.data['strength'] ?? 0,
  //       sugars: doc.data['sugars'] ?? '0'
  //     );
  //   }).toList();
  // }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      userID: userID,
      userName: snapshot.data['userName'],
      email: snapshot.data['email'],
      school: snapshot.data['school'],
    );
  }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return userCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection
        .document(userID)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
