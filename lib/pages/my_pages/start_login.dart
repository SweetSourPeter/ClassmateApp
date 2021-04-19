import 'package:app_test/pages/my_pages/first_page_login.dart';
import 'package:app_test/pages/utils/animation_item.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_test/pages/my_pages/forgetpassword.dart';
import 'package:app_test/pages/my_pages/sign_in.dart';
import 'package:app_test/pages/my_pages/sign_up.dart';
import 'package:app_test/widgets/widgets.dart';

class StartLoginPage extends StatefulWidget {
  @override
  _StartLoginPageState createState() => _StartLoginPageState();
}

class _StartLoginPageState extends State<StartLoginPage> {
  PageController _pageController;
  List<AnimationItem> animationlist = [];
  Tween<double> postionLogo;
  int _currentIndex;
  int _currentIndexColor = 0;
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
      if (mounted) {
        setState(() {
          animationlist.add(animation);
        });
      }
    });
    _pageController = PageController(initialPage: 1);
    postionLogo = Tween(begin: 0.0, end: 0.0);
    _animacaoColor = Tween(begin: 2.3, end: 2.3);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                      case 1:
                        postionLogo = Tween(begin: 0.0, end: 0.0);
                        break;
                      default:
                        postionLogo = Tween(begin: 0.0, end: 0.25);
                    }
                  });
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SignIn(
                    pageController: _pageController,
                  ),
                  FirstPageLogin(
                    pageController: _pageController,
                    buttonColor: listColors[_currentIndexColor].colors[0],
                  ),
                  SignUpPage(
                    pageController: _pageController,
                  ),
                  Forgetpassword(),
                ],
              ),
            ),
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 250),
              curve:
                  _currentIndex == null ? Curves.elasticOut : Curves.easeInOut,
              tween: postionLogo,
              builder: (BuildContext context, animation, Widget child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  top: _currentIndex == null || _currentIndex == 1
                      ? _height * 0.11
                      : _height * 0.000,
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
            // AnimatedPositioned(
            //   top: _height * 0.85,
            //   right: _currentIndex == null || _currentIndex == 0 ? -40 : 10,
            //   width: 40,
            //   duration: Duration(milliseconds: 400),
            //   curve: Curves.easeOutCubic,
            //   child: Column(
            //     children: <Widget>[
            //       IconButton(
            //         icon: Icon(
            //           Icons.expand_less,
            //           color: Colors.white54,
            //         ),
            //         onPressed: () {
            //           _pageController.animateToPage(_currentIndex - 1,
            //               duration: Duration(milliseconds: 800),
            //               curve: Curves.easeInCubic);
            //         },
            //       ),
            //       SizedBox(
            //         height: 0,
            //       ),
            //       IconButton(
            //         icon: Icon(
            //           Icons.expand_more,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           _pageController.animateToPage(_currentIndex + 1,
            //               duration: Duration(milliseconds: 800),
            //               curve: Curves.easeInCubic);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // AnimatedPositioned(
            //   top: _currentIndex == null || _currentIndex == 0
            //       ? _height * 1.3
            //       : _height * 0.946,
            //   right: _width / 2 - 27,
            //   height: 40,
            //   duration: Duration(milliseconds: 400),
            //   curve: Curves.easeOutCubic,
            //   child: Row(
            //     children: <Widget>[
            //       AnimatedContainer(
            //         duration: Duration(milliseconds: 300),
            //         height: 10,
            //         width: 10,
            //         decoration: BoxDecoration(
            //             color: _currentIndex == 1 ? Colors.white : Colors.white54,
            //             shape: BoxShape.circle),
            //       ),
            //       SizedBox(
            //         width: 12,
            //       ),
            //       AnimatedContainer(
            //         duration: Duration(milliseconds: 300),
            //         height: 70,
            //         width: 10,
            //         decoration: BoxDecoration(
            //             color: _currentIndex == 2 ? Colors.white : Colors.white54,
            //             shape: BoxShape.circle),
            //       ),
            //       SizedBox(
            //         width: 12,
            //       ),
            //       AnimatedContainer(
            //         duration: Duration(milliseconds: 300),
            //         height: 10,
            //         width: 10,
            //         decoration: BoxDecoration(
            //             color: _currentIndex == 3 ? Colors.white : Colors.white54,
            //             shape: BoxShape.circle),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
