import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/providers/contactProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

_toastInfo(String info) {
  Fluttertoast.showToast(
    msg: info,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
    gravity: ToastGravity.CENTER,
  );
}

class _SearchUsersState extends State<SearchUsers> {
  // bool showCancel = false;
  TextEditingController field = TextEditingController();
  String pasteValue = '';
  bool haveUserSearched = false;
  // FocusNode _focus = new FocusNode();
  QuerySnapshot searchSnapshot;
  DocumentSnapshot searchURLsnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  // @override
  // void initState() {
  //   super.initState();
  //   _focus.addListener(_onFocusChange);
  // }

  @override
  void initState() {
    // TODO: implement initState
    // initiateSearch();
    super.initState();
  }

  clearSearchTextInput(FocusScopeNode currentFocus) {
    searchTextEditingController.clear();
    searchBegain = false;
    currentFocus.unfocus();
  }

  TextEditingController searchTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // dev.debugger();

    final user = Provider.of<UserData>(context);
    print(user.userName);
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: themeOrange,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              // showCancel = true;
            });
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          onPanUpdate: (details) {
            if (details.delta.dx > 4) {
              Navigator.pop(context);
            }
          },
          child:
              SafeArea(child: Scaffold(body: buildContainerBody(currentFocus))),
        ));
  }

  Container buildContainerBody(FocusScopeNode currentFocus) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: themeOrange,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Focus(
                    // onFocusChange: (focus) => showCanclChange(),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (searchTextEditingController.text.isNotEmpty) {
                          initiateSearch();
                        }
                      },
                      // focusNode: _focus,
                      controller: searchTextEditingController,
                      textAlign: TextAlign.left,
                      autofocus: true,
                      decoration: InputDecoration(
                        suffixIcon: searchTextEditingController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Image.asset(
                                  'assets/images/cross.png',
                                  // color: Color(0xffFF7E40),
                                  height: 19,
                                  width: 19,
                                ),
                                onPressed: () {
                                  // initiateSearch();
                                  clearSearchTextInput(currentFocus);
                                }),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFFFCDB6),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        // prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Search email...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                          // borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(color: Colors.grey), // KEY PROP
                      ),
                    ),
                  )),
                  // showCancel
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // RichText(
            //   text: TextSpan(
            //     style: TextStyle(color: Colors.grey, fontSize: 15.0),
            //     children: <TextSpan>[
            //       TextSpan(text: 'I have User Profile '),
            //       TextSpan(
            //           text: 'URL',
            //           style: TextStyle(color: Colors.blue),
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = () async {
            //               FlutterClipboard.paste().then((value) async {
            //                 setState(() {
            //                   field.text = value;
            //                   pasteValue = value;
            //                 });
            //                 print('Clipboard Text: $pasteValue');
            //                 if (pasteValue.startsWith('https://na-cc.com/')) {
            //                   searchBegain = true;
            //                   var splitTemp = pasteValue.split('/');
            //                   print(splitTemp[4]);
            //                   await initiateURLSearch(splitTemp[4]);
            //                 }
            //                 // searchBegain
            //                 //     ? showBottomPopSheet(
            //                 //         context, searchList(context, course))
            //                 //     : CircularProgressIndicator();
            //               });
            //             }),
            //     ],
            //   ),
            // ),
            searchList(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  bool searchBegain = false;
  initiateSearch() async {
    var temp =
        await databaseMethods.getUsersByEmail(searchTextEditingController.text);
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.docs != null) {
        if ((searchSnapshot.docs.length >= 1) &&
            (searchTextEditingController.text.isNotEmpty)) {
          searchBegain = true;
        }
      }
    });
  }

  initiateURLSearch(String pastedUserID) async {
    var temp = await databaseMethods.getUsersById(pastedUserID);
    // if (temp == null) return;
    setState(() {
      searchURLsnapshot = temp;
      if (searchURLsnapshot != null) {
        if ((pastedUserID.isNotEmpty)) {
          searchBegain = true;
        }
      }
    });
  }

  // a function to create chat room
  // createChatRoomAndStartConversation(String userName, String userEmail) {
  //   final currentUser = Provider.of<UserData>(context, listen: false);
  //   final myName = currentUser.userName;
  //   final myEmail = currentUser.email;
  //   if (userEmail != myEmail) {
  //     String chatRoomId = getChatRoomId(userEmail, myEmail);
  //     final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
  //
  //     List<String> users = [userName, userEmail, myName, myEmail];
  //     Map<String, dynamic> chatRoomMap = {
  //       'users': users,
  //       'chatRoomId': chatRoomId,
  //       'latestMessage': ('Hi! My name is ' + myName + '. Nice to meet you!'),
  //       'lastMessageTime': lastMessageTime,
  //       (userEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 1,
  //       (myEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 0
  //     };
  //
  //     databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
  //     Map<String, dynamic> messageMap = {
  //       'message': 'Hi! My name is ' + myName + '. Nice to meet you!',
  //       'messageType': 'text',
  //       'sendBy': myEmail,
  //       'time': lastMessageTime,
  //     };
  //
  //     databaseMethods.addChatMessages(chatRoomId, messageMap);
  //
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return MultiProvider(
  //         providers: [
  //           Provider<UserData>.value(
  //             value: currentUser,
  //           )
  //         ],
  //         child: ChatScreen(
  //           chatRoomId: chatRoomId,
  //           friendEmail: userEmail,
  //           friendName: userName,
  //           initialChat: 0,
  //           myEmail: currentUser.email,
  //         ),
  //       );
  //     }));
  //   } else {
  //     print('This is your account!');
  //   }
  // }
  //
  // // a helper function for createChatRoomAndStartConversation()
  // getChatRoomId(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return '$b\_$a';
  //   } else {
  //     return '$a\_$b';
  //   }
  // }

  // searchTile for searchList

  // Widget searchTile({String userName, String userEmail, String imageURL}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     child: Row(
  //       children: <Widget>[
  //         CircleAvatar(
  //           radius: 30.0,
  //           backgroundImage: NetworkImage("${imageURL}"),
  //           backgroundColor: Colors.transparent,
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         Container(
  //           // color: Colors.black12,
  //           width: 180,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Text(
  //                 userName ?? '',
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //               SizedBox(
  //                 height: 3,
  //               ),
  //               Text(
  //                 userEmail ?? '',
  //                 style: TextStyle(color: Colors.grey, fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // SizedBox(
  //         //   width: 10,
  //         // ),
  //         Expanded(
  //           child: RaisedGradientButton(
  //             width: 100,
  //             height: 40,
  //             gradient: LinearGradient(
  //               colors: <Color>[Colors.red, orengeColor],
  //             ),
  //             onPressed: () {
  //               //TODO
  //               createChatRoomAndStartConversation(userName, userEmail);
  //             },
  //             //之后需要根据friendsProvider改这部分display
  //             //TODO
  //             child: Text(
  //               'Message',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //         // Spacer(),
  //       ],
  //     ),
  //   );
  // }

  Widget searchList() {
    if (searchBegain &&
        searchTextEditingController.text.isNotEmpty &&
        searchSnapshot.docs != null &&
        searchSnapshot.docs.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: searchSnapshot.docs.length,
          shrinkWrap: true, //when you have listview in column
          itemBuilder: (context, index) {
            return SearchTile(
              school: searchSnapshot.docs[index].data()['school'] ?? '',
              userID: searchSnapshot.docs[index].id ?? '',
              userName:
                  // "peter",
                  searchSnapshot.docs[index].data()['userName'] ?? '',
              userEmail:
                  // "731957665@qq.com",
                  searchSnapshot.docs[index].data()['email'] ?? '',
              userProfileColor:
                  // 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                  searchSnapshot.docs[index]
                          .data()['profileColor']
                          .toDouble() ??
                      0.0,
            );
          });
    } else if (searchBegain && pasteValue.startsWith('https://na-cc.com/')) {
      return SearchTile(
        school: searchURLsnapshot.data()['school'] ?? '',
        userID: searchURLsnapshot.id ?? '',
        userName:
            // "peter",
            searchURLsnapshot.data()['userName'] ?? '',
        userEmail:
            // "731957665@qq.com",
            searchURLsnapshot.data()['email'] ?? '',
        userProfileColor:
            // 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
            searchURLsnapshot.data()['profileColor'].toDouble() ?? 0.0,
      );
    } else if (pasteValue.isNotEmpty &&
        !pasteValue.startsWith('https://na-cc.com/')) {
      return Container(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: Colors.grey, fontSize: 15.0),
            children: <TextSpan>[
              TextSpan(text: 'Your URL is not valid:\n'),
              TextSpan(
                text: pasteValue,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
          // padding: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
          // child: Row(
          //   children: <Widget>[
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Text(
          //           "Please enter the correct Email",
          //           style: simpleTextStyle(),
          //         ),
          //       ],
          //     ),
          //     Spacer(),
          //   ],
          // ),
          );
    }
  }
}

//searchTile for searchList

class SearchTile extends StatelessWidget {
  final UserDatabaseService userDatabaseService = UserDatabaseService();
  final DatabaseMethods databaseMethods = DatabaseMethods();
  final String school;
  final String userID;
  final String userName;
  final String userEmail;
  final double userProfileColor;
  SearchTile(
      {this.school,
      this.userID,
      this.userName,
      this.userEmail,
      this.userProfileColor});

  // a helper function for createChatRoomAndStartConversation()
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  // a function to create chat room
  createChatRoomAndStartConversation(String userName, String userEmail,
      String userID, double userProfileColor, context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    final myName = currentUser.userName;
    final myEmail = currentUser.email;
    final myID = currentUser.userID;
    final myProfileColor = currentUser.profileColor;
    if (userEmail != myEmail) {
      String chatRoomId = getChatRoomId(userEmail, myEmail);
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;

      List<dynamic> users = [
        userName,
        userEmail,
        userID,
        userProfileColor,
        myName,
        myEmail,
        myID,
        myProfileColor
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
            friendID: userID,
            chatRoomId: chatRoomId,
            friendEmail: userEmail,
            friendName: userName,
            initialChat: 0,
            friendProfileColor: userProfileColor,
            myEmail: currentUser.email,
          ),
        );
      }));
    } else {
      print('This is your account!');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final contactProvider = Provider.of<ContactProvider>(context);

    // // a helper function for createChatRoomAndStartConversation()
    // getChatRoomId(String a, String b) {
    //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    //     return '$b\_$a';
    //   } else {
    //     return '$a\_$b';
    //   }
    // }
    //
    // // a function to create chat room
    // createChatRoomAndStartConversation(
    //     String userName, String userEmail, String userID, double userProfileColor) {
    //   final currentUser = Provider.of<UserData>(context, listen: false);
    //   final myName = currentUser.userName;
    //   final myEmail = currentUser.email;
    //   final myID = currentUser.userID;
    //   final myProfileColor = currentUser.profileColor;
    //   if (userEmail != myEmail) {
    //     String chatRoomId = getChatRoomId(userEmail, myEmail);
    //     final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    //
    //     List<String> users = [
    //       userName,
    //       userEmail,
    //       userID,
    //       myName,
    //       myEmail,
    //       myID,
    //     ];
    //     Map<String, dynamic> chatRoomMap = {
    //       'users': users,
    //       'chatRoomId': chatRoomId,
    //       'latestMessage': ('Hi! My name is ' + myName + '. Nice to meet you!'),
    //       'lastMessageTime': lastMessageTime,
    //       (userEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 1,
    //       (myEmail.substring(0, userEmail.indexOf('@')) + 'unread'): 0
    //     };
    //
    //     databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    //
    //     Map<String, dynamic> messageMap = {
    //       'message': 'Hi! My name is ' + myName + '. Nice to meet you!',
    //       'messageType': 'text',
    //       'sendBy': myEmail,
    //       'time': lastMessageTime,
    //     };
    //
    //     databaseMethods.addChatMessages(chatRoomId, messageMap);
    //
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return MultiProvider(
    //         providers: [
    //           Provider<UserData>.value(
    //             value: currentUser,
    //           )
    //         ],
    //         child: ChatScreen(
    //           friendID: userID,
    //           chatRoomId: chatRoomId,
    //           friendEmail: userEmail,
    //           friendName: userName,
    //           initialChat: 0,
    //           myEmail: currentUser.email,
    //         ),
    //       );
    //     }));
    //   } else {
    //     print('This is your account!');
    //   }
    // }

    final userdata = Provider.of<UserData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: userdata,
              ),
              // 这个需要的话直接uncomment
              // Provider<List<CourseInfo>>.value(
              //   value: course,
              // ),
              // final courseProvider = Provider.of<CourseProvider>(context);
              // 上面这个courseProvider用于删除添加课程，可以直接在每个class之前define，
              // 不需要pass到push里面，直接复制上面这行即可
            ],
            child: FriendProfile(
              userID: userID, // to be modified to friend's ID
            ),
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            creatUserImageWithString(
              24,
              userName ?? '',
              userProfileColor ?? 1.0,
              simpleTextSansStyleBold(Colors.white, 18),
            ),
            // CircleAvatar(
            //   radius: 30.0,
            //   backgroundImage: NetworkImage("${imageURL}"),
            //   backgroundColor: Colors.transparent,
            // ),
            SizedBox(
              width: _width * 0.027,
            ),
            Container(
              width: _width * 0.29,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    userName ?? '',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  AutoSizeText(
                    userEmail ?? '',
                    style: simpleTextStyle(Colors.grey, 14),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(right: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                width: _width * 0.277,
                height: 40,
                child: RaisedButton(
                  hoverElevation: 0,
                  highlightColor: Color(0xDA6D39),
                  highlightElevation: 0,
                  elevation: 0,
                  color: themeOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    //TODO
                    if (userID == userdata.userID) {
                      _toastInfo('This is your account');
                    } else {
                      contactProvider.changeSchool(school);
                      contactProvider.changeUserID(userID);
                      contactProvider.changeEmail(userEmail);
                      contactProvider.changeUserName(userName);
                      contactProvider.changeUserImageUrl('imageURL');
                      contactProvider.addUserToContact(context);
                      createChatRoomAndStartConversation(userName, userEmail,
                          userID, userProfileColor, context);
                    }
                  },
                  child: AutoSizeText(
                    'Message',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
