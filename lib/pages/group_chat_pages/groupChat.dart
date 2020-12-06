import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:app_test/pages/chat_pages/searchChat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class GroupChat extends StatefulWidget {
  final String chatRoomId;
  final String courseName;

  GroupChat({this.chatRoomId, this.courseName});

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

  Stream chatMessageStream;

  Widget chatMessageList(String myName) {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DateTime current = DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data.documents[index].data['time']);
              if (index == 0) {
                displayTime = true;
              } else {
                DateTime prev = DateTime.fromMillisecondsSinceEpoch(
                    snapshot.data.documents[index - 1].data['time']);
                final difference = current.difference(prev).inDays;
                if (difference >= 1) {
                  displayTime = true;
                } else {
                  displayTime = false;
                }
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
                      myName,
                  DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.documents[index].data['time'])
                      .toString(),
                  displayTime,
                  displayWeek)
                  : ImageTile(
                  snapshot.data.documents[index].data['message'],
                  snapshot.data.documents[index].data['sendBy'] ==
                      myName);
            })
            : Container();
      },
    );
  }

  sendMessage(myName) {
    if (messageController.text.isNotEmpty) {
      final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'messageType': 'text',
        'sendBy': myName,
        'time': lastMessageTime
      };

      databaseMethods.addGroupChatMessages(widget.chatRoomId, messageMap);
      // databaseMethods.setLastestMessage(widget.chatRoomId, messageController.text, lastMessageTime);
      messageController.text = '';
    }
  }

  sendImage(myName) {
    if (_uploadedFileURL.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _uploadedFileURL,
        'messageType': 'image',
        'sendBy': myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      databaseMethods.addGroupChatMessages(widget.chatRoomId, messageMap);
      _uploadedFileURL = '';
    }
  }

  Future _pickImage(ImageSource source, myName) async {
    PickedFile selected = await _picker.getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });

    if (selected != null) {
      _uploadFile(myName);
      print('Image Path $_imageFile');
    }

//    Navigator.push(context, MaterialPageRoute(
//        builder: (context) => PictureDisplay(imageFile: File(selected.path))
//    ));
  }

  Future _uploadFile(myName) async {
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
        sendImage(myName);
      });
    });
  }

  Future _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  void initState() {
    databaseMethods.getGroupChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    showStickerKeyboard = false;
    showTextKeyboard = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xffF3F3F3),
        // appBar: MyAppBar(currentUser, widget.chatRoomId),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            setState(() {
              showStickerKeyboard = false;
              showTextKeyboard = false;
            });
          },
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    color: Colors.white,
                    height: 73,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            icon: Image.asset('assets/images/back_arrow.png'),
                            // iconSize: 30.0,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Container(
                          // height: 30.0,
                          child: Text(
                            // currentUser.email,
                              widget.courseName,
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/find.jpeg'),
                          // iconSize: 30.0,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MultiProvider(
                                    providers: [
                                      Provider<UserData>.value(
                                        value: currentUser,
                                      )
                                    ],
                                    child: SearchChat(widget.chatRoomId),
                                  );
                                }));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                      child: Container(
                          child: chatMessageList(currentUser.userName))),
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
                        //                       IconButton(
                        //                           icon: Icon(Icons.photo_camera),
                        // //                          onPressed: () => _pickImage(ImageSource.camera)
                        //                       ),
                        //                       IconButton(
                        //                           icon: Icon(Icons.photo_library),
                        //                           onPressed: () => _pickImage(ImageSource.gallery, currentUser.userName)
                        //                       ),
                        IconButton(
                            icon: Image.asset('assets/images/smile.png',
                                width: 25.36, height: 25.36),
                            onPressed: () {
                              showTextKeyboard
                                  ? setState(() {
                                FocusScopeNode currentFocus =
                                FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                  showTextKeyboard = false;
                                }
                                showStickerKeyboard =
                                !showStickerKeyboard;
                              })
                                  : setState(() {
                                showStickerKeyboard =
                                !showStickerKeyboard;
                              });
                            }),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
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
                                  });
                                },
                                controller: messageController,
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.only(left: 10.0, bottom: 7.0)),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (value) {
                                  sendMessage(currentUser.userName);
                                },
                              ),
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/plus.png',
                            width: 25.36,
                            height: 25.36,
                          ),
                        )
                        // GestureDetector(
                        //   onTap: () {
                        //     sendMessage(currentUser.userName);
                        //   },
                        //   child: Container(
                        //       height: 40,
                        //       width: 40,
                        //       decoration: BoxDecoration(
                        //           // gradient: LinearGradient(
                        //           //     colors: [
                        //           //       const Color(0x36FFFFFF),
                        //           //       const Color(0x0FFFFFFF)
                        //           //     ],
                        //           //     begin: FractionalOffset.topLeft,
                        //           //     end: FractionalOffset.bottomRight
                        //           // ),
                        //           color: Colors.orange,
                        //           borderRadius: BorderRadius.circular(40)
                        //       ),
                        //       padding: EdgeInsets.all(12),
                        //       child: Image.asset("assets/images/send.png",
                        //         height: 25, width: 25,)),
                        // ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 80),
                    height: showStickerKeyboard ? 293 : 0,
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
                ],
              )
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String currentTime;
  final bool displayTime;
  final bool displayWeek;

  MessageTile(this.message, this.isSendByMe, this.currentTime, this.displayTime,
      this.displayWeek);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayWeek
            ? displayTime
            ? Container(
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
              fontSize: 10,
              color: const Color(0xff949494),
            ),
          ),
        )
            : Container()
            : displayTime
            ? Container(
          alignment: Alignment.center,
          child: Text(
            currentTime.substring(0, currentTime.length - 13),
            style: GoogleFonts.openSans(
              fontSize: 10,
              color: const Color(0xff949494),
            ),
          ),
        )
            : Container(),
        Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isSendByMe ? 0 : 24,
              right: isSendByMe ? 24 : 0),
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSendByMe ? Text(
                  currentTime.substring(11, currentTime.length - 7),
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: const Color(0xff949494),
                  ),
                ) : Container(),
                Container(
                  margin: isSendByMe ? EdgeInsets.only(left: 10)
                      : EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: isSendByMe
                          ? BorderRadius.only(
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12))
                          : BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      // gradient: LinearGradient(
                      //   colors: isSendByMe ? [
                      //     const Color(0xff007EF4),
                      //     const Color(0xff2A75BC)
                      //   ]
                      //       : [
                      //     const Color(0x1AFFFFFF),
                      //     const Color(0x1AFFFFFF)
                      //   ],
                      // )
                      color: isSendByMe ? const Color(0xffFFB811) : Colors.white),
                  child: Text(message,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                ),
                isSendByMe ? Container()
                    : Text(
                  currentTime.substring(11, currentTime.length - 7),
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: const Color(0xff949494),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  ImageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
        isSendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            // gradient: LinearGradient(
            //   colors: isSendByMe ? [
            //     const Color(0xff007EF4),
            //     const Color(0xff2A75BC)
            //   ]
            //       : [
            //     const Color(0x1AFFFFFF),
            //     const Color(0x1AFFFFFF)
            //   ],
            // )
            color: isSendByMe ? const Color(0xffFFB811) : Colors.white),
        child: CachedNetworkImage(
          imageUrl: message,
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          height: 150.0,
          width: 150.0,
        ),
      ),
    );
  }
}