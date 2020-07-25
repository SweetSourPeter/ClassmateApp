class User {
  final String userID;
  // String userImageUrl;
  bool admin;

  User({this.userID});

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
  final String friendList;
  final List<String> courseList;
  UserData({this.userID, this.userName, this.email, this.school, this.friendList, this.courseList});
}
