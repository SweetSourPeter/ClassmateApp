import 'package:app_test/models/user.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ContactProvider with ChangeNotifier {
  final userDatabaseService = UserDatabaseService();

  String _userID;
  String _userName;
  String _email;
  String _school;
  String _userImageUrl;

  String get userId => _userID;
  String get userName => _userName;
  String get email => _email;
  String get school => _school;
  String get userImageUrl => _userImageUrl;

  changeUserID(String value) {
    _userID = value;
    notifyListeners();
  }

  changeUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  changeSchool(String value) {
    _school = value;
    notifyListeners();
  }

  changeUserImageUrl(String value) {
    _userImageUrl = value;
    notifyListeners();
  }

  addUserToContact(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    var contact = UserData(
      userID: userId,
      school: school,
      email: email,
      userImageUrl: userImageUrl,
      userName: userName,
    );
    userDatabaseService.addUserTOcontact(contact, user.userID);
  }
}
