import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
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
  String latestMessage;
  String lastMessageTime;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget chatRoomsList() {
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
                    friendName = userList[2];
                    friendEmail = userList[3];
                  } else {
                    friendName = userList[0];
                    friendEmail = userList[1];
                  }

                  latestMessage =
                      snapshot.data.documents[index].data()['latestMessage'];
                  lastMessageTime = DateTime.fromMillisecondsSinceEpoch(snapshot
                          .data.documents[index]
                          .data()['lastMessageTime'])
                      .toString();

                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(currentUser.email, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data()["chatRoomId"],
                    friendName: friendName,
                    latestMessage: latestMessage,
                    lastMessageTime: lastMessageTime,
                    friendEmail: friendEmail,
                    unreadNumber: snapshot.data.documents[index].data()[widget
                            .myEmail
                            .substring(0, widget.myEmail.indexOf('@')) +
                        'unread'],
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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 40, bottom: 20),
                    child: Container(
                      child: Text(
                        'Chats',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
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
                        padding: EdgeInsets.only(top: 20, right: 40),
                        child: Image.asset(
                          'assets/images/search.png',
                          color: Color(0xffFF7E40),
                        ),
                      )
                  )
                ],
              ),
            ),
            Expanded(
              child: chatRoomsList(),
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
  final String latestMessage;
  final String lastMessageTime;
  final String friendEmail;
  final int unreadNumber;

  ChatRoomsTile(
      {this.userName,
      @required this.chatRoomId,
      this.friendName,
      this.latestMessage,
      this.lastMessageTime,
      this.friendEmail,
      this.unreadNumber});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: currentUser,
              )
            ],
            child: ChatScreen(
              chatRoomId: chatRoomId,
              friendName: friendName,
              friendEmail: friendEmail,
              initialChat: 0,
              myEmail: currentUser.email,
            ),
          );
        }));
      },
      child: Container(
        height: 83,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    height: 65,
                    width: 65,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffFF7E40),
                          radius: sidebarSize / 10,
                          child: Container(
                            child: Text(
                              // 单个字22，双子18
                              friendName[0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        unreadNumber > 0
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
                    padding: const EdgeInsets.only(left: 18.0, top: 5),
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
                          height: 10,
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
