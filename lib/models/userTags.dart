import 'package:flutter/material.dart';

class UserTags {
  final List interest;
  final List college;
  final List language;
  final List strudyHabits;

  UserTags({
    this.interest,
    this.college,
    this.language,
    this.strudyHabits,
  });

  UserTags.fromFirestoreTags(Map<String, dynamic> firestore)
      : interest = firestore['interest'] ?? null,
        college = firestore['college'] ?? null,
        language = firestore['language'] ?? null,
        strudyHabits = firestore['strudyHabits'] ?? null;

//   UserTags.fromFirestoreTagsToUserData(Map<String, dynamic> firestore)
// : interest = firestore['interest'],
//   college = firestore['college'],
//   language = firestore['language'],
//   strudyHabits = firestore['strudyHabits'];

  UserTags calculateMatchTags(UserTags friendTag, UserTags myTag) {
    UserTags resultTag;

    for (int category = 0; category < 4; category++) {
      switch (category) {
        case 0:
          {
            for (var i = 0; i < myTag.interest.length; i++) {
              for (var j = 0; j < myTag.interest.length; j++) {
                if (myTag.interest[i] == myTag.interest[j]) {
                  resultTag.interest.add(myTag.interest[j]);
                }
              }
            }
          }
          break;

        case 1:
          {
            for (var i = 0; i < myTag.college.length; i++) {
              for (var j = 0; j < myTag.college.length; j++) {
                if (myTag.college[i] == myTag.college[j]) {
                  resultTag.college.add(myTag.college[j]);
                }
              }
            }
          }
          break;

        case 2:
          {
            for (var i = 0; i < myTag.college.length; i++) {
              for (var j = 0; j < myTag.college.length; j++) {
                if (myTag.college[i] == myTag.college[j]) {
                  resultTag.college.add(myTag.college[j]);
                }
              }
            }
          }
          break;

        case 3:
          {
            for (var i = 0; i < myTag.strudyHabits.length; i++) {
              for (var j = 0; j < myTag.strudyHabits.length; j++) {
                if (myTag.strudyHabits[i] == myTag.strudyHabits[j]) {
                  resultTag.strudyHabits.add(myTag.strudyHabits[j]);
                }
              }
            }
          }
          break;

        default:
          break;
      }
    }
    return resultTag;
  }
}
