import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:provider/provider.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:app_test/models/courseInfo.dart';

class SearchChat extends StatefulWidget {
  final String chatRoomId;
  final String friendName;
  final String friendEmail;
  final double friendProfileColor;
  final String myEmail;
  final String myName;
  final double myProfileColor;

  SearchChat(
      {this.chatRoomId,
      this.friendName,
      this.friendEmail,
      this.friendProfileColor,
      this.myEmail,
      this.myName,
      this.myProfileColor});

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
    super.initState();
    databaseMethods.getChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    final _height = MediaQuery.of(context).size.height;
    final _width = maxWidth;

    return Container(
      color: Colors.white,
      child: Center(
        child: SafeArea(
          child: SizedBox(
            width: maxWidth,
            child: Scaffold(
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
                      Container(
                        color: const Color(0xffFF712D),
                        height: _height * 0.10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8, right: 8),
                            //   child: Container(
                            //     height: 40,
                            //     width: 40,
                            //     child: IconButton(
                            //       icon: Image.asset(
                            //         'assets/images/arrow-back.png',
                            //       ),
                            //       // iconSize: 30.0,
                            //       color:,
                            //       onPressed: () => Navigator.of(context).pop(),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 25),
                                height: 50,
                                child: TextField(
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: const Color(0xFFFF813C),
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
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Color(0xFFFFCDB6),
                                    ),
                                    suffixIcon:
                                        searchTextEditingController.text.isEmpty
                                            ? null
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xffFF7E40),
                                                  // size: 30,
                                                ),
                                                onPressed: () {
                                                  // initiateSearch();
                                                  searchTextEditingController
                                                      .clear();
                                                }),
                                    hintText: 'Search Chat',
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
                                    contentPadding: EdgeInsets.only(left: 0),
                                    hintStyle: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: Color(0xffFF813C),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        child: searchList(currentUser, context),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget searchList(currentUser, context) {
    print(isSearching);
    return isSearching && searchTextEditingController.text.isNotEmpty
        ? StreamBuilder(
            stream: chatMessageStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final children = <Widget>[];
                children.add(Container(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Row(children: [
                      Text(
                        'Messages with word: ',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          searchTextEditingController.text,
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Color(0xFFFF7E40),
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ])));
                for (var i = 0; i < snapshot.data.docs.length; i++) {
                  if (snapshot.data.docs[i].get('messageType') == 'text' &&
                      snapshot.data.docs[i]
                          .get('message')
                          .contains(searchTextEditingController.text)) {
                    children.add(searchTile(
                        userEmail: snapshot.data.docs[i].get('sendBy'),
                        message: snapshot.data.docs[i].get('message'),
                        imageURL:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                        userData: currentUser,
                        searchWord: searchTextEditingController.text,
                        messageIndex: i,
                        messageTime: DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.docs[i].data()['time'])
                            .toString(),
                        friendProfileColor: widget.friendProfileColor,
                        context: context));
                  }
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: children.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return children[index];
                    });
              }
              return Container();
            })
        : Container();
  }

  Widget searchTile(
      {String userEmail,
      String message,
      String imageURL,
      userData,
      String searchWord,
      int messageIndex,
      String messageTime,
      double friendProfileColor,
      BuildContext context}) {
    String userName = '';
    double profileColor = 0.0;
    if (userEmail == widget.friendEmail) {
      userName = widget.friendName;
      profileColor = widget.friendProfileColor;
    } else {
      userName = widget.myName;
      profileColor = widget.myProfileColor;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: userData,
              ),
            ],
            child: ChatScreen(
              chatRoomId: widget.chatRoomId,
              friendName: widget.friendName,
              friendEmail: widget.friendEmail,
              initialChat: messageIndex.toDouble(),
              friendProfileColor: friendProfileColor,
              myEmail: widget.myEmail,
            ),
          );
        }));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 25,
            right: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: listProfileColor[profileColor.toInt()],
                        radius: 19.5,
                        child: Container(
                          child: Text(
                            userName.split(' ').length >= 2
                                ? userName.split(' ')[0][0].toUpperCase() +
                                    userName
                                        .split(' ')[
                                            userName.split(' ').length - 1][0]
                                        .toUpperCase()
                                : userName[0].toUpperCase(),
                            style: GoogleFonts.montserrat(
                                fontSize:
                                    userName.split(' ').length >= 2 ? 14 : 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: maxWidth - 94,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    (userName != null ? userName : '') + ': ',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                    messageTime.substring(5, 7) +
                                        '/' +
                                        messageTime.substring(8, 10) +
                                        '/' +
                                        messageTime.substring(0, 4),
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Color(0xff949494),
                                    )),
                              ],
                            ),
                            Container(
                              width: maxWidth - 100,
                              padding: EdgeInsets.only(left: 8),
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: highlightSearchWord(
                                        message, searchWord, userName)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
    );
  }

  clearSearchTextInput(FocusScopeNode currentFocus) {
    searchTextEditingController.clear();
    isSearching = false;
    currentFocus.unfocus();
  }

  List<TextSpan> highlightSearchWord(
      String searchResult, String searchWord, String userName) {
    final matches =
        searchWord.toLowerCase().allMatches(searchResult.toLowerCase());
    int lastMatchEnd = 0;
    final List<TextSpan> children = [];

    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);
      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: searchResult.substring(lastMatchEnd, match.start),
          style: GoogleFonts.openSans(
            fontSize: 16,
            color: Colors.black,
          ),
        ));
      }

      children.add(TextSpan(
        text: searchResult.substring(match.start, match.end),
        style: GoogleFonts.openSans(
          fontSize: 16,
          color: const Color(0xffFF7E40),
        ),
      ));

      if (i == matches.length - 1 && match.end != searchResult.length) {
        children.add(TextSpan(
          text: searchResult.substring(match.end, searchResult.length),
          style: GoogleFonts.openSans(
            fontSize: 16,
            color: Colors.black,
          ),
        ));
      }
      lastMatchEnd = match.end;
    }
    return children;
  }
}
