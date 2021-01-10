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
      : interest = firestore['interest'],
        college = firestore['college'],
        language = firestore['language'],
        strudyHabits = firestore['strudyHabits'];
}
