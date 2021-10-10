import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/pages/chat_pages/chatRoom.dart';
import 'package:app_test/pages/group_chat_pages/courseMenu.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'models/constant.dart';
import 'models/courseInfo.dart';
import 'pages/my_pages/my_account.dart';

class MainMenu extends StatefulWidget {
  final UserData myData;

  MainMenu({this.myData});
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;
  // final tabTitle = ['Course', 'Friends'];
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
  }

  getPosition(duration) {
    // print("object2");
    if (globalKey.currentContext != null) {
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      // print("object3");
      final position = renderBox.localToGlobal(Offset.zero);
      double start = position.dy - 20;
      double contLimit = position.dy + renderBox.size.height - 20;
      double step = (contLimit - start) / 5;
      limits = [];
      // print("object");
      for (double x = start; x <= contLimit; x = x + step) {
        limits.add(x);
      }

      setState(() {
        limits = limits;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final course = Provider.of<List<CourseInfo>>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = maxWidth;
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = maxWidth * 1.0;
    final userTags = Provider.of<UserTags>(context);
    return (userdata == null)
        ? LoadingScreen(Colors.white)
        : Center(
            child: SizedBox(
              width: maxWidth,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      transform: Matrix4.translationValues(xOffset, yOffset, 20)
                        ..scale(scaleFactor),
                      duration: Duration(microseconds: 250),
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        // appBar: buildAppBar(),
                        body: _currentIndex == 0
                            ? CourseMainMenu(
                                course: course,
                                userData: userdata,
                              )
                            : _currentIndex == 1
                                ? ChatRoom(
                                    myData: userdata,
                                  )
                                : MyAccount(
                                    key: globalKey,
                                  ),
                        bottomNavigationBar:
                            buildBottomNavigationBar(_height, _width),
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

                            if (details.localPosition.dx > sidebarSize - 25 &&
                                details.delta.distanceSquared > 2) {
                              setMenuOpenState(true);
                            }

                            if (details.localPosition.dx < sidebarSize + 25 &&
                                details.delta.distanceSquared < 2) {
                              setMenuOpenState(false);
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: (isMenuOpen) ? 10 : sidebarSize - 20,
                      // left: (isMenuOpen) ? 10 : 100,
                      top: 5,
                      child: IconButton(
                        enableFeedback: true,
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 40,
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
          );
  }

  // Padding userInfoDetailsBox(
  //     Size mediaQuery, String topText, String bottomText) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(maxWidth / 7, 0, 0, 60),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 20,
  //           child: Text(
  //             topText,
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 color: themeOrange,
  //                 fontWeight: FontWeight.w800),
  //           ),
  //         ),
  //         Text(
  //           bottomText,
  //           style: TextStyle(
  //               fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void setMenuOpenState(bool state) {
    isMenuOpen = state;
    //open
    if (state) {
      this.setState(() {
        xOffset = 250;
        yOffset = 0;
        scaleFactor = 1;
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

  CurvedNavigationBar buildBottomNavigationBar(double _height, double _width) {
    return CurvedNavigationBar(
      animationDuration: const Duration(milliseconds: 480),
      color: Color(0xFFF9F6F1),
      backgroundColor: Colors.white, // background!!!
      buttonBackgroundColor: Colors.white,
      height: _height * 0.08,
      index: _currentIndex,
      items: <Widget>[
        _currentIndex == 0
            ? Container(
                height: _height * 0.035,
                width: _height * 0.035,
                child: Image.asset('assets/icon/navigationBar1Open.png'))
            : Container(
                height:
                    MediaQuery.of(context).size.height / 3, //_height * 0.035,
                width: _height * 0.035,
                child: Image.asset('assets/icon/navigationBar1Close.png')),
        _currentIndex == 1
            ? Container(
                height: _height * 0.05,
                width: _height * 0.05,
                child: Image.asset('assets/icon/navigationBar2Open.png'))
            : Container(
                height: _height * 0.05,
                width: _height * 0.05,
                child: Image.asset('assets/icon/navigationBar2Close.png')),
        _currentIndex == 2
            ? Container(
                height: _height * 0.04,
                width: _height * 0.04,
                child: Image.asset('assets/icon/navigationBar3Open.png'))
            : Container(
                height: _height * 0.04,
                width: _height * 0.04,
                child: Image.asset('assets/icon/navigationBar3Close.png')),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
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
