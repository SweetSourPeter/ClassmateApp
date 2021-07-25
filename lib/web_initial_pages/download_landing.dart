import 'package:app_test/models/constant.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadLanding extends StatelessWidget {
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
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                "Meet your classmates online, study together with others who have the similar study habits, being notified about the seat vacancy.......Meechu makes learning easier for you!",
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
    ];
  }

//----------------------mobile--------------------------
  mobilePageChildren(double width) {
    return <Widget>[
      Container(
        width: width,
        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: AutoSizeText(
                "Your Classmate Finder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0, bottom: 20),
              child: AutoSizeText(
                "Meet your classmates online, study together with others. \n Meechu make learning easier for you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.05 * width),
                  color: Color(0xFF4F413C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  onPressed: () {
                    _launchURL(
                        'https://apps.apple.com/us/app/meechu-classmates-chat/id1548409920');
                  },
                  child: AutoSizeText(
                    "Download for iPhone",
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: width * 0.068,
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 22, horizontal: 0.05 * width),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  onPressed: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=com.nacc.android');
                  },
                  child: AutoSizeText(
                    "Download for Android",
                    style: TextStyle(fontSize: 12.0, color: themeOrange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: (0)),
        child: Container(
          width: width,
          child: Image.asset(
            'assets/webImage/web_intro.png',
            width: width,
          ),
        ),
      ),
    ];
  }

  //----------------------mobile--------------------------
  mobileSmallPageChildren(double width) {
    return <Widget>[
      Container(
        width: width,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: AutoSizeText(
                "Your Classmate Finder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AutoSizeText(
                "Meet your classmates online, study together with others who have the similar study habits, being notified about the seat vacancy.......Meechu makes learning easier for you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 22, horizontal: 0.05 * width),
                    color: Color(0xFF4F413C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    onPressed: () {
                      _launchURL(
                          'https://apps.apple.com/us/app/meechu-classmates-chat/id1548409920');
                    },
                    child: AutoSizeText(
                      "Download for iPhone",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 22, horizontal: 0.05 * width),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    onPressed: () {
                      _launchURL(
                          'https://play.google.com/store/apps/details?id=com.nacc.android');
                    },
                    child: AutoSizeText(
                      "Download for Android",
                      style: TextStyle(fontSize: 12.0, color: themeOrange),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: (0)),
        child: Image.asset(
          'assets/webImage/web_intro.png',
          width: width,
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
        } else if (constraints.maxWidth > 360) {
          return Column(
            children: mobilePageChildren(constraints.biggest.width),
          );
        } else {
          return Column(
            children: mobileSmallPageChildren(constraints.biggest.width),
          );
        }
      },
    );
  }
}
