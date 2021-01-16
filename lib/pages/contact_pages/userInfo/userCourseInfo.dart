import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/animatedButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserCourseInfo extends StatelessWidget {
  final int index;
  final List<CourseInfo> courseData;
  UserCourseInfo(this.index, this.courseData);

  List<String> fileLocation = [
    'assets/icon/courseIcon1.png',
    'assets/icon/courseIcon2.png',
    'assets/icon/courseIcon3.png',
    'assets/icon/courseIcon4.png',
    'assets/icon/courseIcon5.png',
    'assets/icon/courseIcon6.png',
  ];
  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final currentCourse = Provider.of<List<CourseInfo>>(context);
    bool checkIftheSame(CourseInfo course, List<CourseInfo> courseList) {
      for (int i = 0; i < courseList.length; i++) {
        if (courseList[i].courseID == course.courseID) {
          return true;
        }
      }
      return false;
    }

    return Container(
      height: 120,
      width: 200,
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 15.0),
      decoration: BoxDecoration(
        color: riceColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          // BoxShadow(
          //     color: Colors.black.withOpacity(0.15),
          //     blurRadius: 6,
          //     spreadRadius: 3,s
          //     offset: Offset(4, 4))
          //neumorphic light
          BoxShadow(
              color: Color(0xFFE3E3E3),
              blurRadius: 6,
              spreadRadius: 3,
              offset: Offset(3, 5))
        ],
      ),
      child: Container(
        child: Stack(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45.0,
                    ),
                    Text(
                        ' ' + courseData[index].myCourseName ??
                            '' + ' ' + courseData[index].section ??
                            '',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Colors.black)),
                    SizedBox(
                      height: 12.0,
                    ),
                    ExpandedButton(
                      width: 48,
                      height: 24,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [themeOrange, themeOrange],
                      ),
                      sameClass:
                          checkIftheSame(courseData[index], currentCourse),

                      // (courseData[index].courseID ==
                      //     currentCourse[index].courseID),
                      initialText: "ADD",
                      initialStyle: GoogleFonts.openSans(
                          fontSize: 10.0, color: Colors.brown[50]),
                      finalText: "same class!",
                      finalStyle: GoogleFonts.openSans(
                        fontSize: 10.0,
                        color: themeOrange,
                      ),
                      duration: Duration(milliseconds: 100),
                      onPressed: () {
                        //show dialog
                        courseProvider.changeTerm(courseData[index].term);
                        courseProvider.changeCourseCollege(
                            courseData[index].myCourseCollge);
                        courseProvider.changeCourseDepartment(
                            courseData[index].department);
                        courseProvider
                            .changeCourseName(courseData[index].myCourseName);
                        courseProvider
                            .changeCourseSection(courseData[index].section);
                        courseProvider.saveCourseToUser(
                            context, courseData[index].courseID);
                        print("show animation");
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: FittedBox(
                      child: index == null
                          ? Image.asset(fileLocation[0])
                          : Image.asset(fileLocation[index % 6]),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
