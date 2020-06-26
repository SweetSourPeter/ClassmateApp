

class User{
  String userID;
  bool admin;

  User({this.userID});

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'admin': admin,
  };

}