import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
                'MeetCor',
                style: largeTitleTextStyle(themeOrange),
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
              Text(
                'Term of Use',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ))),
    );
  }
}
