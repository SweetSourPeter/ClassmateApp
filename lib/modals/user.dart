class User {
  String userID;
  // String userImageUrl;
  bool admin;

  User({this.userID});

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'admin': admin,
      };
}
