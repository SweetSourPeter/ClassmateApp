import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/utils/animation_item.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FirstPageLogin extends StatefulWidget {
  final PageController pageController;
  final Color buttonColor;

  const FirstPageLogin({Key key, this.pageController, this.buttonColor})
      : super(key: key);
  @override
  _FirstPageLoginState createState() => _FirstPageLoginState();
}

class _FirstPageLoginState extends State<FirstPageLogin> {
  List<AnimationItem> animationlist = [];
  double _scaleHolder = 0;
  @override
  void initState() {
    super.initState();
    delayAnimatiom(
        AnimationItem(
          name: 'padding_top_label',
          tween: Tween<double>(begin: 0.0, end: 1),
        ),
        Duration(milliseconds: 800), (animation) {
      setState(() {
        animationlist.add(animation);
      });
    });
    delayAnimatiom(
        AnimationItem(
          name: 'button_scale',
          tween: Tween<double>(begin: 0.0, end: 0.9),
        ),
        Duration(milliseconds: 1200), (animation) {
      setState(() {
        animationlist.add(animation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Container(
      color: themeOrange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TweenAnimationBuilder(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: findAnimation('padding_top_label', 20, animationlist),
              builder: (context, value, child) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: _height * 0.28 + value),
                      child: AnimatedOpacity(
                        opacity: value == 20 ? 0 : 1,
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          'Hi there,',
                          style: largeTitleTextStyle(Colors.white, 26),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: AnimatedOpacity(
                        opacity: value == 20 ? 0 : 1,
                        duration: Duration(milliseconds: 800),
                        child: Text(
                          'Nice to MEECHU !',
                          style: largeTitleTextStyle(Colors.white, 26),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TweenAnimationBuilder(
                        duration: Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        tween: findAnimation(
                            'padding_top_label', 20, animationlist),
                        builder: (context, paddingvalue, child) {
                          return AnimatedOpacity(
                            opacity: paddingvalue == 20 ? 0 : 1,
                            duration: Duration(milliseconds: 1300),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 15 + paddingvalue),
                              child: Text(
                                'Place to find fellow classmates and \n make meaningful connections',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                  ],
                );
              }),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            child: Column(
              children: <Widget>[
                TweenAnimationBuilder(
                  child: LogoWidget(),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  tween: _scaleHolder == 0.0
                      ? findAnimation('button_scale', 0.0, animationlist)
                      : Tween(begin: 0.9, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 10),
                                        blurRadius: 15),
                                  ],
                                ),
                                height: _height * 0.075,
                                child: RaisedButton(
                                  onHighlightChanged: (press) {
                                    setState(() {
                                      if (press) {
                                        _scaleHolder = 0.1;
                                      } else {
                                        _scaleHolder = 0.0;
                                      }
                                    });
                                  },
                                  hoverColor: Colors.white,
                                  hoverElevation: 0,
                                  highlightColor: Colors.white,
                                  highlightElevation: 0,
                                  elevation: 0,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  onPressed: () {
                                    widget.pageController.animateToPage(1,
                                        duration: Duration(milliseconds: 800),
                                        curve: Curves.easeInCubic);
                                  },
                                  child: Text(
                                    'LETS FIND MY CLASSMATES!',
                                    style: simpleTextSansStyleBold(
                                        themeOrange, 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder(
                    //child: LogoWidget(),
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    tween: findAnimation('button_scale', 0.0, animationlist),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: GestureDetector(
                          onTap: () {
                            widget.pageController.animateToPage(2,
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInCubic);
                          },
                          child: Text(
                            'I ALREADY HAVE AN ACCOUNT',
                            style:
                                simpleTextSansStyleBold(Color(0xFFFFFFB3), 16),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
