import 'package:app_test/MainScreen.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:flutter/material.dart';

import 'models/constant.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;
  final tabs = [CourseMainMenu(), FriendsScreen()];
  final tabTitle = ['Course', 'Friends'];
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;

  @override
  void initState() {
    _currentIndex = 0;
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
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
            body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(255, 65, 108, 1.0),
        Color.fromRGBO(255, 75, 73, 1.0)
      ])),
      width: mediaQuery.width,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(),
            body: tabs[_currentIndex],
            bottomNavigationBar: buildBottomNavigationBar(),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            left: isMenuOpen ? 0 : -sidebarSize + 20,
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
                    setState(() {
                      isMenuOpen = true;
                    });
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
                                    backgroundImage:
                                        AssetImage("assets/images/olivia.jpg"),
                                  ),
                                  // Image.asset(
                                  //   "assets/images/olivia.jpg",
                                  //   width: sidebarSize / 2,
                                  // ),
                                  Text(
                                    "RetroPortal Studio",
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
                                  height: (menuContainerHeight) / 5,
                                ),
                                MyButton(
                                  text: "Payments",
                                  iconData: Icons.payment,
                                  textSize: getSize(1),
                                  height: (menuContainerHeight) / 5,
                                ),
                                MyButton(
                                  text: "Notifications",
                                  iconData: Icons.notifications,
                                  textSize: getSize(2),
                                  height: (mediaQuery.height / 2) / 5,
                                ),
                                MyButton(
                                  text: "Settings",
                                  iconData: Icons.settings,
                                  textSize: getSize(3),
                                  height: (menuContainerHeight) / 5,
                                ),
                                MyButton(
                                  text: "My Files",
                                  iconData: Icons.attach_file,
                                  textSize: getSize(4),
                                  height: (menuContainerHeight) / 5,
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
                          this.setState(() {
                            isMenuOpen = false;
                          });
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
    )));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      // backgroundColor: orengeColor,
      type: BottomNavigationBarType.shifting,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            title: Text('courses'),
            backgroundColor: darkBlueColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text('friends'),
            backgroundColor: orengeColor),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: orengeColor,
      elevation: 0,
      leading: IconButton(
        iconSize: 35,
        color: darkBlueColor,
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: Icon(Icons.menu),
        onPressed: () {
          //TODO
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

  MyButton({this.text, this.iconData, this.textSize, this.height});

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
      onPressed: () {},
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
