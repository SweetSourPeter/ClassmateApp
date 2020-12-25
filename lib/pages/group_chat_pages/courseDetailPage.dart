import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/constant.dart';
import '../../MainMenu.dart';
import 'package:provider/provider.dart';

class CourseDetailPage extends StatefulWidget {
  final String chatRoomId;
  final String myEmail;
  final String myName;

  CourseDetailPage({this.chatRoomId, this.myEmail, this.myName});

  @override
  _State createState() => _State();
}

class _State extends State<CourseDetailPage> {
  bool isSwitched = false;

  List<Widget> _renderNinepeoplePreview(radius) {
    return List.generate(10, (index) {
      if (index == 9) {
        return GestureDetector(
          child: Container(
            child: Column(
              children: <Widget>[
                creatAddIconImage(radius),
                Text(
                  'Invite',
                  style:
                      GoogleFonts.montserrat(color: orengeColor, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }
      return Container(
        //color: orengeColor,
        child: Column(
          children: <Widget>[
            creatUserImage(
                radius,
                UserData(
                  userID: 'asd',
                  school: 'asd',
                  email: 'asd',
                  userImageUrl: 'asd',
                  userName: 'asd',
                )),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(
                'text',
                style:
                    GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    double gridWidth = (size - 40 - 4 * 15) / 10;
    double gridRatio = gridWidth / (gridWidth + 10);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff9f6f1),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 73,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/back_arrow.pic',
                            ),
                            // iconSize: 30.0,
                            color: const Color(0xFFFFB811),
                            onPressed: () {
                              // databaseMethods.setUnreadNumber(widget.chatRoomId, widget.myEmail, 0);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CS111 A1',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Spring',
                              style: GoogleFonts.montserrat(
                                color: Colors.black38,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              )),
                        ],
                      ),
                      Container(width: 48)
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 8.0),
                      //   child: IconButton(
                      //     icon: Image.asset(
                      //         'assets/images/group_more.png',
                      //         height: 26,
                      //         width: 50
                      //     ),
                      //     // iconSize: 10.0,
                      //     onPressed: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (context) {
                      //             return MultiProvider(
                      //               providers: [
                      //                 Provider<UserData>.value(
                      //                   value: currentUser,
                      //                 )
                      //               ],
                      //               child: CourseDetailPage(),
                      //             );
                      //           }));
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  color: riceColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 30),
                          margin: EdgeInsets.only(top: 25),
                          color: Colors.white,
                          child: Column(children: <Widget>[
                            Container(
                              height: 20,
                              //color: Colors.black,
                              child: Stack(children: <Widget>[
                                Positioned(
                                  child: Text('Group Members',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400, fontSize: 18)),
                                  top: 0,
                                ),
                                Positioned(
                                    child: GestureDetector(
                                      child: Row(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Text("25 people",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            child: Icon(
                                              Icons.navigate_next,
                                              color: Colors.black38,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    top: -3,
                                    right: 0),
                              ]),
                            ),
                            Container(
                              //color: Colors.green,
                              height: (gridWidth * 2 / gridRatio) * 2 + 10 + 30,
                              padding: EdgeInsets.only(top: 30),
                              child: GridView.count(
                                primary: false,
                                shrinkWrap: true,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10,
                                crossAxisCount: 5,
                                childAspectRatio: gridRatio,
                                children: _renderNinepeoplePreview(gridWidth),
                              ),
                            )
                          ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              // ButtonLink(
                              //   text: "Media, Links, and Docs",
                              //   iconData: Icons.folder,
                              //   textSize: 18,
                              //   height: 50,
                              // ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              ButtonLink(
                                text: "Chat Search",
                                iconData: Icons.search,
                                textSize: 18,
                                height: 50,
                              ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              // ButtonLink(
                              //     text: "Mute",
                              //     iconData: Icons.notifications_off,
                              //     textSize: 18,
                              //     height: 50,
                              //     isSwitch: true),
                              Divider(
                                height: 0,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(top: 25),
                        //     child: Column(
                        //       children: [
                        //         Divider(
                        //           height: 0,
                        //           thickness: 1,
                        //         ),
                        //         // ButtonLink(
                        //         //     text: "Clear Chat",
                        //         //     iconData: Icons.cleaning_services,
                        //         //     textSize: 18,
                        //         //     height: 50,
                        //         //     isSimple: true),
                        //         Divider(
                        //           height: 0,
                        //           thickness: 1,
                        //         )
                        //       ],
                        //     )),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              ButtonLink(
                                  text: "Exit Group",
                                  iconData: Icons.cleaning_services,
                                  textSize: 18,
                                  height: 50,
                                  isSimple: true),
                              Divider(
                                height: 0,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}