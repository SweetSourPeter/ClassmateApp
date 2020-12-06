import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTagsProvider with ChangeNotifier {
  final databaseMehods = DatabaseMethods();
  List _gpa;
  List _college;
  List _language;
  List _strudyHabits;

  List get gpa => _gpa;
  List get college => _college;
  List get language => _language;
  List get strudyHabits => _strudyHabits;

  changeTagGPA(List value) {
    _gpa = value;
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
    _strudyHabits = value;
    notifyListeners();
  }

  addTagsToContact(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    var tags = UserTags(
      gpa: gpa,
      college: college,
      language: language,
      strudyHabits: strudyHabits,
    );
    databaseMehods.updateAllTags(user.userID, tags);
  }
}
