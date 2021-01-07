import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import 'package:app_test/pages/explore_pages/reportUser.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_test/models/message_model.dart';
import 'package:app_test/pages/chat_pages/chatScreen.dart';
import 'package:provider/provider.dart';

class FavoriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final contacts = Provider.of<List<UserData>>(context);
    void showBottomSheet() {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 15, color: Colors.transparent),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                // bottomLeft: Radius.circular(30.0),
                // bottomRight: Radius.circular(30.0),
              )),
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return ReportUser();
          });
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text('Block'),
                    onPressed: () {},
                    isDestructiveAction: true,
                  ),
                  CupertinoActionSheetAction(
                    child: Text('Report'),
                    onPressed: () {},
                    isDestructiveAction: true,
                  ),
                  CupertinoActionSheetAction(
                    child: Text('Save Profile QR Code'),
                    onPressed: () {},
                    isDefaultAction: true,
                  ),
                  CupertinoActionSheetAction(
                    child: Text('Share this Profile'),
                    onPressed: () {},
                    isDefaultAction: true,
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancle'),
                  onPressed: () {},
                  isDefaultAction: false,
                ));
          });
    }

    return (contacts == null)
        ? CircularProgressIndicator()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 33, top: 30, bottom: 30),
                        child: Container(
                          // color: orengeColor,
                          child: Row(
                            children: [
                              Text(
                                'Classmates',
                                textAlign: TextAlign.left,
                                style:
                                    largeTitleTextStyleBold(Colors.black, 26),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2, top: 10),
                                //TODO replace Icon
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Text(
                    //   'Favorite Contacts',
                    //   style: TextStyle(
                    //     color: Colors.blueGrey,
                    //     fontSize: 18.0,
                    //     fontWeight: FontWeight.bold,
                    //     letterSpacing: 1.0,
                    //   ),
                    // ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //   ),
                    //   iconSize: 30.0,
                    //   color: Colors.blueGrey,
                    //   onPressed: () {
                    //     showBottomSheet();
                    //   },
                    // ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Container(
                        // height: 120.0,
                        child: GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      children: List.generate(contacts.length, (index) {
                        return GestureDetector(
                          // onTap: () => Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => ChatScreen(
                          //       //TODO
                          //       user: favorites[index],
                          //     ),
                          //   ),
                          // ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendProfile(
                                  userID: contacts[index]
                                      .userID, // to be modified to friend's ID
                                ),
                              ),
                            );
                          },
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              createUserImage(30.0, contacts[index]),
                              // CircleAvatar(
                              //   radius: 30.0,
                              //   child: Container(
                              //     child: (contacts[index].userImageUrl == null)
                              //         ? Text(
                              //             contacts[index].userName[0].toUpperCase(),
                              //             style: TextStyle(
                              //                 fontSize: 35, color: Colors.white),
                              //           )
                              //         : null,
                              //   ),
                              //   backgroundImage: (contacts[index].userImageUrl == null)
                              //       ? null
                              //       : AssetImage(contacts[index].userImageUrl),
                              // ),
                              SizedBox(height: 6.0),
                              Text(
                                contacts[index].userName,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 10.0,
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
                                MaterialPageRoute(builder: (context) {
                              return MultiProvider(
                                providers: [
                                  Provider<UserData>.value(
                                    value: userdata,
                                  ),
                                  // 这个需要的话直接uncomment
                                  // Provider<List<CourseInfo>>.value(
                                  //   value: course,F
                                  // ),
                                  // final courseProvider = Provider.of<CourseProvider>(context);
                                  // 上面这个courseProvider用于删除添加课程，可以直接在每个class之前define，
                                  // 不需要pass到push里面，直接复制上面这行即可
                                ],
                                child: SearchUsers(),
                              );
                            }));
                          },
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: orengeColor,
                                radius: 30.0,
                                backgroundImage:
                                    AssetImage('assets/images/add_course.png'),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                'Add friends',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 10.0,
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
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
  }
}
