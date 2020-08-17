import 'package:app_test/MainScreen.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/course_menu.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'models/constant.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  AuthMethods authMethods = new AuthMethods();
  int _currentIndex = 0;
  final tabs = [CourseMainMenu(), FriendsScreen()];
  final tabTitle = ['Course', 'Friends'];
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit - start) / 5;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height / 2;

    return SafeArea(
        child: Scaffold(
            body: GestureDetector(
      //if menu close and slide to right-> menu opens
      onPanUpdate: (details) {
        if (details.delta.dx > 4 && !isMenuOpen && _currentIndex == 0) {
          setMenuOpenState(true);
        }
        // else if (details.delta.dx < 4 && !isMenuOpen && _currentIndex == 0) {
        //   print('b');
        //   setState(() {
        //     _currentIndex = 1;
        //   });
        // }
        // else if (details.delta.dx < 4 && !isMenuOpen && _currentIndex == 1) {
        //   print('c');
        //   setState(() {
        //     _currentIndex = 0;
        //   });
        // }
      },
      //if the menu opens and tap on the side->close menu
      onTapDown: (details) {
        if (isMenuOpen && details.globalPosition.dx > sidebarSize) {
          setMenuOpenState(false);
        }
      },
      child: Container(
        color: darkBlueColor,
        width: mediaQuery.width,
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 20)
                ..scale(scaleFactor),
              duration: Duration(microseconds: 250),
              child: Scaffold(
                backgroundColor: Colors.white,
                // appBar: buildAppBar(),
                body: tabs[_currentIndex],
                bottomNavigationBar: buildBottomNavigationBar(),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              left: isMenuOpen ? 0 : -sidebarSize + 0,
              top: 0,
              curve: Curves.elasticOut,
              child: SizedBox(
                width: sidebarSize,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.localPosition.dx <= sidebarSize) {
                      setState(() {
                        _offset = details.localPosition;
                      });
                    }

                    if (details.localPosition.dx > sidebarSize - 20 &&
                        details.delta.distanceSquared > 2) {
                      setMenuOpenState(true);
                    }
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _offset = Offset(0, 0);
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        size: Size(sidebarSize, mediaQuery.height),
                        painter: DrawerPainter(offset: _offset),
                      ),
                      Container(
                        height: mediaQuery.height,
                        width: sidebarSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: mediaQuery.height * 0.25,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: sidebarSize / 4.5,
                                      backgroundImage: AssetImage(
                                          "assets/images/olivia.jpg"),
                                    ),
                                    // Image.asset(
                                    //   "assets/images/olivia.jpg",
                                    //   width: sidebarSize / 2,
                                    // ),
                                    Text(
                                      "Jane Studio",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Container(
                              key: globalKey,
                              width: double.infinity,
                              height: menuContainerHeight,
                              child: Column(
                                children: <Widget>[
                                  MyButton(
                                    text: "Profile",
                                    iconData: Icons.person,
                                    textSize: getSize(0),
                                    height: (menuContainerHeight) / 6,
                                  ),
                                  MyButton(
                                    text: "Friends",
                                    iconData: Icons.contacts,
                                    textSize: getSize(1),
                                    height: (menuContainerHeight) / 6,
                                  ),
                                  MyButton(
                                    text: "Notifications",
                                    iconData: Icons.notifications,
                                    textSize: getSize(2),
                                    height: (mediaQuery.height / 2) / 6,
                                  ),
                                  MyButton(
                                    text: "Settings",
                                    iconData: Icons.settings,
                                    textSize: getSize(3),
                                    height: (menuContainerHeight) / 6,
                                  ),
                                  MyButton(
                                    onTap: () {
                                      authMethods.signOut();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper()),
                                      );
                                    },
                                    text: "Log Out",
                                    iconData: Icons.offline_bolt,
                                    textSize: getSize(3),
                                    height: (menuContainerHeight) / 6,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 400),
                        right: (isMenuOpen) ? 10 : sidebarSize,
                        bottom: 30,
                        child: IconButton(
                          enableFeedback: true,
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.black45,
                            size: 30,
                          ),
                          onPressed: () {
                            setMenuOpenState(false);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    )));
  }

  void setMenuOpenState(bool state) {
    isMenuOpen = state;
    //open
    if (state) {
      this.setState(() {
        xOffset = 280;
        yOffset = 150;
        scaleFactor = 0.6;
      });
    } else {
      //close
      this.setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
      });
    }
  }

  CurvedNavigationBar buildBottomNavigationBar() {
    return CurvedNavigationBar(
      color: orengeColor,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.white,
      height: 50,
      index: _currentIndex,
      items: <Widget>[
        Icon(
          Icons.class_,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.contacts,
          size: 19,
          color: Colors.black,
        ),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  // BottomNavigationBar buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     currentIndex: _currentIndex,
  //     // backgroundColor: orengeColor,
  //     type: BottomNavigationBarType.shifting,
  //     items: [
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.class_),
  //           title: Text('courses'),
  //           backgroundColor: orengeColor),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.contacts),
  //           title: Text('friends'),
  //           backgroundColor: orengeColor),
  //     ],
  //     onTap: (index) {
  //       setState(() {
  //         _currentIndex = index;
  //       });
  //     },
  //   );
  // }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: orengeColor,
      elevation: 5,
      leading: IconButton(
        iconSize: 35,
        color: darkBlueColor,
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: Icon(Icons.menu),
        onPressed: () {
          setMenuOpenState(true);
        },
      ),
      title: Container(
          child: Text(
        tabTitle[_currentIndex],
      )),
      actions: <Widget>[
        IconButton(
          iconSize: 38,
          color: darkBlueColor,
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: Icon(Icons.search),
          onPressed: () {
            //TODO
            switch (_currentIndex) {
              case 0:
                {
                  //TODO for search course ot sth
                }
                break;
              case 1:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchUsers()),
                  );
                }
                break;
              default:
                {
                  //TODO search for sth;
                }
                break;
            }
          },
        )
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final GestureTapCallback onTap;

  MyButton({this.text, this.iconData, this.textSize, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black45, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {
        onTap();
      },
    );
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
