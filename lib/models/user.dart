class User {
  final String userID;
  String userImageUrl;
  String school;
  String email;
  String userName;
  bool admin;
  int unread;

  User({this.userID, bool admin, this.unread});

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'admin': admin,
        'unread': 0
      };
}

class UserData {
  final String userID;
  final String userName;
  final String email;
  final String school;
  final String userImageUrl;
  final double profileColor;
  // final List<String> friendsList;
  // final List<String> courseList;
  UserData({
    this.userID,
    this.userName,
    this.email,
    this.school,
    this.userImageUrl,
    this.profileColor,
  });
  Map<String, dynamic> toCourseJson() => {
        'userID': userID,
        'userName': userName,
      };

  Map<String, dynamic> toMapIntoUsers() {
    print('mapper called to map complete');
    return {
      'userID': userID,
      'userName': userName,
      'email': email,
      'school': school,
      'userImageUrl': userImageUrl,
      'profileColor': profileColor,
    };
  }

  //get the data for current user
  UserData.fromFirestore(Map<String, dynamic> firestore, this.userID)
      : userImageUrl = firestore['imgUrl'] ?? '',
        school = firestore['school'] ?? '',
        email = firestore['email'] ?? '',
        profileColor = firestore['profileColor'] ?? '',
        userName = firestore['userName'] ?? '';

  //get data for contacts of current user
  UserData.fromFirestoreContacts(Map<String, dynamic> firestore)
      : userImageUrl = firestore['imgUrl'],
        userID = firestore['userID'],
        school = firestore['school'],
        email = firestore['email'],
        profileColor = firestore['profileColor'],
        userName = firestore['userName'];
  //     CourseInfo.fromFirestore(Map<String, dynamic> firestore)
  // : school = firestore['school'],
  //   term = firestore['term'],
  //   myCourseCollge = firestore['college'],
  //   department = firestore['department'],
  //   myCourseName = firestore['myCourseName'],
  //   section = firestore['section'],
  //   courseID = firestore['courseID'],
  //   userNumbers = firestore['userNumbers'];
}
