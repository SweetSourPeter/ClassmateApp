import 'package:app_test/models/constant.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopNavbar();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return DesktopNavbar();
        } else {
          return MobileNavbar();
        }
      },
    );
  }
}

class DesktopNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = getRealWidth(maxWidth);
    return Padding(
      padding: EdgeInsets.only(
          top: 20, bottom: 20, left: _width * 0.03, right: _width * 0.1),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoWidget(80, 89),
                AutoSizeText(
                  "MEECHU",
                  style: largeTitleTextStyleBold(Colors.white, 26),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 0.05 * _width,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      "Download",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.015 * _width,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      "Why Meechu?",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.015 * _width,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      "Support",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.015 * _width,
                  ),
                ],
              ),
            ),
            MaterialButton(
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(vertical: 11, horizontal: 0.03 * _width),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Wrapper(
                        false,
                        false,
                        "0",
                      );
                    },
                  ),
                );
              },
              child: AutoSizeText(
                "Open Meechu in Browser",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: themeOrange, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MobileNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(60, 65),
              Text(
                "MEECHU",
                style: largeTitleTextStyleBold(Colors.white, 22),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Download",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Why Meechu?",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Support",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
