import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:flutter/material.dart';
import 'package:app_test/models/message_model.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';

class FavoriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                // height: 120.0,
                child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 4,
              children: List.generate(favorites.length, (index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: favorites[index],
                      ),
                    ),
                  ),
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage(favorites[index].imageUrl),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        favorites[index].name,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
                );
              }).followedBy([
                GestureDetector(
                  onTap: () {
                    //search for users
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchUsers()));
                  },
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage:
                            AssetImage('assets/images/add_course.png'),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'add friends',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
                ),
              ]).toList(),
            )

                // ListView.builder(
                //   padding: EdgeInsets.only(left: 10.0),
                //   scrollDirection: Axis.horizontal,
                //   itemCount: favorites.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return GestureDetector(
                //       onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => ChatScreen(
                //             user: favorites[index],
                //           ),
                //         ),
                //       ),
                // child: Padding(
                //   padding: EdgeInsets.all(10.0),
                //   child: Column(
                //     children: <Widget>[
                //       CircleAvatar(
                //         radius: 35.0,
                //         backgroundImage:
                //             AssetImage(favorites[index].imageUrl),
                //       ),
                //       SizedBox(height: 6.0),
                //       Text(
                //         favorites[index].name,
                //         style: TextStyle(
                //           color: Colors.blueGrey,
                //           fontSize: 16.0,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                //     );
                //   },
                // ),
                ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
