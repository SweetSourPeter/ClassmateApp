import 'package:app_test/models/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportLanding extends StatelessWidget {
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
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, //Center Column contents horizontally,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: AutoSizeText(
                      "Contact us through WeChat: Search WeChat 北美课友",
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Contact us through:  ',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextSpan(
                              text: 'Email ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  String kEmail = 'yaopuw@bu.edu';
                                  var mailUrl = 'mailto:$kEmail';
                                  _launchURL(mailUrl);
                                }),
                          TextSpan(
                            text: ' /  ',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextSpan(
                              text: 'Instagram',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                      'https://www.instagram.com/meechu.classmates/');
                                }),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(top: 20, bottom: 20),
                  //     child: Icon(
                  //       Icons.email_outlined,
                  //       color: Colors.white,
                  //       size: 90,
                  //     ),
                  //   ),
                  // ),
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
    var FontAwesomeIcons;
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
                    "Contact us through :",
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
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Email ',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                String kEmail = 'yaopuw@bu.edu';
                                var mailUrl = 'mailto:$kEmail';
                                _launchURL(mailUrl);
                              }),
                        TextSpan(
                          text: ' /  ',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextSpan(
                            text: 'Instagram',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                    'https://www.instagram.com/meechu.classmates/');
                              }),
                      ],
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

//----------------------mobile2--------------------------
  mobile2PageChildren(double width) {
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
                    "Contact us through WeChat",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: AutoSizeText(
                    "北美课友",
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
                    "Contact us through :",
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
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Email ',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                String kEmail = 'yaopuw@bu.edu';
                                var mailUrl = 'mailto:$kEmail';
                                _launchURL(mailUrl);
                              }),
                        TextSpan(
                          text: ' /  ',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextSpan(
                            text: 'Instagram',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                    'https://www.instagram.com/meechu.classmates/');
                              }),
                      ],
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
                            "\u00a9 Copyright 2021: NACC",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 5,
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
        } else if (constraints.maxWidth > 350) {
          return Column(
            children: mobilePageChildren(constraints.biggest.width),
          );
        } else {
          return Column(
            children: mobile2PageChildren(constraints.biggest.width),
          );
        }
      },
    );
  }
}
