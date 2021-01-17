class User {
  final String userID;
  String userImageUrl;
  String school;
  String email;
  String userName;
  bool admin;
  int unread;

  User({this.userID, bool admin, this.unread});

  Map<String, dynamic> toJson() =>
      {'userID': userID, 'admin': admin, 'unread': 0};
}

class UserData {
  final String userID;
  final String userName;
  final String email;
  final String school;
  final String userImageUrl;
  final double profileColor;
  final List blockedUserID;
  // final List<String> friendsList;
  // final List<String> courseList;
  UserData({
    this.userID,
    this.userName,
    this.email,
    this.school,
    this.userImageUrl,
    this.profileColor,
    this.blockedUserID,
  });
  Map<String, dynamic> toCourseJson() => {
        'userID': userID,
        'userName': userName,
      };

  Map<String, dynamic> toMapIntoUsers() {
    return {
      'userID': userID,
      'userName': userName,
      'email': email,
      'school': school,
      'userImageUrl': userImageUrl,
      'profileColor': profileColor,
      'blockedUser': blockedUserID,
    };
  }

  //get the data for current user
  UserData.fromFirestore(Map<String, dynamic> firestore, this.userID)
      : userImageUrl = firestore['imgUrl'] ?? '',
        school = firestore['school'] ?? '',
        email = firestore['email'] ?? '',
        profileColor = firestore['profileColor'] ?? '',
        userName = firestore['userName'] ?? '',
        blockedUserID = firestore['blockedUser'] ?? null;

  //get data for contacts of current user
  UserData.fromFirestoreContacts(Map<String, dynamic> firestore)
      : userImageUrl = firestore['imgUrl'],
        userID = firestore['userID'],
        school = firestore['school'],
        email = firestore['email'],
        profileColor = firestore['profileColor'],
        userName = firestore['userName'],
        blockedUserID = firestore['blockedUser'];
}
