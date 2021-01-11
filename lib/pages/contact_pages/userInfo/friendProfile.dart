import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/pages/contact_pages/userInfo/userCourseInfo.dart';
import 'package:app_test/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'basicInfo.dart';

class FriendProfile extends StatefulWidget {
  final String userID;
  FriendProfile({Key key, @required this.userID}) : super(key: key);

  @override
  _FriendProfileState createState() => _FriendProfileState(userID);
}

class _FriendProfileState extends State<FriendProfile> {
  String userID;
  _FriendProfileState(this.userID); //constructor
  int courseDataCount = 1;
  double _currentPage;
  PageController _pageController = PageController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Stream<List<CourseInfo>> courseData = databaseMethods.getMyCourses(userID);
    Future<UserTags> userTag = databaseMethods.getAllTage(userID);

    Future<UserData> userData = databaseMethods.getUserDetailsByID(userID);
    final currentUser = Provider.of<UserData>(context, listen: false);
    // Future<UserTags> myTag = databaseMethods.getAllTage(currentUser.userID);
    // a helper function for createChatRoomAndStartConversation()
    getChatRoomId(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return '$b\_$a';
      } else {
        return '$a\_$b';
      }
    }

    createChatRoomAndStartConversation(
        String userName, String userEmail, String userID, context) {
      // final currentUser = Provider.of<UserData>(context, listen: false);
      final myName = currentUser.userName;
      final myEmail = currentUser.email;
      final myID = currentUser.userID;
      if (userEmail != myEmail) {
        String chatRoomId = getChatRoomId(userEmail, myEmail);
        final lastMessageTime = DateTime.now().millisecondsSinceEpoch;

        List<String> users = [
          userName,
          userEmail,
          userID,
          myName,
          myEmail,
          myID,
        ];
        Map<String, dynamic> chatRoomMap = {
          'users': users,
          'chatRoomId': chatRoomId,
          'latestMessage': ('Hi! My name is ' + myName + '. Nice to meet you!'),
          'lastMessageTime': lastMessageTime,
          (userEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 1,
          (myEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 0
        };

        databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
        Map<String, dynamic> messageMap = {
          'message': 'Hi! My name is ' + myName + '. Nice to meet you!',
          'messageType': 'text',
          'sendBy': myEmail,
          'time': lastMessageTime,
        };

        databaseMethods.addChatMessages(chatRoomId, messageMap);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: currentUser,
              )
            ],
            child: ChatScreen(
              chatRoomId: chatRoomId,
              friendEmail: userEmail,
              friendName: userName,
              initialChat: 0,
              myEmail: currentUser.email,
            ),
          );
        }));
      } else {
        print('This is your account!');
      }
    }

    return SafeArea(
      child: FutureBuilder(
          future: Future.wait([userData, userTag]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              courseDataCount = snapshot.data.length;

              return Scaffold(
                body: Column(
                  children: <Widget>[
                    BasicInfo(
                      userData: userData,
                      userTag: userTag,
                      userID: userID,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 27, top: _height * 0.06, bottom: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("His/Her Classes",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.openSans(
                              fontSize: 14.0,
                              color: themeOrange,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    StreamBuilder(
                      stream: courseData,
                      builder: (context, snapshot) {
                        // _onPageViewChange(int page) {
                        //   // print(courseDataCount);
                        //   // print(currentIndex);
                        //   print(page);
                        //   setState(() {
                        //     currentIndex = (page - 1).toDouble();
                        //     print(currentIndex);
                        //   });
                        // }
                        // _onPageViewChange(int page) {
                        //   print("Current Page: " + page.toString());

                        //   // int previousPage = page;
                        //   // if (page != 0)
                        //   //   previousPage--;
                        //   // else
                        //   //   previousPage = 2;
                        //   // print("Previous page: $previousPage");
                        // }

                        if (snapshot.hasError)
                          return Center(
                            child: Text("Error"),
                          );
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            print('connecting');
                            return Center(child: CircularProgressIndicator());
                          default:
                            return !snapshot.hasData
                                ? Center(
                                    child: Text("Empty"),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        height: 129.0,
                                        child: PageView.builder(
                                          // onPageChanged: (index) {
                                          //   setState(() {
                                          //     print(_currentPage);
                                          //     _currentPage = index.toDouble();
                                          //     print(_currentPage);
                                          //   });
                                          // },
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
                                      // DotsIndicator(
                                      //   dotsCount: snapshot.data.length,
                                      //   position: _currentPage,
                                      //   decorator: DotsDecorator(
                                      //     size: const Size.square(6.0),
                                      //     activeSize: const Size.square(7.0),
                                      //     spacing: const EdgeInsets.only(
                                      //         left: 10.0, right: 10.0),
                                      //     color:
                                      //         builtyPinkColor, // Inactive color
                                      //     activeColor: themeOrange,
                                      //   ),
                                      // ),
                                    ],
                                  );
                        }
                      },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    RaisedGradientButton(
                      width: _width * 0.75,
                      height: 59,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [themeOrange, themeOrange],
                      ),
                      child: AutoSizeText(
                        "Message",
                        style: simpleTextSansStyleBold(Colors.white, 16),
                      ),
                      onPressed: () {
                        //TODO
                        print(snapshot.data[0].userName);
                        print(snapshot.data[0].email);
                        createChatRoomAndStartConversation(
                          snapshot.data[0].userName,
                          snapshot.data[0].email,
                          userID,
                          context,
                        );
                        print("show animation");
                      },
                    ),
                    SizedBox(
                      height: _height * 0.068,
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
