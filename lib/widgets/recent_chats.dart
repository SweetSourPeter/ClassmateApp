// import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';
import 'package:app_test/models/message_model.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // To convert this infinite list to a list with three items,
          // uncomment the following line:
          // if (index > 3) return null;
          return Container(height: 150.0);
        },
        // Or, uncomment the following line:
        // childCount: 3,
      ),

      // delegate: SliverChildBuilderDelegate(BuildContext context, int index) {

      //   final Message chat = chats[index];
      //   return Container();
      // return GestureDetector(
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => ChatScreen(
      //         user: chat.sender,
      //       ),
      //     ),
      //   ),
      //   child: Container(
      //     margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
      //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //     decoration: BoxDecoration(
      //       color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
      //       borderRadius: BorderRadius.only(
      //         topRight: Radius.circular(20.0),
      //         bottomRight: Radius.circular(20.0),
      //       ),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Row(
      //           children: <Widget>[
      //             CircleAvatar(
      //               radius: 35.0,
      //               backgroundImage: AssetImage(chat.sender.imageUrl),
      //             ),
      //             SizedBox(width: 10.0),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Text(
      //                   chat.sender.name,
      //                   style: TextStyle(
      //                     color: Colors.grey,
      //                     fontSize: 15.0,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 SizedBox(height: 5.0),
      //                 Container(
      //                   width: MediaQuery.of(context).size.width * 0.45,
      //                   child: Text(
      //                     chat.text,
      //                     style: TextStyle(
      //                       color: Colors.blueGrey,
      //                       fontSize: 15.0,
      //                       fontWeight: FontWeight.w600,
      //                     ),
      //                     overflow: TextOverflow.ellipsis,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //         Column(
      //           children: <Widget>[
      //             Text(
      //               chat.time,
      //               style: TextStyle(
      //                 color: Colors.grey,
      //                 fontSize: 15.0,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             SizedBox(height: 5.0),
      //             chat.unread
      //                 ? Container(
      //                     width: 40.0,
      //                     height: 20.0,
      //                     decoration: BoxDecoration(
      //                       color: Theme.of(context).primaryColor,
      //                       borderRadius: BorderRadius.circular(30.0),
      //                     ),
      //                     alignment: Alignment.center,
      //                     child: Text(
      //                       'NEW',
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 12.0,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   )
      //                 : Text(''),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // );

      // },
    );
    // Container(
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(30.0),
    //       topRight: Radius.circular(30.0),
    //     ),
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(30.0),
    //       topRight: Radius.circular(30.0),
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         // Container(
    //         //   margin: EdgeInsets.only(top: kDefaultPadding/4),
    //         //   height: 2,
    //         //   width: 30,
    //         //   color: Colors.black,
    //         // ),
    //         ListViewBuild(),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ListViewBuild extends StatelessWidget {
  const ListViewBuild({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35.0,
                      backgroundImage: AssetImage(chat.sender.imageUrl),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          width: MediaQuery.of(context).size.width * 0.45,
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
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0),
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
    );
  }
}
