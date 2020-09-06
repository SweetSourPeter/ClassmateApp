import 'package:flutter/material.dart';

class CourseCard{
  final String courseName;
  final String section;

  CourseCard({
    this.courseName,
    this.section
  });

}

final courseCardList = [
  CourseCard(
    courseName: "CS111",
    section: "A1"
  ),
  CourseCard(
    courseName: "CS112",
    section: "A3",
  ),
  CourseCard(
    courseName: "CS210",
    section: "A1"
  ),
];
