import 'package:app_test/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final String userID;
  UserDatabaseService({this.userID});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(
      String userID, String userName, String email, String school) async {
    return await userCollection.doc(userID).set({
      'UserID': userID,
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
  UserData _userDataFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserData(
      userID: userID,
      userName: snapshot.data()['userName'],
      email: snapshot.data()['email'],
      school: snapshot.data()['school'],
    );
  }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return userCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(userID).snapshots().map(_userDataFromSnapshot);
  }

  //get all my courses from firestore
  Stream<List<UserData>> getMyContacts(String userID) {
    print('gettre contact called');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('contacts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => UserData.fromFirestoreContacts(document.data()))
            .toList());
  }

  Future<void> addUserTOcontact(UserData contact, String userID) {
    print('addUserTOcontact');
    var a = contact.userID;
    print('$userID');
    //First update in the user level
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('contacts')
        .doc(contact.userID)
        .set(contact.toMapIntoUsers())
        .catchError((e) {
      print(e.toString());
    });
    //also update in the course level
  }
}
