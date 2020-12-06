import 'package:app_test/models/message_model.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/pages/chat_pages/chatRoom.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';

class ChatRoom extends StatefulWidget {
  final String myName;

  ChatRoom({this.myName});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  String friendName;
  String latestMessage;
  String lastMessageTime;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget chatRoomsList() {
    final currentUser = Provider.of<UserData>(context, listen: false);
    // print('user is:' + currentUser.userName);
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final userList = snapshot.data.documents[index].data['users'];
                  if (userList[0] == widget.myName) {
                    friendName = userList[1];
                  } else {
                    friendName = userList[0];
                  }

                  latestMessage = snapshot.data.documents[index].data['latestMessage'];
                  lastMessageTime = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.documents[index].data['lastMessageTime']
                  ).toString();

                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(currentUser.userName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                    friendName: friendName,
                    latestMessage: latestMessage,
                    lastMessageTime: lastMessageTime
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats(widget.myName);
    super.initState();
  }

  getUserInfogetChats(myName) async {
    databaseMethods.getChatRooms(myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${myName}");
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
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 8.0, right:15.0),
            //     child:
            //   ),
            // ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 40, bottom: 20),
                    child: Container(
                      child: Text(
                        'Chats',
                        textAlign: TextAlign.left,
                        style: largeTitleTextStyle(
                        // GoogleFonts.montserrat(
                          Colors.black,
                          // fontWeight: FontWeight.bold,
                          // fontSize: 28
                        )
                      ),
                    ),
                  ),
                  // IconButton(icon: Image.asset('name'), onPressed: null)
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

  ChatRoomsTile({this.userName, @required this.chatRoomId, this.friendName, this.latestMessage, this.lastMessageTime});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
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
              friendName: friendName
            ),
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      radius: 32.0,
                      backgroundImage: AssetImage('assets/images/sam.jpg'),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffFF7E40)
                          ),
                        ),
                        SizedBox(height: 4,),
                        Container(
                          width: 240,
                          child: Text(
                              latestMessage,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.black
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  child: Text(
                    lastMessageTime.substring(11, lastMessageTime.length - 7),
                    style: GoogleFonts.openSans(
                      fontSize: 10,
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
