class User {
  final String userID;
  String userImageUrl;
  String school;
  String email;
  String userName;
  bool admin;

  User({this.userID, bool admin});

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'admin': admin,
      };
}

class UserData {
  final String userID;
  final String userName;
  final String email;
  final String school;
  final String userImageUrl;
  // final List<String> friendsList;
  // final List<String> courseList;
  UserData({
    this.userID,
    this.userName,
    this.email,
    this.school,
    this.userImageUrl,
  });
  Map<String, dynamic> toCourseJson() => {
        'userID': userID,
        'userName': userName,
      };
  UserData.fromFirestore(Map<String, dynamic> firestore, this.userID)
      : userImageUrl = firestore['imgUrl'],
        school = firestore['school'],
        email = firestore['email'],
        userName = firestore['userName'];
}
