import 'package:app_test/models/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
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
      Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "Your Classmate Finder",
              maxLines: 1,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 68.0),
              child: AutoSizeText(
                "Meet your classmates online, study together with others who have the similar study habits, being notified about the seat vacancy.......Meechu make learning easier for you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.03 * width),
                  color: Color(0xFF4F413C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(42.0))),
                  onPressed: () {
                    _launchURL(
                        'https://apps.apple.com/us/app/meechu-classmates-chat/id1548409920');
                  },
                  child: AutoSizeText(
                    "Download for iPhone",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: width * 0.068,
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.03 * width),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(42.0))),
                  onPressed: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=com.nacc.android');
                  },
                  child: AutoSizeText(
                    "Download for Android",
                    style: TextStyle(color: themeOrange),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: (96 / 1920 * width)),
        child: Image.asset(
          'assets/webImage/web_intro.png',
          width: width,
        ),
      ),

      //build/join
      Container(
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
      Container(
        width: width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width * 0.9,
              child: Expanded(
                child: AutoSizeText(
                  "Your Classmate Finder",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45.0),
              child: AutoSizeText(
                "Meet your classmates online, study together with others who have the similar study habits, being notified about the seat vacancy.......Meechu make learning easier for you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9.0, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.03 * width),
                  color: Color(0xFF4F413C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(42.0))),
                  onPressed: () {
                    _launchURL(
                        'https://apps.apple.com/us/app/meechu-classmates-chat/id1548409920');
                  },
                  child: AutoSizeText(
                    "Download for iPhone",
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: width * 0.068,
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.03 * width),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(42.0))),
                  onPressed: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=com.nacc.android');
                  },
                  child: AutoSizeText(
                    "Download for Android",
                    style: TextStyle(fontSize: 10.0, color: themeOrange),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: (80)),
        child: Image.asset(
          'assets/webImage/web_intro.png',
          width: width,
        ),
      ),

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
                    horizontal: 15,
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "your course group by typing in the course number",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
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
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0, color: Color(0xFF594B42)),
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
                    horizontal: 15,
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "with classmates who have similiar study habits",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
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
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0, color: Color(0xFF594B42)),
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
                    horizontal: 15,
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: AutoSizeText(
                        "Notify when a class has vacant seats available",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
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
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0, color: Color(0xFF594B42)),
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
