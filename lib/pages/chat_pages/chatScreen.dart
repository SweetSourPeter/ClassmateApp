// import 'package:app_test/pages/chat_pages/pictureDisplay.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/chat_pages/previewImage.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linkwell/linkwell.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:app_test/pages/chat_pages/searchChat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
  List<String> friendCourse = List<String>();
  ScrollController _controller;

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
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DateTime current = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.documents[index].data()['time']);
                  if (index == snapshot.data.documents.length - 1) {
                    displayTime = true;
                  } else {
                    DateTime prev = DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.documents[index + 1].data()['time']);
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

                  return snapshot.data.documents[index].data()['messageType'] ==
                          'text'
                      ? MessageTile(
                          snapshot.data.documents[index].data()['message'],
                          snapshot.data.documents[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage)
                      : ImageTile(
                          snapshot.data.documents[index].data()['message'],
                          snapshot.data.documents[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data()['time'])
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

  sendMessage(myEmail) {
    if (messageController.text.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'messageType': 'text',
        'sendBy': myEmail,
        'time': lastMessageTime,
      };

      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      databaseMethods.setLastestMessage(
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
      databaseMethods.setLastestMessage(
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

  Future _pickImage(ImageSource source, myEmail) async {
    PickedFile selected = await _picker.getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });

    if (selected != null) {
      _uploadFile(myEmail);
      print('Image Path $_imageFile');
    }

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
        print('picture uploaded');
        print(_uploadedFileURL);
        sendImage(myEmail);
      });
    });
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
      value.documents.forEach((element) {
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

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;

    return SafeArea(
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
                  height: 73,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/arrow-back.png',
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFFB811),
                            onPressed: () {
                              databaseMethods.setUnreadNumber(
                                  widget.chatRoomId, widget.myEmail, 0);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () {
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
                                      child: FriendProfile(
                                        userID: widget
                                            .friendID, // to be modified to friend's ID
                                      ),
                                    );
                                  }));
                                },
                                child: CircleAvatar(
                                  backgroundColor: listProfileColor[
                                      widget.friendProfileColor.toInt()],
                                  radius: sidebarSize / 20,
                                  child: Container(
                                    child: Text(
                                      widget.friendName.split(' ').length >= 2
                                          ? widget.friendName
                                                  .split(' ')[0][0]
                                                  .toUpperCase() +
                                              widget.friendName
                                                  .split(' ')[widget.friendName
                                                          .split(' ')
                                                          .length -
                                                      1][0]
                                                  .toUpperCase()
                                          : widget.friendName[0].toUpperCase(),
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
                                // createUserImage(sidebarSize / 20, currentUser),
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
                                        ? friendCourse.toString().substring(1,
                                            friendCourse.toString().length - 1)
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                                  )
                                ],
                                child: SearchChat(
                                    chatRoomId: widget.chatRoomId,
                                    friendName: widget.friendName,
                                    friendEmail: widget.friendEmail,
                                    friendProfileColor:
                                        widget.friendProfileColor,
                                    myEmail: widget.myEmail,
                                    myName: currentUser.userName,
                                    myProfileColor: currentUser.profileColor),
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
                  alignment: Alignment.center,
                  height: 74.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffF9F6F1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
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
                              sendMessage(currentUser.email);
                            },
                          ),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 25.0),
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
                            child: showFunctions
                                ? Image.asset('assets/images/plus_on_click.png',
                                    width: 28, height: 28)
                                : Image.asset('assets/images/plus.png',
                                    width: 28, height: 28)),
                      )
                    ],
                  ),
                ),
                showStickerKeyboard
                    ? AnimatedContainer(
                        duration: Duration(milliseconds: 80),
                        height: 301,
                        // showStickerKeyboard ? 400 : 0,
                        child: EmojiPicker(
                          rows: 4,
                          columns: 7,
                          buttonMode: ButtonMode.MATERIAL,
                          numRecommended: 10,
                          onEmojiSelected: (emoji, category) {
                            setState(() {
                              messageController.text =
                                  messageController.text + emoji.emoji;
                            });
                          },
                        ),
                      )
                    : Container(),
                showFunctions
                    ? AnimatedContainer(
                        duration: Duration(milliseconds: 80),
                        height: 80,
                        width: mediaQuery.width,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 64,
                                width: 65,
                                child: IconButton(
                                    icon: Image.asset(
                                      'assets/images/camera.png',
                                    ),
                                    onPressed: () => _pickImage(
                                        ImageSource.camera, currentUser.email)),
                              ),
                              Container(
                                height: 64,
                                width: 65,
                                child: IconButton(
                                    icon: Image.asset(
                                      'assets/images/photo_library.png',
                                    ),
                                    onPressed: () => _pickImage(
                                        ImageSource.gallery,
                                        currentUser.email)),
                              ),
                              Container(
                                height: 64,
                                width: 55,
                                color: Colors.white,
                              ),
                              Container(
                                height: 64,
                                width: 55,
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
                              child: LinkWell(message,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.black,
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
                              child: LinkWell(message,
                                  textAlign: TextAlign.start,
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
