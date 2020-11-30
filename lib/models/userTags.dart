class UserTags {
  final List gpa;
  final List college;
  final List language;
  final List strudyHabits;

  UserTags({
    this.gpa,
    this.college,
    this.language,
    this.strudyHabits,
  });

  UserTags.fromFirestoreTags(Map<String, dynamic> firestore)
      : gpa = firestore['gpa'],
        college = firestore['college'],
        language = firestore['language'],
        strudyHabits = firestore['strudyHabits'];
}
