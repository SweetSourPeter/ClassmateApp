import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/widgets/course_menu.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final tabs = [CourseMainMenu(), FriendsScreen()];
  final tabTitle = ['Course', 'Friends'];

  Offset _offset = Offset(0, 0);
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height / 2;

    return Container(
        width: mediaQuery.width,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: buildAppBar(),
                  body: tabs[_currentIndex],
                  bottomNavigationBar: buildBottomNavigationBar(),
                ),
                AnimatedPositioned(
                  duration: Duration(microseconds: 1500),
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

                          if (details.delta.dx > 0 &&
                              details.delta.distanceSquared > 2) {
                            setState(() {
                              isMenuOpen = true; //open entirely
                            });
                          } else if (details.delta.dx < 0 &&
                              details.delta.distanceSquared > 2) {
                            setState(() {
                              isMenuOpen =
                                  false; //close entirely need to change
                            });
                          }
                          //if click outside of the menu, then close menu

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
                                        Image.asset(
                                          "assets/images/olivia.jpg",
                                          width: sidebarSize / 2,
                                        ),
                                        Text(
                                          "Jane",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: menuContainerHeight,
                                  child: Column(
                                    children: <Widget>[
                                      MyButton(
                                        text: "Profile",
                                        iconData: Icons.person,
                                        textSize: 20,
                                        height: (menuContainerHeight) / 5,
                                      ),
                                      MyButton(
                                        text: "Notifications",
                                        iconData: Icons.notifications,
                                        textSize: 20,
                                        height: (menuContainerHeight) / 5,
                                      ),
                                      MyButton(
                                        text: "Settings",
                                        iconData: Icons.settings,
                                        textSize: 20,
                                        height: (menuContainerHeight) / 5,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  enableFeedback: true,
                                  icon: Icon(Icons.keyboard_backspace,
                                      color: Colors.black),
                                  onPressed: () {
                                    this.setState(() {
                                      isMenuOpen = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  CustomBottomNavigationBar buildBottomNavigationBar() {
    return CustomBottomNavigationBar(
      iconList: [
        Icons.class_,
        Icons.contacts,
        Icons.access_alarm,
        Icons.menu,
        Icons.accessible,
      ],
      onChange: (val) {
        setState(() {
          _currentIndex = val;
        });
      },
      defaultSelectedIndex: 0,
    );

    // BottomNavigationBar(
    //   currentIndex: _currentIndex,
    //   // backgroundColor: orengeColor,
    //   type: BottomNavigationBarType.shifting,
    //   items: [
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.class_),
    //         title: Text('courses'),
    //         backgroundColor: darkBlueColor),
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.contacts),
    //         title: Text('friends'),
    //         backgroundColor: orengeColor),
    //   ],
    //   onTap: (index) {
    //     setState(() {
    //       _currentIndex = index;
    //     });
    //   },
    // );
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
          this.setState(() {
            isMenuOpen = true;
          });
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

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / _iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: orengeColor),
                ),
                gradient: LinearGradient(colors: [
                  orengeColor.withOpacity(0.4),
                  orengeColor.withOpacity(0.015),
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                // color: index == _selectedItemIndex ? Colors.green : Colors.white,
                )
            : BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedIndex ? Colors.black : Colors.grey,
        ),
      ),
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
    // path.lineTo(size.width, size.height);
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
