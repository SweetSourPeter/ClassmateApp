import 'package:flutter/material.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/models/CourseCard.dart';
import 'package:app_test/widgets/animatedButton.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseInfo extends StatelessWidget{

  final int index;
  CourseInfo(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 200,
      margin: EdgeInsets.fromLTRB(10.0,0,10.0,15.0),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
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
                        height: 55.0,
                      ),
                      Text(
                        courseCardList[index].courseName + " " + courseCardList[index].section,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          color: themeOrange
                        )
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      ExpandedButton(
                        width: 40,
                        height: 20,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [themeOrange, gradientYellow],
                        ),
  //                        child: Text(
  ////                          "ADD",
  ////                          style: TextStyle(
  ////                            letterSpacing: 1.0,
  ////                            color: Colors.white,
  ////                          ),
  ////                        ),
                        initialText: "ADD",
                        initialStyle: GoogleFonts.openSans(
                          fontSize: 10.0,
                          color: Colors.brown[50]
                        ),
                        finalText: "same class!",
                        finalStyle: GoogleFonts.openSans(
                            fontSize: 10.0,
                            color: themeOrange,
                        ),
                        duration: Duration(milliseconds: 100),
                        onPressed: (){
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
                  width: 100,
                ),
                Center(
                  child: Text("Placeholder"),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

}