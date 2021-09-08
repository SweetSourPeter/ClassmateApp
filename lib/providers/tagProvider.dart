import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTagsProvider with ChangeNotifier {
  final databaseMethods = DatabaseMethods();
  List _interest;
  List _college;
  List _language;
  List _studyHabits;

  List get interest => _interest;
  List get college => _college;
  List get language => _language;
  List get studyHabits => _studyHabits;

  changeTagInterest(List value) {
    _interest = value;
    notifyListeners();
  }

  changeTagCollege(List value) {
    _college = value;
    notifyListeners();
  }

  changeTagLanguage(List value) {
    _language = value;
    notifyListeners();
  }

  changeTagsStudyHabits(List value) {
    _studyHabits = value;
    notifyListeners();
  }

  addTagsToContact(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    var tags = UserTags(
      interest: interest,
      college: college,
      language: language,
      strudyHabits: studyHabits,
    );
    databaseMethods.updateAllTags(user.userID, tags);
  }

  addEmptyTagsToContact(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    var tags = UserTags(
      interest: [],
      college: [],
      language: [],
      strudyHabits: [],
    );
    databaseMethods.updateAllTags(user.userID, tags);
  }
}
