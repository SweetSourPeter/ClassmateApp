class CourseRoutePath {
  final String classid;
  final bool isUnknown;

  CourseRoutePath.home()
      : classid = null,
        isUnknown = false;

  CourseRoutePath.details(this.classid) : isUnknown = false;

  CourseRoutePath.unknown()
      : classid = null,
        isUnknown = true;

  bool get isHomePage => classid == null;
  bool get isCoursePage => classid != null;
}
