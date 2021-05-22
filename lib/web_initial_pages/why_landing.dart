import 'package:app_test/models/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WhyLanding extends StatelessWidget {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      print(url);
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  desktopPageChildren(double width) {
    return <Widget>[
      //build/join
      Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: width,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (86 / 1920 * width),
                  right: (180 / 1920 * width),
                  bottom: 45),
              child: Image.asset(
                'assets/webImage/buildImage.png',
                width: width * 0.30,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 25,
                        ),
                        child: Image.asset(
                          'assets/webImage/web_clock1.png',
                          width: width * 0.056,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Build / Join",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Color(0xFF594B42),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: AutoSizeText(
                                "your course group by typing in the course number",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF594B42),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 59.0),
                    child: AutoSizeText(
                      "Meechu encourages you to find your study buddy by joining the course group you are currently in.",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFF594B42)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //Study together
      Container(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 86 / 1920 * width,
                        ),
                        child: Image.asset(
                          'assets/webImage/web_clock1.png',
                          width: width * 0.056,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Study together",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Color(0xFF594B42),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: AutoSizeText(
                                "with classmates who have similiar study habits",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF594B42),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 59.0, left: 86 / 1920 * width),
                    child: AutoSizeText(
                      "Meechu matches the users according to their study habits. \nYou are encouraged to start a conversation with your potential study buddy.",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFF594B42)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 45,
                  left: (228 / 1920 * width),
                  right: (180 / 1920 * width),
                  bottom: 45),
              child: Image.asset(
                'assets/webImage/studyImage.png',
                width: width * 0.29,
              ),
            ),
          ],
        ),
      ),
      //Seat Vacancy
      Container(
        width: width,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 45,
                  left: (86 / 1920 * width),
                  right: (180 / 1920 * width),
                  bottom: 45),
              child: Image.asset(
                'assets/webImage/notifyImage.png',
                width: width * 0.28,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 25,
                        ),
                        child: Image.asset(
                          'assets/webImage/web_clock2.png',
                          width: width * 0.056,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Seat Vacancy",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Color(0xFF594B42),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: AutoSizeText(
                                "Notify when a class has vacant seats available",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF594B42),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 59.0),
                    child: AutoSizeText(
                      "No longer need to refresh the course selection page! Meechu gets what you expected.",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFF594B42)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

//----------------------mobile--------------------------
  mobilePageChildren(double width) {
    return <Widget>[
      //build/join
      Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 5,
                  ),
                  child: Image.asset(
                    'assets/webImage/web_clock1.png',
                    width: width * 0.1,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Build / Join",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Color(0xFF594B42),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "your course group by typing in the course number",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xFF594B42),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                'assets/webImage/buildImage.png',
                width: width * 0.50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: AutoSizeText(
                "Meechu encourages you to find your study buddy by joining the course group you are currently in.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Color(0xFF594B42)),
              ),
            ),
          ],
        ),
      ),
      //Study together
      Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5,
                  ),
                  child: Image.asset(
                    'assets/webImage/web_clock1.png',
                    width: width * 0.1,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Study together",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Color(0xFF594B42),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "with classmates who have similiar study habits",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xFF594B42),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                'assets/webImage/studyImage.png',
                width: width * 0.50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: AutoSizeText(
                "Meechu matches the users according to their study habits. You are encouraged to start a conversation with your potential study buddy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Color(0xFF594B42)),
              ),
            ),
          ],
        ),
      ),
      //Seat Vacancy
      Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5,
                  ),
                  child: Image.asset(
                    'assets/webImage/web_clock1.png',
                    width: width * 0.1,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Seat Vacancy",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Color(0xFF594B42),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "Notify when a class has vacant seats available",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xFF594B42),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                'assets/webImage/notifyImage.png',
                width: width * 0.50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: AutoSizeText(
                "No longer need to refresh the course selection page! Meechu gets what you expected.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Color(0xFF594B42)),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: desktopPageChildren(constraints.biggest.width),
          );
        } else {
          return Column(
            children: mobilePageChildren(constraints.biggest.width),
          );
        }
      },
    );
  }
}
