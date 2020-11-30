import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/pages/contact_pages/userInfo/userCourseInfo.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'basicInfo.dart';
import 'package:app_test/models/CourseCard.dart';

class FriendProfile extends StatefulWidget {
  final String userID;
  FriendProfile({Key key, @required this.userID}) : super(key: key);

  @override
  _FriendProfileState createState() => _FriendProfileState(userID);
}

class _FriendProfileState extends State<FriendProfile> {
  String userID;
  _FriendProfileState(this.userID); //constructor
  double currentIndex = 0;

  final databaseMehods = DatabaseMehods();
  @override
  Widget build(BuildContext context) {
    int courseDataCount = 1;
    Stream<List<CourseInfo>> courseData = databaseMehods.getMyCourses(userID);
    Future<UserTags> userTag = databaseMehods.getAllTage(userID);
    Future<UserData> userData = databaseMehods.getUserDetailsByID(userID);

    return FutureBuilder(
        future: Future.wait([userData, userTag]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  BasicInfo(
                    userData: userData,
                    userTag: userTag,
                    userID: userID,
                  ),
                  StreamBuilder(
                    stream: courseData,
                    builder: (context, snapshot) {
                      _onPageViewChange(int page) {
                        setState(() {
                          currentIndex = page.toDouble();
                          courseDataCount = snapshot.data.length;
                        });
                      }

                      if (snapshot.hasError)
                        return Center(
                          child: Text("Error"),
                        );
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        default:
                          return !snapshot.hasData
                              ? Center(
                                  child: Text("Empty"),
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      height: 129.0,
                                      child: PageView.builder(
                                        onPageChanged: _onPageViewChange,
                                        scrollDirection: Axis.horizontal,
                                        controller: PageController(
                                            initialPage: 0,
                                            viewportFraction: 0.53),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return UserCourseInfo(
                                            index,
                                            snapshot.data,
                                          );
                                        },
                                        itemCount: snapshot.data.length,
                                      ),
                                    ),
                                  ],
                                );
                      }
                    },
                  ),
                  DotsIndicator(
                    dotsCount: courseDataCount,
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
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
