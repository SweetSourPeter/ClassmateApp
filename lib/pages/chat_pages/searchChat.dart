import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';

class SearchChat extends StatefulWidget {
  final String chatRoomId;
  SearchChat(this.chatRoomId);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  bool isSearching;
  TextEditingController searchTextEditingController = TextEditingController();
  Stream chatMessageStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    databaseMethods.getChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
        print('init');
        chatMessageStream.first.then((value) => print(value));
      });
    });
    setState(() {
      isSearching = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            if (isSearching) {
              setState(() {
                isSearching = !isSearching;
              });
            }
          }
        },
        child: ListView(
          children: <Widget>[
            inputTextBody(),
            isSearching ? SearchList(currentUser) : relateSearchBody(),
          ],
        )
      ),
    );
  }

  Widget SearchList(currentUser) {
    return isSearching && searchTextEditingController.text.isNotEmpty
        ? StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final children = <Widget>[];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                if(snapshot.data.documents[i].data['messageType'] == 'text' && snapshot.data.documents[i].data['message'].contains(searchTextEditingController.text)) {
                  children.add(SearchTile(
                    userName: snapshot.data.documents[i].data['sendBy'],
                    message: snapshot.data.documents[i].data['message'],
                    imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                    myName: currentUser));
                }
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: children.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return children[index];
                }
              );
            }
            return Container();
          }) : Container();
  }

  Widget SearchTile({String userName, String message, String imageURL, myName}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return MultiProvider(
                  providers: [
                    Provider<UserData>.value(
                      value: myName,
                    )
                  ],
                  // child: ChatScreen(chatRoomId: chatRoomId,),
                );
              }
          ));
        },
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
                    message ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputTextBody() {
    return Container(
          color: builtyPinkColor,
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          initiateSearch();
                        },
                        controller: searchTextEditingController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Search chat with keywords',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 15.0),
                          hintStyle: TextStyle(color: Colors.grey), // KEY PROP
                        ),
                      ),
                    ),
                    searchTextEditingController.text.isEmpty
                      ? Container(width: 10,)
                      : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        clearSearchTextInput(currentFocus);
                      })
                  ],
                ),
              ),
            ],
      ),
    );
  }

  Widget relateSearchBody() {
    return Container(
        color: builtyPinkColor,
        height: 620.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text('Search This Chat', style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    child: Text('Group Members', textAlign: TextAlign.center),
                  ),
                  Container(
                    width: 60.0,
                    child: Text('Date', textAlign: TextAlign.center),
                  ),
                  Container(
                    width: 60.0,
                    child: Text('Media', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    child: Text('Files', textAlign: TextAlign.center),
                  ),
                  Container(
                    width: 60.0,
                    child: Text('Links', textAlign: TextAlign.center),
                  ),
                  Container(
                    width: 60.0,
                    child: Text('Music', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  clearSearchTextInput(FocusScopeNode currentFocus) {
    searchTextEditingController.clear();
    isSearching = false;
    currentFocus.unfocus();
  }

  void initiateSearch() {}
}
