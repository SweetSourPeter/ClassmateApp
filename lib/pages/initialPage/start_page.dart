import 'package:app_test/models/user.dart';
import 'package:app_test/pages/initialPage/tagSelectingStepper.dart';
import 'package:app_test/pages/initialPage/privacy_page.dart';
import 'package:app_test/pages/initialPage/second_page.dart';
import 'package:app_test/pages/initialPage/third_page.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/utils/animation_item.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/widgets/widgets.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  PageController _pageController;
  List<AnimationItem> animationlist = [];
  Tween<double> postionLogo;
  int _currentIndex = 0;
  int _currentIndexColor = 0;
  String _currentUserName = '';
  Tween _animacaoColor;
  @override
  void initState() {
    super.initState();
    setState(() {});
    delayAnimatiom(
        AnimationItem(
          name: 'logo_scale',
          tween: Tween<double>(begin: 0.0, end: 0.8),
        ),
        Duration(milliseconds: 800), (animation) {
      setState(() {
        animationlist.add(animation);
      });
    });
    _pageController = PageController(initialPage: 0);
    postionLogo = Tween(begin: 0.0, end: 0.0);
    _animacaoColor = Tween(begin: 2.3, end: 2.3);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = getRealWidth(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 400),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _currentIndexColor != null
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              themeOrange,
                              themeOrange,
                            ])
                      : null),
            ),
            builder: (BuildContext context, value, Widget child) {
              return Transform.scale(scale: value, child: child);
            },
            tween: _animacaoColor,
          ),
          SizedBox(
            height: _height,
            width: _height,
            child: PageView(
              physics: NeverScrollableScrollPhysics(parent: null),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  switch (index) {
                    case 0:
                      postionLogo = Tween(begin: 0.0, end: 0.25);
                      break;
                    default:
                      postionLogo = Tween(begin: 0.0, end: 0.25);
                  }
                });
              },
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SecondPage(
                  pageController: _pageController,
                  valueChanged: (index) {
                    setState(() {
                      _currentUserName = index;
                    });
                  },
                ),
                ThirdPage(
                  pageController: _pageController,
                  userName: _currentUserName,
                  initialIndex: _currentIndexColor,
                  valueChanged: (index) {
                    setState(() {
                      _animacaoColor = Tween(begin: 4.0, end: 0.0);
                      _currentIndexColor = index;
                      _animacaoColor = Tween(begin: 0.0, end: 2.3);
                    });
                  },
                ),
                TagSelecting(
                  pageController: _pageController,
                  buttonColor: listColors[_currentIndexColor].colors[1],
                ),
                PrivacyPage(
                  pageController: _pageController,
                  buttonColor: listColors[_currentIndexColor].colors[1],
                ),
              ],
            ),
          ),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 250),
            curve: _currentIndex == null ? Curves.elasticOut : Curves.easeInOut,
            tween: postionLogo,
            builder: (BuildContext context, animation, Widget child) {
              return AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                top: _currentIndex == 2 ? -_height : _height * 0.004,
                left: _width / 2 - (156 / 2), //logo widget width/2
                child: TweenAnimationBuilder(
                  child: LogoWidget(140, 156),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  tween: findAnimation('logo_scale', 0.0, animationlist),
                  builder: (context, value, child) {
                    return Transform.scale(
                        scale: value - animation, child: child);
                  },
                ),
              );
            },
          ),
          AnimatedPositioned(
            top: _height * 0.05,
            left: _currentIndex == null || _currentIndex == 0
                ? -40
                : _width * 0.098,
            width: 40,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: closeWhite,
                    size: 30,
                  ),
                  onPressed: () {
                    _pageController.animateToPage(_currentIndex - 1,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInCubic);
                  },
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            top: _height * 0.9,
            right: _width / 2 - _width * 0.08,
            height: 40,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10,
                  width: _width * 0.02,
                  decoration: BoxDecoration(
                      color: _currentIndex == 0 ? Colors.white : Colors.white54,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 12,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 70,
                  width: _width * 0.02,
                  decoration: BoxDecoration(
                      color: _currentIndex == 1 ? Colors.white : Colors.white54,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 12,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10,
                  width: _width * 0.02,
                  decoration: BoxDecoration(
                      color: _currentIndex == 2 ? Colors.white : Colors.white54,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 12,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10,
                  width: _width * 0.02,
                  decoration: BoxDecoration(
                      color: _currentIndex == 3 ? Colors.white : Colors.white54,
                      shape: BoxShape.circle),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
