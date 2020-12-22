import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/user.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  // bool showCancel = false;

  bool haveUserSearched = false;
  // FocusNode _focus = new FocusNode();
  QuerySnapshot searchSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();


  // @override
  // void initState() {
  //   super.initState();
  //   _focus.addListener(_onFocusChange);
  // }

  @override
  void initState() {
    // TODO: implement initState
    initiateSearch();
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

    return GestureDetector(
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
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0, // no shaddow
            leading: Container(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Invite',
                  style: TextStyle(
                    color: lightOrangeColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.white,
            // title: Text("Find User"),
          ),
          body: buildContainerBody(currentFocus)),
    );
  }

  Container buildContainerBody(FocusScopeNode currentFocus) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 5),
                child: Container(
                  // color: orengeColor,
                  child: Text(
                    'Search User',
                    textAlign: TextAlign.left,
                    // style: largeTitleTextStyle(),
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Focus(
                        // onFocusChange: (focus) => showCanclChange(),
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            initiateSearch();
                          },
                          // focusNode: _focus,
                          controller: searchTextEditingController,
                          textAlign: TextAlign.left,
                          autofocus: true,
                          decoration: buildInputDecorationPinky(
                            true,
                            Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            'Search email...',
                            20,
                          ),
                        ),
                      )),
                  // showCancel
                  searchTextEditingController.text.isEmpty
                      ? Container()
                      :
                  // Container(
                  // height: 40,
                  // width: 40,
                  // padding: EdgeInsets.only(left: kDefaultPadding),
                  // child:
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        // initiateSearch();
                        clearSearchTextInput(currentFocus);
                      })
                  // )
                  // : Container(),
                ],
              ),
            ),
            searchList(),
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
      if (searchSnapshot.documents != null) {
        if ((searchSnapshot.documents.length >= 1) &&
            (searchTextEditingController.text.isNotEmpty)) {
          searchBegain = true;
        }
      }

      print('aaaa');
      print(searchSnapshot.toString() + 'aaaaaaaaaaa');
      print(searchSnapshot.documents.length);
      // print(searchTextEditingController.text);
    });
  }

  // a function to create chat room
  createChatRoomAndStartConversation(String userName, String userEmail){
    final currentUser = Provider.of<UserData>(context, listen: false);
    final myName = currentUser.userName;
    final myEmail = currentUser.email;
    if(userEmail != myEmail) {
      String chatRoomId = getChatRoomId(userName, myName);

      List<String> users = [userName, userEmail, myName, myEmail];
      print('users map is:   ');
      print(users);
      Map<String, dynamic> chatRoomMap = {
        'users' : users,
        'chatRoomId' : chatRoomId,
        'latestMessage' : '',
        'lastMessageTime' : ''
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return MultiProvider(
              providers: [
                Provider<UserData>.value(
                  value: currentUser,
                )
              ],
              child: ChatScreen(
                chatRoomId: chatRoomId,
                friendEmail: userEmail,
                friendName: userName,
              ),
            );
          }
      ));
    } else {
      print('This is your account!');
    }
  }

  // a helper function for createChatRoomAndStartConversation()
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  // searchTile for searchList
  Widget searchTile({String userName, String userEmail, String imageURL}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage("${imageURL}"),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            // color: Colors.black12,
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  userEmail ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: 10,
          // ),
          Expanded(
            child: RaisedGradientButton(
              width: 100,
              height: 40,
              gradient: LinearGradient(
                colors: <Color>[Colors.red, orengeColor],
              ),
              onPressed: () {
                //TODO
                createChatRoomAndStartConversation(userName, userEmail);
              },
              //之后需要根据friendsProvider改这部分display
              //TODO
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget searchList() {
    return searchBegain && searchTextEditingController.text.isNotEmpty
        ? ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true, //when you have listview in column
        itemBuilder: (context, index) {
          return searchTile(
            userName:
            // "peter",
            searchSnapshot.documents[index].data['userName'],
            userEmail:
            // "731957665@qq.com",
            searchSnapshot.documents[index].data['email'],
            imageURL:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
          );
        })
        : Container(
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