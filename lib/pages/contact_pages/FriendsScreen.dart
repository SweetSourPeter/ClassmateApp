import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';
import 'package:app_test/widgets/category_selector.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/recent_chats.dart';
import 'package:app_test/pages/chat_pages/chatScreen_v1.dart';
import 'package:app_test/models/message_model.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Scaffold(
          backgroundColor: builtyPinkColor,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // CategorySelector(),
              FavoriteContacts(),
              DraggableScrollableSheet(
                initialChildSize: 1,
                maxChildSize: 1,
                minChildSize: 0.07,
                builder:
                    (BuildContext context, ScrollController scrolController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          //bar on the top
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 8, 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                                child: SizedBox(
                                  width: 55.0,
                                  height: 5.0,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: lightOrangeColor),
                                  ),
                                ),
                              )
                              // child: Container(
                              //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
                              //   color: Colors.black,
                              // )
                              ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrolController,
                              itemCount: chats.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Message chat = chats[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        user: chat.sender,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0, right: 20.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: chat.unread
                                          ? Color(0xFFFFEFEE)
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 35.0,
                                              backgroundImage: AssetImage(
                                                  chat.sender.imageUrl),
                                            ),
                                            SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  chat.sender.name,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    chat.text,
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              chat.time,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            chat.unread
                                                ? Container(
                                                    width: 40.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'NEW',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : Text(''),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
