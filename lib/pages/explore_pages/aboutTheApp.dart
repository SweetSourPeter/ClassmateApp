import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTheAPP extends StatelessWidget {
  const AboutTheAPP({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themeOrange,
      body: SafeArea(
        child: Container(
          child: Scaffold(
              backgroundColor: themeOrange,
              appBar: AppBar(
                leading: Container(
                  padding: EdgeInsets.only(left: kDefaultPadding),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                // centerTitle: true,
                elevation: 0.0,
                backgroundColor: themeOrange,
                // title: Text("Create Course"),
              ),
              body: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: mediaQuery.height / 8),
                  LogoWidget(),
                  Text(
                    'Meechu',
                    style: largeTitleTextStyleBold(Colors.white, 26),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Version 1.0.00',
                    style: simpleTextStyle(Colors.white, 18),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://docs.qq.com/doc/DUGl3Z2htWHRzYm1Y');
                    },
                    child: buildContainer('Term of Use'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://docs.qq.com/doc/DUEhxcUl3cmtKWk5Q');
                    },
                    child: buildContainer('Privacy Policy'),
                  ),
                ],
              ))),
        ),
      ),
    );
  }

  Container buildContainer(String text) {
    return Container(
      height: 35,
      width: 150,
      decoration: BoxDecoration(
        color: Color(0xff9b6b).withOpacity(1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          text,
          style: simpleTextSansStyleBold(Colors.white, 14),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      print(url);
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
