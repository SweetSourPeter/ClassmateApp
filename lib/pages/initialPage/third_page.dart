import 'package:app_test/models/user.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/change_color.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
//import 'dart:math' as math;

class ThirdPage extends StatefulWidget {
  final PageController pageController;
  final String userName;
  final ValueChanged<int> valueChanged;
  final int initialIndex;
  final bool isEdit;
  ThirdPage(
      {Key key,
      this.userName,
      this.valueChanged,
      this.pageController,
      this.initialIndex,
      this.isEdit = false})
      : super(key: key);
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  //double _offset = 0;
  double _currentindex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.initialIndex ?? 0, viewportFraction: 0.3);
    _pageController.addListener(() {
      setState(() {
        //_offset = _pageController.offset;
        _currentindex = _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final userTagProvider = Provider.of<UserTagsProvider>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.23),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.044,
              ),
              Text(
                'Choose your theme color!',
                style: largeTitleTextStyleBold(Colors.white, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: _height * 0.016,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.isEdit ? _height * 0.9 : _height,
      decoration: widget.isEdit
          ? BoxDecoration(
              color: themeOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                // bottomLeft: Radius.circular(30.0),
                // bottomRight: Radius.circular(30.0),
              ),
            )
          : null,
      color: widget.isEdit ? null : themeOrange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.isEdit
              ? Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 8, 0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                        bottomLeft: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0),
                      ),
                      child: SizedBox(
                        width: 65.0,
                        height: 6.0,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                      )
                      // child: Container(
                      //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
                      //   color: Colors.black,
                      // )
                      ),
                )
              : Container(),
          SizedBox(
            height: widget.isEdit ? (_height * 0.9) * 0.13 : _height * 0.13,
          ),
          _getHeader(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: PageView(
                onPageChanged: (index) {
                  widget.valueChanged(index);
                },
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                pageSnapping: true,
                children: <Widget>[
                  ChangeColor(
                    displayName: widget.userName[0],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                    //_height * 0.20
                    offset: _currentindex,
                    index: 0,
                    linearGradient: listColors[0],
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 1,
                    linearGradient: listColors[1],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    index: 2,
                    offset: _currentindex,
                    linearGradient: listColors[2],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 3,
                    linearGradient: listColors[3],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 4,
                    linearGradient: listColors[4],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 5,
                    linearGradient: listColors[5],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 6,
                    linearGradient: listColors[6],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 7,
                    linearGradient: listColors[7],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 8,
                    linearGradient: listColors[8],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                  ChangeColor(
                    displayName: widget.userName[0],
                    offset: _currentindex,
                    index: 9,
                    linearGradient: listColors[9],
                    onTap: () {
                      widget.valueChanged(_pageController.page.round());
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: _height * 0.106, horizontal: _width * 0.15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              height: _height * 0.06,
              width: _width * 0.75,
              child: RaisedButton(
                hoverElevation: 0,
                highlightColor: Colors.white,
                highlightElevation: 0,
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  if (widget.isEdit) {
                    print('1called');
                    databaseMethods
                        .updateUserProfileColor(user.userID, _currentindex)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  } else {
                    print('2called');
                    // initialize the tags
                    userTagProvider.changeTagCollege([]);
                    userTagProvider.changeTagsStudyHabits([]);
                    userTagProvider.changeTagInterest([]);
                    userTagProvider.changeTagLanguage([]);
                    userTagProvider.addTagsToContact(context);
                    databaseMethods
                        .updateUserProfileColor(user.userID, _currentindex)
                        .then((value) {
                      widget.pageController.animateToPage(2,
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeInCubic);
                    });
                  }
                  // databaseMethods
                  //     .updateUserProfileColor(user.userID, _currentindex)
                  //     .then((value) {
                  //   widget.isEdit
                  //       ? Navigator.pop(context)
                  //       : widget.pageController.animateToPage(2,
                  //           duration: Duration(milliseconds: 800),
                  //           curve: Curves.easeInCubic);
                  // });
                  print('color num saved');
                },
                child: Text(
                  'Continue',
                  style: simpleTextSansStyleBold(
                      listColors[_currentindex.toInt()].colors[1], 16),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 20.0),
          //   child: TweenAnimationBuilder(
          //     tween: Tween(begin: 0.0, end: 0.8),
          //     duration: Duration(milliseconds: 1000),
          //     curve: Curves.elasticOut,
          //     builder: (context, value, child) {
          //       return Transform.scale(
          //         scale: value,
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 140, vertical: 15),
          //           child: Row(
          //             children: <Widget>[
          //               Expanded(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(40),
          //                     boxShadow: [
          //                       BoxShadow(
          //                           color: Colors.black38,
          //                           offset: Offset(0, 10),
          //                           blurRadius: 15),
          //                     ],
          //                   ),
          //                   height: _height * 0.075,
          //                   child: RaisedButton(
          //                     hoverColor: Colors.white,
          //                     hoverElevation: 0,
          //                     highlightColor: Colors.white,
          //                     highlightElevation: 0,
          //                     elevation: 0,
          //                     color: Colors.white,
          //                     shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(40)),
          //                     child: Text(
          //                       'Next',
          //                       style: TextStyle(
          //                           color: listColors[_currentindex.round()]
          //                               .colors[1],
          //                           fontSize: 20),
          //                     ),
          //                     onPressed: () {
          //                       databaseMethods.updateUserProfileColor(
          //                           user.userID, _currentindex);
          //                       print('color num saved');
          //                       widget.pageController.animateToPage(3,
          //                           duration: Duration(milliseconds: 800),
          //                           curve: Curves.easeInCubic);
          //                     },
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          // );
          // },
          // ),
          // ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
