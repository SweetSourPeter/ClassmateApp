import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/chat_pages/pictureDisplay.dart';
import 'package:app_test/pages/chat_pages/previewImage.dart';
import 'package:app_test/pages/contact_pages/searchCourse.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/pages/group_chat_pages/courseDetail.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'package:linkwell/linkwell.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:app_test/widgets/widgets.dart';

import 'package:image_picker_web/image_picker_web.dart';

import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'dart:html' as html;

class GroupChat extends StatefulWidget {
  final String courseId;
  final double initialChat;
  final String myEmail;
  final String myName;
  final bool isRedirect;

  GroupChat({
    this.courseId,
    this.initialChat,
    this.myEmail,
    this.myName,
    this.isRedirect,
  });

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  html.File _imageFile;
  html.File _file;
  String _uploadedFileURL;
  String _link;
  String messageUrl;
  String fileName;
  // final _picker = ImagePicker();
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
  bool haveCourse = false;

  Stream chatMessageStream;
  Future friendCoursesFuture;

  Widget chatMessageList(String myEmail) {
    print("myEmail");
    print(myEmail);
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        // if (widget.isRedirect) {
        if (true) {
          final userdata = Provider.of<UserData>(context);
          final course = Provider.of<List<CourseInfo>>(context);
          print("course");
          print(course.first.courseID);
          print("courseID");
          print(widget.courseId);

          // haveCourse = false;

          course.forEach((element) {
            if (element.courseID.toString() == widget.courseId.toString()) {
              haveCourse = true;
              print("haveCourse should be true");
            }
          });

          if (haveCourse == true) {
            return (widget.myEmail != null && snapshot.hasData)
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

                      if (snapshot.data.documents[index]
                              .data()['messageType'] ==
                          'text') {
                        return MessageTile(
                          snapshot.data.documents[index].data()['message'],
                          snapshot.data.documents[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage,
                          snapshot.data.documents[index].data()['senderName'],
                          snapshot.data.documents[index].data()['senderID'],
                          snapshot.data.documents[index]
                                  .data()['profileColor'] ??
                              1.0,
                        );
                      } else if (snapshot.data.documents[index]
                              .data()['messageType'] ==
                          'image') {
                        return ImageTile(
                          snapshot.data.documents[index].data()['message'],
                          snapshot.data.documents[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage,
                          snapshot.data.documents[index].data()['senderName'],
                          snapshot.data.documents[index].data()['senderID'],
                          snapshot.data.documents[index]
                                  .data()['profileColor'] ??
                              1.0,
                        );
                      } else {
                        return FileTile(
                          snapshot.data.documents[index].data()['message'],
                          snapshot.data.documents[index].data()['sendBy'] ==
                              myEmail,
                          DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.documents[index].data()['time'])
                              .toString(),
                          displayTime,
                          displayWeek,
                          lastMessage,
                          snapshot.data.documents[index].data()['senderName'],
                          snapshot.data.documents[index].data()['senderID'],
                          snapshot.data.documents[index]
                                  .data()['profileColor'] ??
                              1.0,
                          _link =
                              snapshot.data.documents[index].data()['message'],
                          fileName =
                              snapshot.data.documents[index].data()['fileName'],
                        );
                      }

                      // return snapshot.data.documents[index].data()['messageType'] ==
                      //         'text'
                      //     ? MessageTile(
                      //         snapshot.data.documents[index].data()['message'],
                      //         snapshot.data.documents[index].data()['sendBy'] ==
                      //             myEmail,
                      //         DateTime.fromMillisecondsSinceEpoch(
                      //                 snapshot.data.documents[index].data()['time'])
                      //             .toString(),
                      //         displayTime,
                      //         displayWeek,
                      //         lastMessage,
                      //         snapshot.data.documents[index].data()['senderName'],
                      //         snapshot.data.documents[index].data()['senderID'],
                      //         snapshot.data.documents[index]
                      //                 .data()['profileColor'] ??
                      //             1.0,
                      //       )
                      //     : ImageTile(
                      //         snapshot.data.documents[index].data()['message'],
                      //         snapshot.data.documents[index].data()['sendBy'] ==
                      //             myEmail,
                      //         DateTime.fromMillisecondsSinceEpoch(
                      //                 snapshot.data.documents[index].data()['time'])
                      //             .toString(),
                      //         displayTime,
                      //         displayWeek,
                      //         lastMessage,
                      //         snapshot.data.documents[index].data()['senderName'],
                      //         snapshot.data.documents[index].data()['senderID'],
                      //         snapshot.data.documents[index]
                      //                 .data()['profileColor'] ??
                      //             1.0,
                      //       );
                    })
                : Container();
          } else {
            return AlertDialog(
              title: Text("Alert"),
              content: Text("Not enrolled in this course yet!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Wrapper(false, false, "0", false);
                      },
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiProvider(
                            providers: [
                              Provider<UserData>.value(
                                value: userdata,
                              ),
                              Provider<List<CourseInfo>>.value(value: course)
                            ],
                            child: SearchCourse(),
                          );
                        },
                      ),
                    )
                  },
                  child: const Text('Enroll'),
                )
              ],
            );
          }
        } else {
          return (widget.myEmail != null && snapshot.hasData)
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

                    if (snapshot.data.documents[index].data()['messageType'] ==
                        'text') {
                      return MessageTile(
                        snapshot.data.documents[index].data()['message'],
                        snapshot.data.documents[index].data()['sendBy'] ==
                            myEmail,
                        DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.documents[index].data()['time'])
                            .toString(),
                        displayTime,
                        displayWeek,
                        lastMessage,
                        snapshot.data.documents[index].data()['senderName'],
                        snapshot.data.documents[index].data()['senderID'],
                        snapshot.data.documents[index].data()['profileColor'] ??
                            1.0,
                      );
                    } else if (snapshot.data.documents[index]
                            .data()['messageType'] ==
                        'image') {
                      return ImageTile(
                        snapshot.data.documents[index].data()['message'],
                        snapshot.data.documents[index].data()['sendBy'] ==
                            myEmail,
                        DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.documents[index].data()['time'])
                            .toString(),
                        displayTime,
                        displayWeek,
                        lastMessage,
                        snapshot.data.documents[index].data()['senderName'],
                        snapshot.data.documents[index].data()['senderID'],
                        snapshot.data.documents[index].data()['profileColor'] ??
                            1.0,
                      );
                    } else {
                      return FileTile(
                        snapshot.data.documents[index].data()['message'],
                        snapshot.data.documents[index].data()['sendBy'] ==
                            myEmail,
                        DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.documents[index].data()['time'])
                            .toString(),
                        displayTime,
                        displayWeek,
                        lastMessage,
                        snapshot.data.documents[index].data()['senderName'],
                        snapshot.data.documents[index].data()['senderID'],
                        snapshot.data.documents[index].data()['profileColor'] ??
                            1.0,
                        _link =
                            snapshot.data.documents[index].data()['message'],
                        fileName =
                            snapshot.data.documents[index].data()['fileName'],
                      );
                    }

                    // return snapshot.data.documents[index].data()['messageType'] ==
                    //         'text'
                    //     ? MessageTile(
                    //         snapshot.data.documents[index].data()['message'],
                    //         snapshot.data.documents[index].data()['sendBy'] ==
                    //             myEmail,
                    //         DateTime.fromMillisecondsSinceEpoch(
                    //                 snapshot.data.documents[index].data()['time'])
                    //             .toString(),
                    //         displayTime,
                    //         displayWeek,
                    //         lastMessage,
                    //         snapshot.data.documents[index].data()['senderName'],
                    //         snapshot.data.documents[index].data()['senderID'],
                    //         snapshot.data.documents[index]
                    //                 .data()['profileColor'] ??
                    //             1.0,
                    //       )
                    //     : ImageTile(
                    //         snapshot.data.documents[index].data()['message'],
                    //         snapshot.data.documents[index].data()['sendBy'] ==
                    //             myEmail,
                    //         DateTime.fromMillisecondsSinceEpoch(
                    //                 snapshot.data.documents[index].data()['time'])
                    //             .toString(),
                    //         displayTime,
                    //         displayWeek,
                    //         lastMessage,
                    //         snapshot.data.documents[index].data()['senderName'],
                    //         snapshot.data.documents[index].data()['senderID'],
                    //         snapshot.data.documents[index]
                    //                 .data()['profileColor'] ??
                    //             1.0,
                    //       );
                  })
              : Container();
        }
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

  @override
  void initState() {
    databaseMethods.getGroupChatMessages(widget.courseId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
    databaseMethods.getCourseInfo(widget.courseId).then((value) {
      setState(() {
        courseName = value.documents[0].data()['myCourseName'];
        courseSection = value.documents[0].data()['section'];
        courseTerm = value.documents[0].data()['term'];
      });
    });

    databaseMethods.getNumberOfMembersInCourse(widget.courseId).then((value) {
      setState(() {
        numberOfMembers = value.documents.length;
      });
    });

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
    final currentCourse = Provider.of<List<CourseInfo>>(context, listen: false);

    sendMessage(myEmail, myName) {
      if (messageController.text.isNotEmpty) {
        final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> messageMap = {
          'message': messageController.text,
          'messageType': 'text',
          'sendBy': myEmail,
          'senderName': myName,
          'time': lastMessageTime,
          'senderID': currentUser.userID,
          'profileColor': currentUser.profileColor
        };

        databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
        databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
            widget.courseId, currentUser.userID);
        // databaseMethods.setLastestMessage(widget.courseId, messageController.text, lastMessageTime);
        // databaseMethods.getUnreadNumber(widget.courseId, widget.friendEmail).then((value) {
        //   final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
        //   databaseMethods.setUnreadNumber(widget.courseId, widget.friendEmail, unreadNumber);
        // });

        _controller.jumpTo(_controller.position.minScrollExtent);
        messageController.text = '';
      }
    }

    sendImage(myEmail, myName) {
      if (_uploadedFileURL.isNotEmpty) {
        final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> messageMap = {
          'message': _uploadedFileURL,
          'messageType': 'image',
          'sendBy': myEmail,
          'senderName': myName,
          'time': lastMessageTime,
          'senderID': currentUser.userID,
        };

        databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
        databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
            widget.courseId, currentUser.userID);
        // databaseMethods.setLastestMessage(widget.courseId, '[image]', lastMessageTime);
        // databaseMethods.getUnreadNumber(widget.courseId, widget.friendEmail).then((value) {
        //   final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
        //   databaseMethods.setUnreadNumber(widget.courseId, widget.friendEmail, unreadNumber);
        // });

        _controller.jumpTo(_controller.position.minScrollExtent);
        _uploadedFileURL = '';
      }
    }

    sendFile(myEmail, myName) {
      if (_link.isNotEmpty) {
        final lastMessageTime = DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> messageMap = {
          'message': _link,
          'fileName': fileName,
          'messageUrl': _link,
          'messageType': 'file',
          'sendBy': myEmail,
          'senderName': myName,
          'time': lastMessageTime,
          'senderID': currentUser.userID,
        };

        databaseMethods.addGroupChatMessages(widget.courseId, messageMap);
        databaseMethods.addOneToUnreadGroupChatNumberForOtherMembers(
            widget.courseId, currentUser.userID);
        // databaseMethods.setLastestMessage(widget.courseId, '[image]', lastMessageTime);
        // databaseMethods.getUnreadNumber(widget.courseId, widget.friendEmail).then((value) {
        //   final unreadNumber = value.data[widget.friendEmail.substring(0, widget.friendEmail.indexOf('@')) + 'unread'] + 1;
        //   databaseMethods.setUnreadNumber(widget.courseId, widget.friendEmail, unreadNumber);
        // });

        _controller.jumpTo(_controller.position.minScrollExtent);
        _link = '';
        fileName = '';
      }
    }

    Future<void> _uploadFile(myEmail, myName, html.File image,
        {String imageName}) async {
      imageName = image.name;
      fb.StorageReference storageRef = fb.storage().ref('images/$imageName');

      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageRef.put(image).future;

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      print(imageUri);

      _uploadedFileURL = imageUri.toString();

      sendImage(myEmail, myName);
      //return imageUri;
    }

    Future<void> _uploadNonImage(myEmail, myName, html.File f,
        {String fName}) async {
      fName = f.name;
      fb.StorageReference storageRef = fb.storage().ref('images/$fName');

      fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(f).future;

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      print(imageUri);

      //_uploadedFileURL = imageUri.toString();
      _link = imageUri.toString();
      messageUrl = _link;
      fileName = f.name;

      sendFile(myEmail, myName);
      //return imageUri;
    }

    Future _pickImage(ImageSource source, myEmail, myName) async {
      html.File selected =
          await ImagePickerWeb.getImage(outputType: ImageType.file);

      if (selected != null) {
        debugPrint(selected.toString());
      }

      setState(() {
        _imageFile = selected;
      });

      if (selected != null) {
        _uploadFile(myEmail, myName, _imageFile);
      }
    }

    Future _pickFile(myEmail, myName) async {
      // html.File selected = await ImagePickerWeb.getImage(outputType: ImageType.file);
      html.File selected = await FilePicker.platform.pickFiles() ?? [];

      if (selected != null) {
        debugPrint(selected.toString());
      }

      setState(() {
        _file = selected;
      });

      if (selected != null) {
        _uploadNonImage(myEmail, myName, _file);
      }
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffF9F6F1),
      body: Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
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
                height: 73.68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        // height: 17.96,
                        // width: 10.26,
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/arrow-back.png',
                            height: 17.96,
                            width: 10.26,
                          ),
                          // iconSize: 30.0,
                          color: const Color(0xFFFF7E40),
                          onPressed: () {
                            // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                            databaseMethods.setUnreadGroupChatNumberToZero(
                                widget.courseId, currentUser.userID);
                            if (widget.isRedirect == false) {
                              Navigator.of(context).pop();
                            } else {
                              // Navigator.pushNamed(context,'/');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Wrapper(false, false, "0", false);
                              }));
                            }
                            // Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Container(
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
                                  ? numberOfMembers.toString() + ' ' + 'people'
                                  : numberOfMembers.toString() + ' ' + 'person',
                              style: GoogleFonts.openSans(
                                color: Color(0xff949494),
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
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
                                ),
                              );
                            }));
                          },
                        ),
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
                            sendMessage(
                                currentUser.email, currentUser.userName);
                          },
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: GestureDetector(
                          child: showStickerKeyboard
                              ? Image.asset('assets/images/messageSend.png',
                                  width: 28, height: 28)
                              // : showFunctions
                              // ? Image.asset(
                              // 'assets/images/plus_on_click.png',
                              // width: 28,
                              // height: 28)
                              : Image.asset('assets/images/plus_on_click.png',
                                  width: 28, height: 28),
                          // ? Image.asset('assets/images/emoji_on_click.png',
                          //     width: 29, height: 27.83)
                          // : Image.asset('assets/images/emoji.png',
                          //     width: 29, height: 27.83),
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
                              // if (showFunctions) {
                              //   setState(() {
                              //     showFunctions = false;
                              //   });
                              // } else {}
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
                      // child: GestureDetector(
                      //     onTap: () {
                      //       if ((messageController.text != '' ||
                      //           messageController.text.isNotEmpty)) {
                      //         sendMessage(
                      //             currentUser.email, currentUser.userName);
                      //       } else {
                      //         if (showTextKeyboard) {
                      //           setState(() {
                      //             FocusScopeNode currentFocus =
                      //                 FocusScope.of(context);
                      //             if (!currentFocus.hasPrimaryFocus) {
                      //               currentFocus.unfocus();
                      //               showTextKeyboard = false;
                      //             }
                      //           });
                      //         } else {
                      //           if (showStickerKeyboard) {
                      //             setState(() {
                      //               showStickerKeyboard = false;
                      //             });
                      //           } else {}
                      //         }
                      //         setState(() {
                      //           showFunctions = !showFunctions;
                      //         });
                      //         Timer(
                      //             Duration(milliseconds: 30),
                      //             () => _controller.jumpTo(
                      //                 _controller.position.minScrollExtent));
                      //       }
                      //     },
                      //     child: (messageController.text != '' ||
                      //             messageController.text.isNotEmpty)
                      //         ? Image.asset('assets/images/messageSend.png',
                      //             width: 28, height: 28)
                      //         : showFunctions
                      //             ? Image.asset(
                      //                 'assets/images/plus_on_click.png',
                      //                 width: 28,
                      //                 height: 28)
                      //             : Image.asset(
                      //                 'assets/images/plus_on_click.png',
                      //                 width: 28,
                      //                 height: 28)),
                    )
                  ],
                ),
              ),
              showStickerKeyboard
                  //     ? AnimatedContainer(
                  //         duration: Duration(milliseconds: 80),
                  //         // showStickerKeyboard ? 400 : 0,
                  //         child: EmojiPicker(
                  //           rows: 4,
                  //           columns: 7,
                  //           buttonMode: ButtonMode.MATERIAL,
                  //           numRecommended: 10,
                  //           onEmojiSelected: (emoji, category) {
                  //             setState(() {
                  //               messageController.text =
                  //                   messageController.text + emoji.emoji;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     : Container(),
                  // showFunctions
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
                              height: 64,
                              width: 65,
                              child: IconButton(
                                  icon: Image.asset('assets/images/camera.png'),
                                  onPressed: () => _pickImage(
                                      ImageSource.camera,
                                      currentUser.email,
                                      currentUser.userName)),
                            ),
                            Container(
                              height: 64,
                              width: 65,
                              child: IconButton(
                                  icon: Image.asset(
                                      'assets/images/photo_library.png'),
                                  onPressed: () => _pickFile(
                                      //ImageSource.gallery,
                                      currentUser.email,
                                      currentUser.userName)),
                            ),
                            // Container(
                            //   height: 64,
                            //   width: 55,
                            //   color: Colors.white,
                            // ),
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
        ),
      )),
    ));
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
                      width:
                          getRealWidth(MediaQuery.of(context).size.width) - 60,
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
                              child: SelectableText(message,
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
                    // Sender's name
                    Container(
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
                              color: listProfileColor[profileColor.toInt()],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                              child: SelectableText(message,
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
  final String senderName;
  final String senderID;
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

                    Container(
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
                              color: listProfileColor[profileColor.toInt()],
                            ),
                          ),
                        ),
                      ),
                    ),
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

class FileTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String currentTime;
  final bool displayTime;
  final bool displayWeek;
  final bool lastMessage;
  final String senderName;
  final String senderID;
  final double profileColor;
  final String messageUrl;
  final String fileName;

  FileTile(
      this.message,
      this.isSendByMe,
      this.currentTime,
      this.displayTime,
      this.displayWeek,
      this.lastMessage,
      this.senderName,
      this.senderID,
      this.profileColor,
      this.messageUrl,
      this.fileName);

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
                                html.window.open(messageUrl, 'PlaceholderName');
                                //downloadFile(messageUrl);
                              },
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => PreviewImage(
                              //         imageUrl: message,
                              //       ),
                              //     ),
                              //   );
                              // },
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: <Widget>[
                                            Container(
                                              width: 130,
                                              height: 80,
                                              color: const Color(0xff00838f),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.insert_drive_file,
                                                  color:
                                                      const Color(0xfff9fbe7),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text('file: ' + fileName,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: const Color(
                                                          0xfff9fbe7),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                            width: 130,
                                            height: 40,
                                            color: const Color(0xff26c6da),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.file_download,
                                                color: const Color(0xfff9fbe7),
                                              ),
                                              //onPressed: () => downloadFile(message.fileUrl)
                                            ))
                                      ],
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

                    Container(
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
                              color: listProfileColor[profileColor.toInt()],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                                html.window.open(messageUrl, 'PlaceholderName');
                                //downloadFile(messageUrl);
                              },
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => PreviewImage(
                              //         imageUrl: message,
                              //       ),
                              //     ),
                              //   );
                              // },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: <Widget>[
                                            Container(
                                              width: 130,
                                              height: 80,
                                              color: const Color(0xff00838f),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.insert_drive_file,
                                                  color:
                                                      const Color(0xfff9fbe7),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text('file: ' + fileName,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: const Color(
                                                          0xfff9fbe7),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                            width: 130,
                                            height: 40,
                                            color: const Color(0xff26c6da),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.file_download,
                                                color: const Color(0xfff9fbe7),
                                              ),
                                              //onPressed: () => downloadFile(message.fileUrl)
                                            ))
                                      ],
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
