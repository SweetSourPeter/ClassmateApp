import 'package:app_test/pages/chat_pages/pictureDisplay.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/material.dart';
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

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen({this.chatRoomId});

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

  Stream chatMessageStream;

  Widget ChatMessageList(String myName) {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return snapshot.data.documents[index].data['messageType'] == 'text' ?
              MessageTile(snapshot.data.documents[index].data['message'],
                  snapshot.data.documents[index].data['sendBy'] == myName)
              : ImageTile(snapshot.data.documents[index].data['message'],
                snapshot.data.documents[index].data['sendBy'] == myName);
        }) : Container();
      },
    );
  }

  sendMessage(myName) {
    if(messageController.text.isNotEmpty) {
      Map<String,dynamic> messageMap = {
        'message' : messageController.text,
        'messageType' : 'text',
        'sendBy' : myName,
        'time' : DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  sendImage(myName) {
    if(_uploadedFileURL.isNotEmpty) {
      Map<String,dynamic> messageMap = {
        'message' : _uploadedFileURL,
        'messageType' : 'image',
        'sendBy' : myName,
        'time' : DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      _uploadedFileURL = '';
    }
  }

  Future _pickImage(ImageSource source, myName) async {
    PickedFile selected = await _picker.getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });

    if(selected != null) {
      _uploadFile(myName);
      print('Image Path $_imageFile');
    }

//    Navigator.push(context, MaterialPageRoute(
//        builder: (context) => PictureDisplay(imageFile: File(selected.path))
//    ));
  }

  Future _uploadFile(myName) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
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
    databaseMethods.getChatMessages(widget.chatRoomId).then((value){
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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            widget.chatRoomId,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MultiProvider(
                      providers: [
                        Provider<UserData>.value(
                          value: currentUser,
                        )
                      ],
                      child: SearchChat(widget.chatRoomId),
                    );
                  })
                );
              },
            ),
          ],
        ),
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
                  Expanded(
                    child: Container(
                      child: ChatMessageList(currentUser.userName)
                  )),
                  Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      alignment: Alignment.center,
                      color: Color(0x54FFFFFF),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.photo_camera),
    //                          onPressed: () => _pickImage(ImageSource.camera)
                          ),
                          IconButton(
                              icon: Icon(Icons.photo_library),
                              onPressed: () => _pickImage(ImageSource.gallery, currentUser.userName)
                          ),
                          IconButton(
                              icon: Icon(Icons.face),
                              onPressed: () {
                                showTextKeyboard ? setState(() {
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                    showTextKeyboard = false;
                                  }
                                  showStickerKeyboard = !showStickerKeyboard;
                                }) : setState(() {
                                  showStickerKeyboard = !showStickerKeyboard;
                                });
                              }
                          ),
                          SizedBox(width: 16,),
                          Expanded(
                              child: TextField(
                                onTap: () {
                                  setState(() {
                                    showStickerKeyboard = false;
                                    showTextKeyboard = true;
                                  });
                                },
                                controller: messageController,
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                    hintText: "Message ...",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none
                                ),
                              )),
                          SizedBox(width: 16,),
                          GestureDetector(
                            onTap: () {
                              sendMessage(currentUser.userName);
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color(0x36FFFFFF),
                                          const Color(0x0FFFFFFF)
                                        ],
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.bottomRight
                                    ),
                                    borderRadius: BorderRadius.circular(40)
                                ),
                                padding: EdgeInsets.all(12),
                                child: Image.asset("assets/images/send.png",
                                  height: 25, width: 25,)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds:80),
                    height: showStickerKeyboard?293:0,
                    child: EmojiPicker(
                      rows: 4,
                      columns: 7,
                      buttonMode: ButtonMode.MATERIAL,
                      numRecommended: 10,
                      onEmojiSelected: (emoji, category) {
                        setState(() {
                          messageController.text = messageController.text + emoji.emoji;
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

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
        margin: isSendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
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
        margin: isSendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
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

