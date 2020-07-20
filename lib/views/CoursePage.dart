import 'package:app_test/modals/constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/widgets/category_selector.dart';
// import 'package:flutter_chat_ui/widgets/favorite_contacts.dart';
// import 'package:flutter_chat_ui/widgets/recent_chats.dart';
import 'package:app_test/widgets/category_selector.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/recent_chats.dart';
import 'package:app_test/views/chatScreen.dart';
import 'package:app_test/modals/message_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     iconSize: 30.0,
        //     color: Colors.white,
        //     onPressed: () {},
        //   ),
        //   title: Text(
        //     'Chats',
        //     style: TextStyle(
        //       fontSize: 28.0,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   elevation: 0.0,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.search),
        //       iconSize: 30.0,
        //       color: Colors.white,
        //       onPressed: () {
        //         //TO DO
        //       },
        //     ),
        //   ],
        // ),
        body: Scaffold(
          backgroundColor: lightBlueColor,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // CategorySelector(),
              FavoriteContacts(),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).accentColor,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(30.0),
              //       topRight: Radius.circular(30.0),
              //     ),
              //   ),
              //   child: CategorySelector(),
              // ),
              DraggableScrollableSheet(
                maxChildSize: 1,
                minChildSize: 0.1,
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
                                        backgroundImage:
                                            AssetImage(chat.sender.imageUrl),
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
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
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
                                                    BorderRadius.circular(30.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'NEW',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
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
                  );
                },
              )
            ],
          ),
        ));

    // Column(
    //   children: <Widget>[
    //     // CategorySelector(),
    //     Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).accentColor,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(30.0),
    //             topRight: Radius.circular(30.0),
    //           ),
    //         ),
    //         child: Column(
    //           children: <Widget>[
    //             FavoriteContacts(),
    //             // DraggableScrollableSheet(
    //             //     maxChildSize: 0.65,
    //             //     minChildSize: 0.2,
    //             //     builder: (BuildContext context,
    //             //         ScrollController scrolController) {
    //             //       return SingleChildScrollView(
    //             //           controller: scrolController, child: RecentChats());
    //             //     })
    //             RecentChats(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    // );
  }
}
