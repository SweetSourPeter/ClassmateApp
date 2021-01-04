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
    return Container(
      child: Scaffold(
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
            // centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.white,
            // title: Text("Create Course"),
          ),
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: mediaQuery.height / 8),
              LogoWidget(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Meechu',
                style: largeTitleTextStyle(themeOrange, 26),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Version 1.0.00',
                style: simpleTextStyleBlack(),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://docs.qq.com/doc/DUGl3Z2htWHRzYm1Y');
                },
                child: Text(
                  'Term of Use',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://docs.qq.com/doc/DUEhxcUl3cmtKWk5Q');
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ))),
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
