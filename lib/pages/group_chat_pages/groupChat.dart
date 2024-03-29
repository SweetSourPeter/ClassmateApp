import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/chat_pages/previewImage.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/pages/group_chat_pages/atPeople.dart';
import 'package:app_test/pages/group_chat_pages/courseDetail.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:app_test/widgets/LinkWellModified.dart';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'groupNotice.dart';

class GroupChat extends StatefulWidget {
  final String courseId;
  final double initialChat;
  final String myEmail;
  final String myName;
  final String myId;

  GroupChat(
      {this.courseId, this.initialChat, this.myEmail, this.myName, this.myId});

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
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
  ScrollController _controller;
  String courseName;
  String courseSection;
  String courseTerm;
  int numberOfMembers = 0;
  FocusNode myFocusNode = FocusNode();
  bool displayName;
  String previousText;
  TextSelection currentTextCursor;
  bool isChoosingToAt;

  Stream chatMessageStream;
  List<dynamic> memberInfo;
  List<String> membersToAt;
  List<String> memberIdsToAt;

  @override
  void initState() {
    super.initState();
    databaseMethods.getGroupChatMessages(widget.courseId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    // databaseMethods.setUnreadGroupChatNumberToZero(
    //     widget.courseId, widget.myId);

    databaseMethods.getCourseInfo(widget.courseId).then((value) {
      setState(() {
        courseName = value.docs[0].data()['myCourseName'];
        courseSection = value.docs[0].data()['section'];
        courseTerm = value.docs[0].data()['term'];
      });
    });

    databaseMethods.getNumberOfMembersInCourse(widget.courseId).then((value) {
      setState(() {
        numberOfMembers = value.docs.length;
      });
    });

    databaseMethods.getInfoOfMembersInCourse(widget.courseId).then((value) {
      setState(() {
        memberInfo = value;
      });
    });

    showStickerKeyboard = false;
    showTextKeyboard = false;
    showFunctions = false;
    _controller =
        ScrollController(initialScrollOffset: widget.initialChat * 40);
    displayName = true;
    previousText = '';
    membersToAt = [];
    memberIdsToAt = [];
    isChoosingToAt = false;
  }

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
                  String sender = snapshot.data.docs[index].data()['sendBy'];
                  if (index == snapshot.data.docs.length - 1) {
                    displayTime = true;
                    displayName = true;
                  } else {
                    DateTime prev = DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.docs[index + 1].data()['time']);
                    final difference = current.difference(prev).inDays;
                    if (difference >= 1) {
                      displayTime = true;
                    } else {
                      displayTime = false;
                    }

                    String prevSender =
                        snapshot.data.docs[index + 1].data()['sendBy'];
                    if (sender == prevSender) {
                      displayName = false;
                    } else {
                      displayName = true;
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
                    sender == myEmail,
                    DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.docs[index].data()['time'])
                        .toString(),
                    displayTime,
                    displayWeek,
                    lastMessage,
                    snapshot.data.docs[index].data()['senderName'],
                    snapshot.data.docs[index].data()['senderID'],
                    displayName,
                    snapshot.data.docs[index].data()['profileColor'] ??
                        1.0,
                  )
                      : snapshot.data.docs[index].data()['messageType'] ==
                      'groupNotice'
                      ? GroupNoticeTile(
                      snapshot.data.docs[index].data()['message'],
                      lastMessage,
                      widget.courseId
                  )
                      : ImageTile(
                    snapshot.data.docs[index].data()['message'],
                    sender == myEmail,
                    DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.docs[index].data()['time'])
                        .toString(),
                    displayTime,
                    displayWeek,
                    lastMessage,
                    snapshot.data.docs[index].data()['senderName'],
                    snapshot.data.docs[index].data()['senderID'],
                    displayName,
                    snapshot.data.docs[index].data()['profileColor'] ??
                        1.0,
                  );
                })
            : Container();
      },
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

  sendMessage(UserData currentUser) {
    if (messageController.text.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;

      List<String> tmpIdsToAt = [];

      for (var i = 0; i < membersToAt.length; i++) {
        if (messageController.text.contains(membersToAt[i])) {
          tmpIdsToAt.add(memberIdsToAt[i]);
        }
      }

      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'messageType': 'text',
        'sendBy': currentUser.email,
        'senderName': currentUser.userName,
        'time': lastMessageTime,
        'senderID': currentUser.userID,
        'profileColor': currentUser.profileColor,
        'membersToAt': tmpIdsToAt
      };

      databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
      databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
          widget.courseId, currentUser.userID);
      // databaseMethods.setLatestMessage(widget.courseId, messageController.text, lastMessageTime);
      // databaseMethods.getUnreadNumber(widget.courseId, widget.friendEmail).then((value) {
      //   final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
      //   databaseMethods.setUnreadNumber(widget.courseId, widget.friendEmail, unreadNumber);
      // });

      _controller.jumpTo(_controller.position.minScrollExtent);

      setState(() {
        messageController.clear();
        previousText = '';
        membersToAt = [];
        memberIdsToAt = [];
      });
    }
  }

  sendInviteMeetMessage(meetID, UserData currentUser) {
    final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> messageMap = {
      'message':
          '${currentUser.userName} is inviting you to a call\n\nClick on https://meet.jit.si/$meetID \nto open in Meechu\n\n\nOR paste in your PC browser',
      'messageType': 'text',
      'sendBy': currentUser.email,
      'senderName': currentUser.userName,
      'time': lastMessageTime,
      'senderID': currentUser.userID,
      'profileColor': currentUser.profileColor
    };

    databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
    databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
        widget.courseId, currentUser.userID);
    // _controller.jumpTo(_controller.position.minScrollExtent);
    // messageController.text = '';
  }

  sendImage(UserData currentUser) {
    if (_uploadedFileURL.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        'message': _uploadedFileURL,
        'messageType': 'image',
        'sendBy': currentUser.email,
        'senderName': currentUser.userName,
        'time': lastMessageTime,
        'senderID': currentUser.userID,
        'profileColor': currentUser.profileColor
      };

      databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
      databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
          widget.courseId, currentUser.userID);

      _controller.jumpTo(_controller.position.minScrollExtent);
      _uploadedFileURL = '';
    }
  }

  Future _uploadFile(UserData currentUser) async {
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
        sendImage(currentUser);
      });
    });
  }

  Future _pickImage(ImageSource source, UserData currentUser, context) async {
    PickedFile selected = await _picker.getImage(source: source);

    if(selected != null){
      setState(() {
        _imageFile = File(selected.path);
      });

      _showImageConfirmDialog(context, currentUser);
    }
  }

  Future<void> _showImageConfirmDialog(context, currentUser) async {
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
                _uploadFile(currentUser);
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
    print(messageController.text);
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

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final sidebarSize = _width * 0.05;
    _joinMeeting() async {
      String chatRoomId = widget.courseId;
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
            sendInviteMeetMessage(chatRoomId, currentUser);
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
            backgroundColor: const Color(0xffF9F6F1),
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
                    height: _height * 0.10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: sidebarSize*0.55),
                          alignment: Alignment.centerLeft,
                          width: _width*1/6,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/arrow_back.png',
                              height: 17.96,
                              width: 10.26,
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFF7E40),
                            onPressed: () {
                              // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                              // databaseMethods.setUnreadGroupChatNumberToZero(
                              //     widget.courseId, currentUser.userID);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          width: _width*2/3,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (courseName ?? '') + (courseSection ?? ''),
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  numberOfMembers > 1
                                      ? numberOfMembers.toString() +
                                          ' ' +
                                          'people'
                                      : numberOfMembers.toString() +
                                          ' ' +
                                          'person',
                                  style: GoogleFonts.openSans(
                                    color: Color(0xff949494),
                                    fontSize: 14,
                                  )),
                            ],
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
                          padding: EdgeInsets.only(right: sidebarSize * 0.55),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/group_more.png',
                              height: 32.44,
                              width: 41.46,
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
                                      value: currentCourse,
                                    ),
                                  ],
                                  child: CourseDetail(
                                    courseId: widget.courseId,
                                    myEmail: widget.myEmail,
                                    myName: widget.myName,
                                    members: memberInfo
                                  ),
                                );
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: chatMessageList(currentUser.email)),
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                            //Normal textInputField will be displayed
                            maxLines: 4,
                            // when user presses enter it will adapt to it

                            onChanged: (text) async {
                              print('-------------------');
                              print('new: ' + text);
                              print('prev: ' + previousText);

                              final difference = diff(previousText, text);
                              final indexOfNewText = diff(previousText, text).indexWhere((element) => element.operation == 1);

                              _findCursor();
                              print('difference: ');
                              print(difference);
                              print(isChoosingToAt);
                              if (indexOfNewText != -1) {
                                if (difference[indexOfNewText].text == '@' && !isChoosingToAt) {
                                  setState(() {
                                    isChoosingToAt = true;
                                  });

                                  List<String> thePerson = await showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 10,
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0),
                                            // bottomLeft: Radius.circular(30.0),
                                            // bottomRight: Radius.circular(30.0),
                                          )),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return SafeArea(
                                            bottom: false,
                                            child: AtPeople(
                                              courseId: widget.courseId,
                                              members: memberInfo,
                                            ));
                                      });

                                  if (thePerson != null) {
                                    setState(() {
                                      membersToAt.add('@' + thePerson[0]);
                                      memberIdsToAt.add(thePerson[1]);
                                    });

                                    _insertText(thePerson[0] + ' ');
                                  }

                                  setState(() {
                                    isChoosingToAt = false;
                                  });
                                }
                              }

                              previousText = messageController.text;
                            },

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
                            controller: messageController,
                            focusNode: myFocusNode,
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
                              _findCursor();
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
                                FocusScope.of(context).unfocus();
                                if (showTextKeyboard) {
                                  setState(() {
                                    showTextKeyboard = false;
                                  });
                                } else {
                                  if (showFunctions) {
                                    setState(() {
                                      showFunctions = false;
                                    });
                                  } else {}
                                }

                                sleep(Duration(milliseconds:500));
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
                                if ((messageController.text != '' ||
                                    messageController.text.isNotEmpty)) {
                                  sendMessage(currentUser);
                                } else {
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
                                      () => _controller.jumpTo(_controller
                                          .position.minScrollExtent));
                                }
                              },
                              child: (messageController.text != '' ||
                                      messageController.text.isNotEmpty)
                                  ? Image.asset('assets/images/messageSend.png',
                                      width: 28, height: 28)
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
                          height: _height * 0.35,
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
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: _height * 0.095,
                                  width: _width * 0.16,
                                  child: IconButton(
                                      icon: Image.asset(
                                          'assets/images/camera.png'),
                                      onPressed: () => _pickImage(
                                          ImageSource.camera,
                                          currentUser,
                                          context)),
                                ),
                                Container(
                                  height: _height * 0.095,
                                  width: _width * 0.16,
                                  child: IconButton(
                                      icon: Image.asset(
                                          'assets/images/photo_library.png'),
                                      onPressed: () => _pickImage(
                                          ImageSource.gallery,
                                          currentUser,
                                          context)),
                                ),
                                Container(
                                  height: _height * 0.095,
                                  width: _width * 0.16,
                                  child: IconButton(
                                    icon: Icon(Icons.phone,
                                        // size: 26,
                                        color: Color(0xffFF7E40)),
                                    // iconSize: 10.0,
                                    onPressed: () {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                content: Text('Join the call?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _joinMeeting();
                                                      Navigator.pop(
                                                          context, 'Yes');
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                          barrierDismissible: true);
                                    },
                                  ),
                                ),
                                Container(
                                  height: _height * 0.095,
                                  width: _width * 0.16,
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
  final String senderName;
  final String senderID;
  final bool displayName;
  final double profileColor;

  MessageTile(
      this.message,
      this.isSendByMe,
      this.currentTime,
      this.displayTime,
      this.displayWeek,
      this.lastMessage,
      this.senderName,
      this.senderID,
      this.displayName,
      this.profileColor);

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);

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
                                  linkwellFunc(message, null, null, userdata),
                                  textAlign: TextAlign.start,
                                  toolbarOptions: ToolbarOptions(
                                      selectAll: true, copy: true),
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.black,
                                  )),

                              // SelectableText(message,
                              //     textAlign: TextAlign.start,
                              //     toolbarOptions: ToolbarOptions(
                              //         selectAll: true, copy: true),
                              //     style: GoogleFonts.openSans(
                              //       fontSize: 16,
                              //       color: Colors.black,
                              //     )),
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
                    // Sender's name
                    displayName
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MultiProvider(
                                      providers: [
                                        Provider<UserData>.value(
                                          value: userdata,
                                        ),
                                        Provider<List<CourseInfo>>.value(
                                          value: currentCourse,
                                        ),
                                      ],
                                      child: FriendProfile(
                                        userID:
                                            senderID, // to be modified to friend's ID
                                      ),
                                    );
                                  }));
                                },
                                child: Text(
                                  senderName ?? '',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        listProfileColor[profileColor.toInt()],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
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
                                  linkwellFunc(
                                    message,
                                    null,
                                    null,
                                    userdata,
                                  ),
                                  textAlign: TextAlign.start,
                                  toolbarOptions: ToolbarOptions(
                                      selectAll: true, copy: true),
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.black,
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

class ImageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String currentTime;
  final bool displayTime;
  final bool displayWeek;
  final bool lastMessage;
  final String senderName;
  final String senderID;
  final bool displayName;
  final double profileColor;

  ImageTile(
      this.message,
      this.isSendByMe,
      this.currentTime,
      this.displayTime,
      this.displayWeek,
      this.lastMessage,
      this.senderName,
      this.senderID,
      this.displayName,
      this.profileColor);

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);

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
                    // Sender's name
                    displayName
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MultiProvider(
                                      providers: [
                                        Provider<UserData>.value(
                                          value: userdata,
                                        ),
                                        Provider<List<CourseInfo>>.value(
                                          value: currentCourse,
                                        ),
                                      ],
                                      child: FriendProfile(
                                        userID:
                                            senderID, // to be modified to friend's ID
                                      ),
                                    );
                                  }));
                                },
                                child: Text(
                                  senderName ?? ' ',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        listProfileColor[profileColor.toInt()],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
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

class GroupNoticeTile extends StatelessWidget {
  final String message;
  final bool lastMessage;
  final String courseId;

  GroupNoticeTile(this.message, this.lastMessage, this.courseId);

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context, listen: false);
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = _width * 0.05;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return MultiProvider(
                providers: [
                  Provider<UserData>.value(
                    value: userdata,
                  ),
                  Provider<List<CourseInfo>>.value(
                    value: currentCourse,
                  ),
                ],
                child: GroupNotice(
                    courseId: courseId
                ),
              );
            }));
      },
      child: Padding(
        padding: EdgeInsets.only(left: sidebarSize*1.2, right: sidebarSize*1.2, top: sidebarSize),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                width: _width - sidebarSize*1.6,
                padding: EdgeInsets.only(left: sidebarSize*0.8, right: sidebarSize*0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Group Notice',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/arrow_forward.png',
                        height: 17.96,
                        width: 10.26,
                      ),
                      // iconSize: 30.0,
                      color: const Color(0xFFFF7E40),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: _width - sidebarSize*1.6,
                padding: EdgeInsets.only(left: sidebarSize*0.8, right: sidebarSize*0.8, bottom: sidebarSize),
                child: Text(
                  message,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      color: Color(0xff949494),
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(
                height: lastMessage ? 20 : 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}