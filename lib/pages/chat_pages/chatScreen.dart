// import 'package:app_test/pages/chat_pages/pictureDisplay.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/chat_pages/previewImage.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_test/widgets/LinkWellModified.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:app_test/pages/chat_pages/searchChat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String friendName;
  final String friendEmail;
  final String friendID;
  final double initialChat;
  final String myEmail;
  final double friendProfileColor;

  ChatScreen(
      {this.chatRoomId,
      this.friendName,
      this.friendEmail,
      this.friendID,
      this.initialChat,
      this.myEmail,
      this.friendProfileColor});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File _imageFile;
  String _uploadedFileURL;
  final _picker = ImagePicker();
  bool showStickerKeyboard;
  bool showTextKeyboard;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  bool displayTime;
  bool displayWeek;
  bool showFunctions;
  bool lastMessage;
  List<String> friendCourse = [];
  ScrollController _controller;
  FocusNode myFocusNode = FocusNode();
  TextSelection currentTextCursor;

  Stream chatMessageStream;
  Future friendCoursesFuture;

  Widget chatMessageList(String myEmail) {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                controller: _controller,
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DateTime current = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.docs[index].data()['time']);
                  if (index == snapshot.data.docs.length - 1) {
                    displayTime = true;
                  } else {
                    DateTime prev = DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.docs[index + 1].data()['time']);
                    final difference = current.difference(prev).inDays;
                    if (difference >= 1) {
                      displayTime = true;
                    } else {
                      displayTime = false;
                    }
                  }

                  if (index == 0) {
                    lastMessage = true;
                  } else {
                    lastMessage = false;
                  }

                  if (DateTime.now().difference(current).inDays <= 7) {
                    displayWeek = true;
                  } else {
                    displayWeek = false;
                  }

                  return snapshot.data.docs[index].data()['messageType'] ==
                          'text'
                      ? MessageTile(
                          snapshot.data.docs[index].data()['message'],
                          snapshot.data.docs[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.docs[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage)
                      : ImageTile(
                          snapshot.data.docs[index].data()['message'],
                          snapshot.data.docs[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.docs[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage,
                        );
                })
            : Container();
      },
    );
  }

  sendMessage(UserData currentUser) {
    if (messageController.text.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'messageType': 'text',
        'sendBy': currentUser.email,
        'time': lastMessageTime,
        'sendById': currentUser.userID,
        'sendToId': widget.friendID
      };
      // print(widget.chatRoomId);
      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      databaseMethods.setLatestMessage(
          widget.chatRoomId, messageController.text, lastMessageTime);
      databaseMethods
          .getUnreadNumber(widget.chatRoomId, widget.friendEmail)
          .then((value) {
        final unreadNumber = value.data()[widget.friendEmail
                    .substring(0, widget.friendEmail.indexOf('@')) +
                'unread'] +
            1;
        databaseMethods.setUnreadNumber(
            widget.chatRoomId, widget.friendEmail, unreadNumber);
      });

      _controller.jumpTo(_controller.position.minScrollExtent);
      messageController.text = '';
    }
  }

  sendInviteMeetMessage(myEmail, meetID, currentUserName) {
    final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> messageMap = {
      'message':
          '$currentUserName is inviting you to a call\n\nClick on https://meet.jit.si/$meetID \nto open in Meechu\n\n\nOR paste in your PC browser',
      'messageType': 'text',
      'isMeetInvite': true,
      'sendBy': myEmail,
      'time': lastMessageTime,
    };
    // print(widget.chatRoomId);
    databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
    databaseMethods.setLatestMessage(
        widget.chatRoomId, 'Your are invited to a video call', lastMessageTime);
    databaseMethods
        .getUnreadNumber(widget.chatRoomId, widget.friendEmail)
        .then((value) {
      final unreadNumber = value.data()[
              widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) +
                  'unread'] +
          1;
      databaseMethods.setUnreadNumber(
          widget.chatRoomId, widget.friendEmail, unreadNumber);
    });

    // _controller.jumpTo(_controller.position.minScrollExtent);
    // messageController.text = '';
  }

  sendImage(myEmail) {
    if (_uploadedFileURL.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        'message': _uploadedFileURL,
        'messageType': 'image',
        'sendBy': myEmail,
        'time': lastMessageTime,
      };

      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      databaseMethods.setLatestMessage(
          widget.chatRoomId, '[image]', lastMessageTime);
      databaseMethods
          .getUnreadNumber(widget.chatRoomId, widget.friendEmail)
          .then((value) {
        final unreadNumber = value.data()[widget.friendEmail
                    .substring(0, widget.friendEmail.indexOf('@')) +
                'unread'] +
            1;
        databaseMethods.setUnreadNumber(
            widget.chatRoomId, widget.friendEmail, unreadNumber);
      });

      _controller.jumpTo(_controller.position.minScrollExtent);
      _uploadedFileURL = '';
    }
  }

  Future _pickImage(ImageSource source, myEmail, context, currentUser) async {
    PickedFile selected = await _picker.getImage(source: source);

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return MultiProvider(
    //         providers: [
    //           Provider<UserData>.value(
    //             value: currentUser,
    //           ),
    //         ],
    //         child: ConfirmImage(
    //           imageFile: File(selected.path)
    //         ),
    //       );
    //     })
    // );

    setState(() {
      _imageFile = File(selected.path);
    });

    _showImageConfirmDialog(context, currentUser.email);

    // if (selected != null) {
    //   _uploadFile(myEmail);
    //   print('Image Path $_imageFile');
    // }

//    Navigator.push(context, MaterialPageRoute(
//        builder: (context) => PictureDisplay(imageFile: File(selected.path))
//    ));
  }

  Future _uploadFile(myEmail) async {
    String fileName = basename(_imageFile.path);
    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      setState(() {
        _uploadedFileURL = downloadUrl;
        // print('picture uploaded');
        // print(_uploadedFileURL);
        sendImage(myEmail);
      });
    });
  }

  Future<void> _showImageConfirmDialog(context, myEmail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send this image?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.file(
                  _imageFile,
                  width: MediaQuery.of(context).size.width / 2,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('send'),
              onPressed: () {
                _uploadFile(myEmail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _findCursor() {
    currentTextCursor = messageController.selection;
    print('current: ');
    print(currentTextCursor.start);
  }

  void _insertText(String tmpInserted) {
    final tmpText = messageController.text;
    // print('tmpText: ' + tmpText);
    // print('start: ');
    // print(currentTextCursor.start);
    // print('end: ' );
    // print(currentTextCursor.end);
    final newText = tmpText.replaceRange(currentTextCursor.start, currentTextCursor.end, tmpInserted);
    messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: currentTextCursor.baseOffset + tmpInserted.length),
    );
  }

  // Future _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //     sourcePath: _imageFile.path,
  //   );
  //
  //   setState(() {
  //     _imageFile = cropped ?? _imageFile;
  //   });
  // }
  //
  // void _clear() {
  //   setState(() {
  //     _imageFile = null;
  //   });
  // }

  @override
  void initState() {
    databaseMethods.getChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    friendCoursesFuture = databaseMethods.getFriendCourses(widget.friendEmail);
    friendCoursesFuture.then((value) {
      value.docs.forEach((element) {
        setState(() {
          friendCourse.add(element.data()['myCourseName']);
        });
      });
    });
    databaseMethods.setUnreadNumber(widget.chatRoomId, widget.myEmail, 0);
    showStickerKeyboard = false;
    showTextKeyboard = false;
    showFunctions = false;
    _controller =
        ScrollController(initialScrollOffset: widget.initialChat * 40);
    super.initState();
  }

  // a helper function for createChatRoomAndStartConversation()
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final currentUser = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);
    double sidebarSize = _width * 0.05;
    _joinMeeting() async {
      String chatRoomId = getChatRoomId(currentUser.email, widget.friendEmail)
          .replaceAll(RegExp("@[a-zA-Z0-9]+\.[a-zA-Z]+"), '');
      print(chatRoomId);
      
      try {
        Map<FeatureFlagEnum, bool> featureFlags = {
          FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        };
        // Here is an example, disabling features for each platform
        if (Platform.isAndroid) {
          // Disable ConnectionService usage on Android to avoid issues (see README)
          featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        } else if (Platform.isIOS) {
          // Disable PIP on iOS as it looks weird
          featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        }

        // old version jitsi meet
        // FeatureFlag featureFlag = FeatureFlag();
        // featureFlag.welcomePageEnabled = false;
        // not sure how to use this in new version
        // featureFlagEnum.RESOLUTION = FeatureFlagVideoResolution
        //     .MD_RESOLUTION; // Limit video resolution to 360p

        var options = JitsiMeetingOptions()
          ..room = chatRoomId // Required, spaces will be trimmed
          // ..serverURL = "https://na-cc.com"
          ..subject = chatRoomId
          ..userDisplayName = currentUser.userName
          ..userEmail = currentUser.email
          // ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
          ..audioOnly = true
          ..audioMuted = true
          ..videoMuted = true
          ..featureFlags.addAll(featureFlags);

        await JitsiMeet.joinMeeting(options).then((value) {
          if (value.isSuccess) {
            sendInviteMeetMessage(
                currentUser.email, chatRoomId, currentUser.userName);
          }
        });
      } catch (error) {
        debugPrint("error: $error");
      }
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Color(0xffF9F6F1),
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                  showStickerKeyboard = false;
                  showTextKeyboard = false;
                  showFunctions = false;
                });
              },
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: _height*0.10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: _width*1/6,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: sidebarSize*0.55),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/arrow_back.png',
                              height: 17.96,
                              width: 10.26,
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFF7E40),
                            onPressed: () {
                              databaseMethods.setUnreadNumber(
                                  widget.chatRoomId, widget.myEmail, 0);
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.userID)
                                  .update({'chattingWith': 'null'});
                              Navigator.of(context).pop();
                            },
                          ),
                          // iconSize: 30.0,
                        ),
                        Container(
                          width: _width*2/3,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
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
                                  child: FriendProfile(
                                    userID: widget
                                        .friendID, // to be modified to friend's ID
                                  ),
                                );
                              }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CircleAvatar(
                                    backgroundColor: listProfileColor[
                                        widget.friendProfileColor.toInt()],
                                    radius: sidebarSize,
                                    child: Container(
                                      child: Text(
                                        (widget.friendName.split(' ').length >=
                                                    2 &&
                                                widget.friendName
                                                    .split(' ')[widget
                                                            .friendName
                                                            .split(' ')
                                                            .length -
                                                        1]
                                                    .isNotEmpty)
                                            ? widget.friendName
                                                    .split(' ')[0][0]
                                                    .toUpperCase() +
                                                widget.friendName
                                                    .split(' ')[widget
                                                            .friendName
                                                            .split(' ')
                                                            .length -
                                                        1][0]
                                                    .toUpperCase()
                                            : widget.friendName[0]
                                                .toUpperCase(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: widget.friendName
                                                        .split(' ')
                                                        .length >=
                                                    2
                                                ? 14
                                                : 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.friendName,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        friendCourse.isNotEmpty
                                            ? friendCourse.toString().substring(
                                                1,
                                                friendCourse.toString().length -
                                                    1)
                                            : 'No courses yet',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Color(0xff949494),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 0.0),
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.phone,
                        //       size: 26,
                        //       color: Color(0xffFF7E40),
                        //     ),
                        //     // iconSize: 10.0,
                        //     onPressed: () {
                        //       _joinMeeting();
                        //     },
                        //   ),
                        // ),
                        Container(
                          width: _width*1/6,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: sidebarSize*0.55),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/search.png',
                              height: 23,
                              width: 23,
                              color: Color(0xffFF7E40),
                            ),
                            // iconSize: 10.0,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MultiProvider(
                                  providers: [
                                    Provider<UserData>.value(
                                      value: currentUser,
                                    ),
                                    Provider<List<CourseInfo>>.value(
                                        value: currentCourse)
                                  ],
                                  child: SearchChat(
                                      chatRoomId: widget.chatRoomId,
                                      friendName: widget.friendName,
                                      friendEmail: widget.friendEmail,
                                      friendProfileColor:
                                          widget.friendProfileColor,
                                      myEmail: widget.myEmail,
                                      myName: currentUser.userName,
                                      myProfileColor:
                                          currentUser.profileColor),
                                );
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: (currentUser.blockedUserID != null &&
                              currentUser.blockedUserID
                                  .contains(widget.friendID))
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: riceColor,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(30.0),
                                    topRight: const Radius.circular(30.0),
                                  )),
                              height: MediaQuery.of(context).size.height * 0.5,

                              // decoration: BoxDecoration(
                              //   color: Colors.blue,
                              //   borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(30.0),
                              //     topRight: Radius.circular(30.0),
                              //   ),
                              // ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: _height * 0.20,
                                    ),
                                    Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                              height: 140,
                                              width: _width - 40,
                                              child: FittedBox(
                                                child: Image.asset(
                                                    'assets/icon/sorryBox.png'),
                                                fit: BoxFit.fill,
                                              )),
                                          Text(
                                            "Let\'s not talk to this guy",
                                            style: largeTitleTextStyle(
                                                Colors.black, 26),
                                          ),
                                        ]),
                                    Container(
                                        height: 140,
                                        width: 140,
                                        child: FittedBox(
                                          child: Image.asset(
                                              'assets/icon/failToFind.png'),
                                          fit: BoxFit.fill,
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : chatMessageList(currentUser.email)),
                  Container(
                      decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    // height: 74.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: Container(
                          // height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffF9F6F1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 4,
                            onTap: () {
                              setState(() {
                                showStickerKeyboard = false;
                                showTextKeyboard = true;
                                showFunctions = false;
                              });
                              Timer(
                                  Duration(milliseconds: 160),
                                  () => _controller.jumpTo(
                                      _controller.position.minScrollExtent));
                            },
                            focusNode: myFocusNode,
                            controller: messageController,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              sendMessage(currentUser);
                              myFocusNode.requestFocus();
                            },
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: GestureDetector(
                              child: showStickerKeyboard
                                  ? Image.asset(
                                      'assets/images/emoji_on_click.png',
                                      width: 29,
                                      height: 27.83)
                                  : Image.asset('assets/images/emoji.png',
                                      width: 29, height: 27.83),
                              onTap: () {
                                _findCursor();
                                if (showTextKeyboard) {
                                  setState(() {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                      showTextKeyboard = false;
                                    }
                                  });
                                } else {
                                  if (showFunctions) {
                                    setState(() {
                                      showFunctions = false;
                                    });
                                  } else {}
                                }
                                setState(() {
                                  showStickerKeyboard = !showStickerKeyboard;
                                });
                                Timer(
                                    Duration(milliseconds: 30),
                                    () => _controller.jumpTo(
                                        _controller.position.minScrollExtent));
                              }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 25.0),
                          child: GestureDetector(
                              onTap: () {
                                if (showTextKeyboard) {
                                  setState(() {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                      showTextKeyboard = false;
                                    }
                                  });
                                } else {
                                  if (showStickerKeyboard) {
                                    setState(() {
                                      showStickerKeyboard = false;
                                    });
                                  } else {}
                                }
                                setState(() {
                                  showFunctions = !showFunctions;
                                });
                                Timer(
                                    Duration(milliseconds: 30),
                                    () => _controller.jumpTo(
                                        _controller.position.minScrollExtent));
                              },
                              child: (showStickerKeyboard || showTextKeyboard)
                                  ? GestureDetector(
                                      child: Image.asset(
                                        'assets/images/messageSend.png',
                                        height: 28,
                                        width: 28,
                                      ),
                                      onTap: () {
                                        sendMessage(currentUser);
                                      },
                                    )
                                  : showFunctions
                                      ? Image.asset(
                                          'assets/images/plus_on_click.png',
                                          width: 28,
                                          height: 28)
                                      : Image.asset('assets/images/plus.png',
                                          width: 28, height: 28)),
                        )
                      ],
                    ),
                  ),
                  showStickerKeyboard
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 80),
                          height: _height*0.35,
                          // showStickerKeyboard ? 400 : 0,
                          child: EmojiPicker(
                            config: const Config(
                              // rows: 4,
                              columns: 7,
                              buttonMode: ButtonMode.MATERIAL,
                              // numRecommended: 10,
                            ),
                            onEmojiSelected: (Category category, Emoji emoji) {
                              _insertText(emoji.emoji);
                            },
                          ),
                        )
                      : Container(),
                  showFunctions
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 80),
                          height: 80,
                          width: _width,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: _height*0.095,
                                  width: _width*0.16,
                                  child: IconButton(
                                      icon: Image.asset(
                                        'assets/images/camera.png',
                                      ),
                                      onPressed: () {
                                        _pickImage(
                                            ImageSource.camera,
                                            currentUser.email,
                                            context,
                                            currentUser);
                                      }),
                                ),
                                Container(
                                  height: _height*0.095,
                                  width: _width*0.16,
                                  child: IconButton(
                                      icon: Image.asset(
                                        'assets/images/photo_library.png',
                                      ),
                                      onPressed: () => _pickImage(
                                          ImageSource.gallery,
                                          currentUser.email,
                                          context,
                                          currentUser)),
                                ),
                                Container(
                                  height: _height*0.095,
                                  width: _width*0.16,
                                  child: IconButton(
                                    icon: Icon(
                                        Icons.phone,
                                        // size: 26,
                                        color: Color(0xffFF7E40)
                                    ),
                                    // iconSize: 10.0,
                                    onPressed: () {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) => CupertinoAlertDialog(
                                          content: Text('Join the call?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _joinMeeting();
                                                Navigator.pop(context, 'Yes');
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                        barrierDismissible: true
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  height: _height*0.095,
                                  width: _width*0.16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String currentTime;
  final bool displayTime;
  final bool displayWeek;
  final bool lastMessage;

  MessageTile(this.message, this.isSendByMe, this.currentTime, this.displayTime,
      this.displayWeek, this.lastMessage);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    return Column(
      children: [
        displayWeek
            ? displayTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('EEEE')
                                .format(DateTime.parse(currentTime))
                                .substring(0, 3) +
                            ', ' +
                            DateFormat('MMMM')
                                .format(DateTime.parse(currentTime))
                                .substring(0, 3) +
                            ' ' +
                            DateFormat('d').format(DateTime.parse(currentTime)),
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: const Color(0xff949494),
                        ),
                      ),
                    ),
                  )
                : Container()
            : displayTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        currentTime.substring(0, currentTime.length - 13),
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: const Color(0xff949494),
                        ),
                      ),
                    ),
                  )
                : Container(),
        // Message Box
        isSendByMe
            ? Container(
                padding: EdgeInsets.only(top: 20, right: 25),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Message and Time
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentTime.substring(11, currentTime.length - 7),
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xff949494),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12)),
                                  color: const Color(0xffF7D5C5)),
                              child: SelectableText.rich(
                                linkwellFunc(message, null, null, currentUser),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                toolbarOptions:
                                    ToolbarOptions(selectAll: true, copy: true),
                              ),

                              // SelectableText(
                              //   message,
                              //   textAlign: TextAlign.start,
                              //   style: GoogleFonts.openSans(
                              //     fontSize: 16,
                              //     color: Colors.black,
                              //   ),
                              //   toolbarOptions:
                              //       ToolbarOptions(selectAll: true, copy: true),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 20, left: 25),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message and Time
                    Container(
                      width: 350,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                  color: Colors.white),
                              child: SelectableText.rich(
                                linkwellFunc(message, null, null, currentUser),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                toolbarOptions:
                                    ToolbarOptions(selectAll: true, copy: true),
                              ),
                            ),
                          ),
                          Text(
                            currentTime.substring(11, currentTime.length - 7),
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xff949494),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: lastMessage ? 20 : 0,
        )
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String currentTime;
  final bool displayTime;
  final bool displayWeek;
  final bool lastMessage;

  ImageTile(this.message, this.isSendByMe, this.currentTime, this.displayTime,
      this.displayWeek, this.lastMessage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayWeek
            ? displayTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('EEEE')
                                .format(DateTime.parse(currentTime))
                                .substring(0, 3) +
                            ', ' +
                            DateFormat('MMMM')
                                .format(DateTime.parse(currentTime))
                                .substring(0, 3) +
                            ' ' +
                            DateFormat('d').format(DateTime.parse(currentTime)),
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: const Color(0xff949494),
                        ),
                      ),
                    ),
                  )
                : Container()
            : displayTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        currentTime.substring(0, currentTime.length - 13),
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: const Color(0xff949494),
                        ),
                      ),
                    ),
                  )
                : Container(),
        // Message Box
        isSendByMe
            ? Container(
                padding: EdgeInsets.only(top: 20, right: 25),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Message and Time
                    Container(
                      width: 350,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentTime.substring(11, currentTime.length - 7),
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xff949494),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewImage(
                                      imageUrl: message,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: CachedNetworkImage(
                                      imageUrl: message,
                                      placeholder: (context, url) => Container(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child:
                                                new CircularProgressIndicator(
                                              backgroundColor: themeOrange,
                                            ),
                                          )),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                      height: 180.0,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 20, left: 25),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message and Time
                    Container(
                      width: 350,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewImage(
                                      imageUrl: message,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: CachedNetworkImage(
                                      imageUrl: message,
                                      placeholder: (context, url) =>
                                          new Container(
                                              height: 70,
                                              width: 70,
                                              child: Center(
                                                child:
                                                    new CircularProgressIndicator(
                                                  backgroundColor: themeOrange,
                                                ),
                                              )),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                      height: 180.0,
                                    ),
                                  )),
                            ),
                          ),
                          Text(
                            currentTime.substring(11, currentTime.length - 7),
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xff949494),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: lastMessage ? 20 : 0,
        )
      ],
    );
  }
}
