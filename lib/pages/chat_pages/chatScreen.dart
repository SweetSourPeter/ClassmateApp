// import 'package:app_test/pages/chat_pages/pictureDisplay.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_cropper/image_cropper.dart';
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
  final double initialChat;
  final String myEmail;

  ChatScreen({this.chatRoomId, this.friendName, this.friendEmail, this.initialChat, this.myEmail});

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
                      snapshot.data.documents[index].data['time']);
                  if (index == snapshot.data.documents.length - 1) {
                    displayTime = true;
                  } else {
                    DateTime prev = DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.documents[index + 1].data['time']);
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

                  return snapshot.data.documents[index].data['messageType'] ==
                          'text'
                      ? MessageTile(
                          snapshot.data.documents[index].data['message'],
                          snapshot.data.documents[index].data['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage
                  )
                      : ImageTile(
                          snapshot.data.documents[index].data['message'],
                          snapshot.data.documents[index].data['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data.documents[index].data['time'])
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
      databaseMethods.setLastestMessage(widget.chatRoomId, messageController.text, lastMessageTime);
      databaseMethods.getUnreadNumber(widget.chatRoomId, widget.friendEmail).then((value) {
        final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
        databaseMethods.setUnreadNumber(widget.chatRoomId, widget.friendEmail, unreadNumber);
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
      databaseMethods.setLastestMessage(widget.chatRoomId, '[image]', lastMessageTime);
      databaseMethods.getUnreadNumber(widget.chatRoomId, widget.friendEmail).then((value) {
        final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
        databaseMethods.setUnreadNumber(widget.chatRoomId, widget.friendEmail, unreadNumber);
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
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
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
          friendCourse.add(element.data['myCourseName']);
        });
      });
    });
    databaseMethods.setUnreadNumber(widget.chatRoomId, widget.myEmail, 0);
    showStickerKeyboard = false;
    showTextKeyboard = false;
    showFunctions = false;
    _controller = ScrollController(initialScrollOffset: widget.initialChat * 40);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffF3F3F3),
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
                              'assets/images/back_arrow.pic',
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFFB811),
                            onPressed: () {
                              databaseMethods.setUnreadNumber(widget.chatRoomId, widget.myEmail, 0);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Container(
                        // height: 30.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                  child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                                    height: 45,
                                    width: 45,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.friendName,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)
                                ),
                                Container(
                                  width: 195,
                                  child: Text(
                                    friendCourse.isNotEmpty ? friendCourse.toString().substring(1, friendCourse.toString().length-1)
                                    : 'No courses yet',
                                    style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Colors.black,
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
                            'assets/images/find.png',
                            height: 23,
                            width: 23
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
                                  myEmail: widget.myEmail,
                                  myName: currentUser.userName,
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
                  alignment: Alignment.center,
                  height: 74.0,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF9F6F1),
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
                                color: Colors.white,
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
                                      Duration(milliseconds: 160), () => _controller.jumpTo(_controller.position.minScrollExtent)
                                  );
                                },
                                controller: messageController,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
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
                        padding: const EdgeInsets.only(left: 25.0),
                        child: GestureDetector(
                            child: Image.asset('assets/images/smile.png',
                                width: 25.36, height: 25.36),
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
                                  Duration(milliseconds: 30), () => _controller.jumpTo(_controller.position.minScrollExtent)
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                                Duration(milliseconds: 30), () => _controller.jumpTo(_controller.position.minScrollExtent)
                            );
                          },
                          child: Image.asset(
                            'assets/images/plus.png',
                            width: 25.36,
                            height: 25.36,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                showStickerKeyboard ? AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 300,
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
                ) : Container(),
                showFunctions ? AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 100,
                  child: Container(
                    color: const Color(0xffF9F6F1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Image.asset('assets/images/camera.png'),
                            onPressed: () => _pickImage(ImageSource.camera, currentUser.email)
                        ),
                        IconButton(
                            icon: Image.asset('assets/images/photo_library.png'),
                            onPressed: () => _pickImage(ImageSource.gallery, currentUser.email)
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
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
        displayWeek ? displayTime ?
        Padding(
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
        ) : Container() : displayTime ?
        Padding(
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
        ) : Container(),
        // Message Box
        isSendByMe ? Container(
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
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                            color: const Color(0xffFFB811)),
                        child: Text(
                            message,
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
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12)
                            ),
                            color: Colors.white
                        ),
                        child: Text(
                            message,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.black,
                            )
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

  ImageTile(this.message, this.isSendByMe, this.currentTime, this.displayTime, this.displayWeek, this.lastMessage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayWeek ? displayTime ?
        Padding(
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
        ) : Container() : displayTime ?
        Padding(
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
        ) : Container(),
        // Message Box
        isSendByMe ? Container(
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
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            imageUrl: message,
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                            height: 180.0,
                          ),
                        )
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: message,
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                              height: 180.0,
                            ),
                          )
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
