import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';

class ChatRoom extends StatefulWidget {
  final String myName;
  final String myEmail;

  ChatRoom({this.myName, this.myEmail});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  String friendName;
  String friendEmail;
  String friendID;
  double friendProfileColor;
  String latestMessage;
  String lastMessageTime;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget chatRoomsList(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final currentUser = Provider.of<UserData>(context, listen: false);
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final userList =
                      snapshot.data.documents[index].data()['users'];

                  if (userList[1] == widget.myEmail) {
                    friendName = userList[4];
                    friendEmail = userList[5];
                    friendID = userList[6];
                    friendProfileColor = userList[7];
                  } else {
                    friendName = userList[0];
                    friendEmail = userList[1];
                    friendID = userList[2];
                    friendProfileColor = userList[3];
                  }

                  latestMessage =
                      snapshot.data.documents[index].data()['latestMessage'];
                  lastMessageTime = DateTime.fromMillisecondsSinceEpoch(snapshot
                          .data.documents[index]
                          .data()['lastMessageTime'])
                      .toString();

                  return (currentUser.blockedUserID != null &&
                          currentUser.blockedUserID.contains(friendID))
                      ? Container()
                      : Column(
                          children: [
                            ChatRoomsTile(
                                friendID: friendID,
                                userName: snapshot.data.documents[index]
                                    .data()['chatRoomId']
                                    .toString()
                                    .replaceAll("_", "")
                                    .replaceAll(currentUser.email, ""),
                                chatRoomId: snapshot.data.documents[index]
                                    .data()["chatRoomId"],
                                friendName: friendName,
                                latestMessage: latestMessage,
                                lastMessageTime: lastMessageTime,
                                friendEmail: friendEmail,
                                unreadNumber: snapshot.data.documents[index]
                                    .data()[widget.myEmail.substring(
                                        0, widget.myEmail.indexOf('@')) +
                                    'unread'],
                                friendProfileColor: friendProfileColor),
                            Divider(
                              thickness: 1,
                              indent: _width * 0.25,
                            ),
                          ],
                        );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfoGetChats(widget.myEmail);
    super.initState();
  }

  getUserInfoGetChats(myEmail) async {
    databaseMethods.getChatRooms(myEmail).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  $myEmail");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 40, left: 40, bottom: _height * 0.064, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Chats',
                      textAlign: TextAlign.left,
                      style: largeTitleTextStyleBold(Colors.black, 26),
                    ),
                  ),
                  // Expanded(child: Container()),
                  GestureDetector(
                      onTap: () {
                        //search for users
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MultiProvider(
                            providers: [
                              Provider<UserData>.value(
                                value: currentUser,
                              ),
                              Provider<List<CourseInfo>>.value(
                                value: currentCourse,
                              ),
                              // 这个需要的话直接uncomment
                              // Provider<List<CourseInfo>>.value(
                              //   value: course,F
                              // ),
                              // final courseProvider = Provider.of<CourseProvider>(context);
                              // 上面这个courseProvider用于删除添加课程，可以直接在每个class之前define，
                              // 不需要pass到push里面，直接复制上面这行即可
                            ],
                            child: SearchUsers(),
                          );
                        }));
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/images/search.png',
                          color: Color(0xffFF7E40),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              child: chatRoomsList(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String friendName;
  final String friendID;
  final String latestMessage;
  final String lastMessageTime;
  final String friendEmail;
  final int unreadNumber;
  final double friendProfileColor;

  ChatRoomsTile({
    this.userName,
    @required this.chatRoomId,
    this.friendName,
    this.latestMessage,
    this.friendID,
    this.lastMessageTime,
    this.friendEmail,
    this.unreadNumber,
    this.friendProfileColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);
    Size mediaQuery = MediaQuery.of(context).size;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = mediaQuery.width * 1.0;
    print('heree');
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: currentUser,
              ),
              Provider<List<CourseInfo>>.value(
                value: currentCourse,
              ),
            ],
            child: ChatScreen(
                chatRoomId: chatRoomId,
                friendName: friendName,
                friendEmail: friendEmail,
                initialChat: 0,
                myEmail: currentUser.email,
                friendID: friendID,
                friendProfileColor: friendProfileColor),
          );
        }));
      },
      child: Container(
        height: _height * 0.087,
        margin: EdgeInsets.only(top: _height * 0.006, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: _width * 0.175,
                    width: _width * 0.175,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              listProfileColor[friendProfileColor.toInt()],
                          radius: sidebarSize / 10,
                          child: Container(
                            child: Text(
                              // 单个字22，双子18
                              friendName.split(' ').length >= 2
                                  ? friendName.split(' ')[0][0].toUpperCase() +
                                      friendName
                                          .split(' ')[
                                              friendName.split(' ').length - 1]
                                              [0]
                                          .toUpperCase()
                                  : friendName[0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                  fontSize: friendName.split(' ').length >= 2
                                      ? 19
                                      : 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        unreadNumber > 0 &&
                                (currentUser.blockedUserID != null &&
                                    !currentUser.blockedUserID
                                        .contains(friendID))
                            ? Positioned(
                                right: 0,
                                top: 0,
                                child: new Container(
                                  alignment: Alignment.topCenter,
                                  width: 18,
                                  height: 18,
                                  decoration: new BoxDecoration(
                                    color: const Color(0xffFF1717),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: new Text(
                                    unreadNumber < 100
                                        ? unreadNumber.toString()
                                        : '...',
                                    style: GoogleFonts.openSans(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ))
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0, top: _height * 0.005),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friendName,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffFF7E40)),
                        ),
                        SizedBox(
                          height: _height * 0.009,
                        ),
                        Container(
                          width: mediaQuery.width - 200,
                          child: Text(latestMessage,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                  fontSize: 16, color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  child: Text(
                    lastMessageTime.substring(11, lastMessageTime.length - 7),
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: const Color(0xff949494),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
