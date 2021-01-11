import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:provider/provider.dart';
import './groupChat.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchGroupChat extends StatefulWidget {
  final String courseId;
  final String myEmail;
  final String myName;

  SearchGroupChat({this.courseId, this.myEmail, this.myName});

  @override
  _SearchGroupChatState createState() => _SearchGroupChatState();
}

class _SearchGroupChatState extends State<SearchGroupChat> {
  bool isSearching;
  TextEditingController searchTextEditingController = TextEditingController();
  Stream chatMessageStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    databaseMethods.getGroupChatMessages(widget.courseId).then((value) {
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
    return SafeArea(
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
                  height: 73,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 25),
                          height: 50,
                          child: TextField(
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Color(0xffFF813C),
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
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  'assets/images/search.png',
                                  color: Color(0xffFFCDB6),
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              suffixIcon:
                                  searchTextEditingController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: Image.asset(
                                            'assets/images/cross.png',
                                            // color: Color(0xffFF7E40),
                                            height: 19,
                                            width: 19,
                                          ),
                                          onPressed: () {
                                            // initiateSearch();
                                            searchTextEditingController.clear();
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
                        padding: const EdgeInsets.only(left: 25, right: 25.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
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
                  child: SearchList(currentUser),
                ),
              ],
            )),
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
                children.add(Container(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    width: MediaQuery.of(context).size.width - 50,
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
                              color: Color(0xFFffb811),
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ])));
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  if (snapshot.data.documents[i].data()['messageType'] ==
                          'text' &&
                      snapshot.data.documents[i]
                          .data()['message']
                          .contains(searchTextEditingController.text)) {
                    children.add(searchTile(
                      userName: snapshot.data.documents[i].data()['senderName'],
                      message: snapshot.data.documents[i].data()['message'],
                      imageURL:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                      userData: currentUser,
                      searchWord: searchTextEditingController.text,
                      messageIndex: i,
                      messageTime: DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data.documents[i].data()['time'])
                          .toString(),
                    ));
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
      {String userName,
      String message,
      String imageURL,
      userData,
      String searchWord,
      int messageIndex,
      String messageTime}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: userData,
              )
            ],
            child: GroupChat(
              courseId: widget.courseId,
              initialChat: messageIndex.toDouble(),
              myEmail: widget.myEmail,
              myName: widget.myName,
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
                        backgroundColor: Color(0xffFF7E40),
                        radius: 19.5,
                        child: Container(
                          child: Text(
                            userName[0].toUpperCase(),
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 94,
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
                              width: MediaQuery.of(context).size.width - 100,
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

    children.add(TextSpan(
      text: userName + ': ',
      style: GoogleFonts.openSans(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
    ));

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
