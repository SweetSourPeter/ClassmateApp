import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/contact_pages/userInfo/courseInfo.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'basicInfo.dart';
import 'courseInfo.dart';
import 'package:app_test/models/CourseCard.dart';

class UserInfo extends StatefulWidget {
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  double currentIndex = 0;
  _onPageViewChange(int page) {
    setState(() {
      currentIndex = page.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          BasicInfo(),
          Stack(
            children: [
              Container(
                height: 129.0,
                child: PageView.builder(
                  onPageChanged: _onPageViewChange,
                  scrollDirection: Axis.horizontal,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.53),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CourseInfo(index);
                  },
                  itemCount: courseCardList.length,
                ),
              ),
            ],
          ),
          DotsIndicator(
            dotsCount: courseCardList.length,
            position: currentIndex,
            decorator: DotsDecorator(
              size: const Size.square(6.0),
              activeSize: const Size.square(7.0),
              spacing: const EdgeInsets.only(left: 10.0, right: 10.0),
              color: builtyPinkColor, // Inactive color
              activeColor: themeOrange,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          RaisedGradientButton(
            width: 250,
            height: 35,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [themeOrange, gradientYellow],
            ),
            child: Text("MESSAGE",
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            onPressed: () {
              //show dialog
              print("show animation");
            },
          )
        ],
      ),
    );
  }

  Scaffold backgroundLayer() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            //navigate to previous page
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: () {
              //navigate to some pages
            },
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.orange[50],
    );
  }

  Container interactLayer() {
    return Container(
      height: 400,
      color: Colors.white,
    );
  }
}
