import 'package:app_test/models/user.dart';
import 'package:app_test/pages/chat_pages/chatRoom.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/course_menu.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'models/constant.dart';
import 'widgets/my_account.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;
  var tabs = [
    CourseMainMenu(),
    FriendsScreen(),
    FavoriteContacts(),
  ];
  // final tabTitle = ['Course', 'Friends'];
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
    tabs[2] = MyAccount(
      key: globalKey,
      getSize: getSize,
    );
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

  double getSize(int x) {
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);

    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;

    return (userdata == null)
        ? CircularProgressIndicator()
        : Scaffold(
            backgroundColor: orengeColor,
            appBar: AppBar(
              backgroundColor: riceColor,
              toolbarHeight: 0,
              elevation: 0,
            ),
            body: SafeArea(
                child: Scaffold(
                    body: GestureDetector(
              //if menu close and slide to right-> menu opens
              onPanUpdate: (details) {
                if (details.delta.dx > 4 && !isMenuOpen && _currentIndex == 0) {
                  //setMenuOpenState(true); //remove this to enable side menu
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
                color: Colors.white,
                width: mediaQuery.width,
                child: Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      transform: Matrix4.translationValues(xOffset, yOffset, 20)
                        ..scale(scaleFactor),
                      duration: Duration(microseconds: 250),
                      child: Scaffold(
                        backgroundColor: riceColor,
                        // appBar: buildAppBar(),
                        body: _currentIndex == 0
                            ? CourseMainMenu()
                            : _currentIndex == 1
                            ? ChatRoom(
                          myName: userdata.userName,
                          myEmail: userdata.email,
                        )
                            : FavoriteContacts(),
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
            ))),
          );
  }

  Padding userInfoDetailsBox(
      Size mediaQuery, String topText, String bottomText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(mediaQuery.width / 7, 0, 0, 60),
      child: Column(
        children: [
          Container(
            height: 20,
            child: Text(
              topText,
              style: TextStyle(
                  fontSize: 16,
                  color: themeOrange,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            bottomText,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

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
          Icons.chat,
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

  // AppBar buildAppBar() {
  //   return AppBar(
  //     centerTitle: true,
  //     backgroundColor: orengeColor,
  //     elevation: 5,
  //     leading: IconButton(
  //       iconSize: 35,
  //       color: darkBlueColor,
  //       padding: EdgeInsets.only(left: kDefaultPadding),
  //       icon: Icon(Icons.menu),
  //       onPressed: () {
  //         setMenuOpenState(true);
  //       },
  //     ),
  //     title: Container(
  //         child: Text(
  //       tabTitle[_currentIndex],
  //     )),
  //     actions: <Widget>[
  //       IconButton(
  //         iconSize: 38,
  //         color: darkBlueColor,
  //         padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
  //         icon: Icon(Icons.search),
  //         onPressed: () {
  //           //TODO
  //           switch (_currentIndex) {
  //             case 0:
  //               {
  //                 //TODO for search course ot sth
  //               }
  //               break;
  //             case 1:
  //               {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => SearchUsers()),
  //                 );
  //               }
  //               break;
  //             default:
  //               {
  //                 //TODO search for sth;
  //               }
  //               break;
  //           }
  //         },
  //       )
  //     ],
  //   );
  // }
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
