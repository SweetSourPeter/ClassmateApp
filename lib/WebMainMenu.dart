import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/chat_pages/chatRoom.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/widgets/my_account.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/group_chat_pages/courseMenu.dart';

List<List<String>> fileLocation = [
  ['assets/icon/navigationBar1Open.png', 'assets/icon/navigationBar1Close.png'],
  ['assets/icon/navigationBar2Open.png', 'assets/icon/navigationBar2Close.png'],
  ['assets/icon/navigationBar3Open.png', 'assets/icon/navigationBar3Close.png'],
];

class WebMainMenu extends StatefulWidget {
  @override
  _WebMainMenuState createState() => _WebMainMenuState();
}

List<bool> selected = [true, false, false];

class _WebMainMenuState extends State<WebMainMenu> {
  int _currentIndex = 0;
  void select(int n) {
    selected = [false, false, false, false];
    selected[n] = true;
    _currentIndex = n;
  }

  @override
  void initState() {
    // TODO: implement initState
    select(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final course = Provider.of<List<CourseInfo>>(context);
    final userdata = Provider.of<UserData>(context);
    return (userdata == null)
        ? CircularProgressIndicator()
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  color: Colors.white,
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  left: 101,
                  right: 0,
                  child: _currentIndex == 0
                      ? CourseMainMenu(
                          course: course,
                          userData: userdata,
                        )
                      : _currentIndex == 1
                          ? ChatRoom(
                              myName: userdata.userName,
                              myEmail: userdata.email,
                            )
                          : MyAccount(
                              // key: globalKey,
                              ),
                ),
                Container(
                  // margin: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height,
                  width: 101.0,
                  // decoration: BoxDecoration(
                  //   color: themeOrange,
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                  color: themeOrange,
                  child: Stack(
                    children: [
                      Positioned(
                        left: (101 / 2) - (_height * 0.12 / 2),
                        top: 24,
                        child: Container(
                            height: _height * 0.12 * 1.0924,
                            width: _height * 0.12,
                            child: FittedBox(
                              child:
                                  Image.asset('assets/icon/earCircleWhite.png'),
                              fit: BoxFit.fitHeight,
                            )),
                      ),
                      // Positioned(
                      //   top: 12,
                      //   left: (101 / 2) - (_height * 0.12 / 2),
                      //   child: CircleAvatar(
                      //     backgroundColor: themeOrange,
                      //     radius: _height * 0.12 / 2,
                      //   ),
                      // ),
                      Positioned(
                        left: (101 / 2) - (_height * 0.12 / 2) + 3,
                        top: 33.3,
                        child: createUserImage(
                          (_height * 0.12 - 5.1) / 2,
                          userdata,
                          largeTitleTextStyleBold(Colors.white, 25),
                        ),
                      ),
                      Positioned(
                        top: 160,
                        left: 0,
                        child: Column(
                          children: fileLocation
                              .map(
                                (e) => NavBarItem(
                                  fileLocation: e,
                                  selected: selected[fileLocation.indexOf(e)],
                                  onTap: () {
                                    setState(() {
                                      select(fileLocation.indexOf(e));
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class NavBarItem extends StatefulWidget {
  final List<String> fileLocation;
  final Function onTap;
  final bool selected;
  NavBarItem({
    this.fileLocation,
    this.onTap,
    this.selected,
  });
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  bool hovered = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: 101.0,
          child: Stack(
            children: [
              widget.selected
                  ? Positioned(
                      top: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 30,
                        width: 3.5,
                      ),
                    )
                  : Container(),
              Container(
                height: 80.0,
                width: 101.0,
                color: hovered && !widget.selected
                    ? Colors.white12
                    : Colors.transparent,
                child: Center(
                    child: Container(
                  height: 25,
                  width: 25,
                  child: widget.selected
                      ? Image.asset(widget.fileLocation[0])
                      : Image.asset(widget.fileLocation[1]),
                )
                    // Icon(
                    //   widget.icon,
                    //   color: _color.value,
                    //   size: 18.0,
                    // ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
