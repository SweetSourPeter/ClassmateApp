import 'package:app_test/models/courseInfo.dart';
import 'package:flutter/material.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/models/CourseCard.dart';
import 'package:app_test/widgets/animatedButton.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCourseInfo extends StatelessWidget {
  final int index;
  final List<CourseInfo> courseData;
  UserCourseInfo(this.index, this.courseData);
  List<String> fileLocation = [
    'assets/icon/courseIcon1.png',
    'assets/icon/courseIcon2.png',
    'assets/icon/courseIcon3.png',
    'assets/icon/courseIcon4.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 200,
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 15.0),
      decoration: BoxDecoration(
        color: riceColor,
        borderRadius: BorderRadius.circular(15.0),
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
                    height: 78,
                    width: 63,
                    child: FittedBox(
                      child: Image.asset(fileLocation[index % 4]),
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
