import 'package:app_test/models/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportLanding extends StatelessWidget {
  desktopPageChildren(double width) {
    return <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, //Center Column contents horizontally,
            children: [
              Column(
                children: [
                  Container(
                    child: AutoSizeText(
                      "Contact us through WeChat:",
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    child: AutoSizeText(
                      "Search WeChat 北美课友",
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Image.asset(
                        'assets/webImage/wechat.png',
                        width: 90,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: AutoSizeText(
                      "Contact us through email:",
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    child: AutoSizeText(
                      "naclassmates@gmail.com",
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 90,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
      Container(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: AutoSizeText(
                  "\u00a9 Copyright 2021: NACC - your college class assistant",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ))
          ],
        ),
      )
    ];
  }

//----------------------mobile--------------------------
  mobilePageChildren(double width) {
    return <Widget>[
      Container(
        width: width,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: AutoSizeText(
                    "Contact us through WeChat 北美课友",
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Image.asset(
                      'assets/webImage/wechat.png',
                      width: 50,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: AutoSizeText(
                    "Contact us through email:",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: AutoSizeText(
                    "naclassmates@gmail.com",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: AutoSizeText(
                            "\u00a9 Copyright 2021: NACC - your college class assistant",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )
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
