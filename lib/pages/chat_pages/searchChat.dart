import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchChat extends StatefulWidget {
  final String chatRoomId;
  final String friendName;
  final String friendEmail;
  final String myEmail;

  SearchChat({this.chatRoomId, this.friendName, this.friendEmail, this.myEmail});

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
      });
    });

    isSearching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              color: const Color(0xfff9f6f1),
              height: 73,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(
                            'assets/images/back_arrow.pic',
                        ),
                        // iconSize: 30.0,
                        color: const Color(0xFFFFB811),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextField(
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          color: const Color(0xFFffb811),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        controller: searchTextEditingController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Image.asset(
                            'assets/images/magnifier.pic',
                            height: 18,
                            width: 18,
                          ),
                          hintText: 'Search Chat',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          contentPadding: EdgeInsets.only(left: 0),
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        clearSearchTextInput(currentFocus);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          color: const Color(0xffffb811),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SearchList(currentUser),
            ),
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
              children.add(
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      children: [
                        Text(
                          'Messages with word: ',
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Expanded(
                          child: Text(
                            searchTextEditingController.text,
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Color(0xFFffb811),
                                fontWeight: FontWeight.w600
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ]
                    )
                  ));
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                if(snapshot.data.documents[i].data['messageType'] == 'text' && snapshot.data.documents[i].data['message'].contains(searchTextEditingController.text)) {
                  children.add(
                    searchTile(
                      userName: snapshot.data.documents[i].data['sendBy'],
                      message: snapshot.data.documents[i].data['message'],
                      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                      myName: currentUser,
                      searchWord: searchTextEditingController.text,
                      messageIndex: i
                    )
                  );
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

  Widget searchTile({String userName, String message, String imageURL, myName, String searchWord, int messageIndex}) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25,),
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
                  child: ChatScreen(
                    chatRoomId: widget.chatRoomId,
                    friendName: widget.friendName,
                    friendEmail: widget.friendEmail,
                    initialChat: messageIndex.toDouble(),
                    myEmail: widget.myEmail,
                  ),
                );
              }
          ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: highlightSearchWord(message, searchWord, userName)
                ),
              ),
              Divider(
                height: 16,
                thickness: 1,
              ),
            ],
          )
          // Row(
          //   children: highlightSearchWord(message, searchWord, userName),
          // )
        ),
      ),
    );
  }

  clearSearchTextInput(FocusScopeNode currentFocus) {
    searchTextEditingController.clear();
    isSearching = false;
    currentFocus.unfocus();
  }

  List<TextSpan> highlightSearchWord(String searchResult, String searchWord, String userName) {
    final matches = searchWord.toLowerCase().allMatches(searchResult.toLowerCase());
    int lastMatchEnd = 0;
    final List<TextSpan> children = [];

    children.add(
        TextSpan(
          text: userName + ': ',
          style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
        )
    );

    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);
      if (match.start != lastMatchEnd) {
        children.add(
            TextSpan(
              text: searchResult.substring(lastMatchEnd, match.start),
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.black,
              ),
            )
        );
      }

      children.add(
          TextSpan(
            text: searchResult.substring(match.start, match.end),
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: const Color(0xffffb811),
            ),
          )
      );

      if (i == matches.length - 1 && match.end != searchResult.length) {
        children.add(
            TextSpan(
              text: searchResult.substring(match.end, searchResult.length),
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.black,
              ),
            )
        );
      }
      lastMatchEnd = match.end;
    }
    return children;
  }
}
