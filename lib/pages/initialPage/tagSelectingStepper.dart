import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/change_color.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:ui';

class TagSelecting extends StatefulWidget {
  final PageController pageController;
  final Color buttonColor;
  final bool isEdit;
  final List currentTags;
  const TagSelecting({
    Key key,
    this.pageController,
    this.buttonColor,
    this.isEdit = false,
    this.currentTags,
  }) : super(key: key);
  // TagSelecting({Key key}) : super(key: key);

  @override
  _TagSelectingState createState() => _TagSelectingState();
}

class _TagSelectingState extends State<TagSelecting> {
  double _scaleHolder = 0;
  List _items = [];
  int choosenTagNumb = 0;
  List allTags = [];
  double _fontSize = 14;
  bool blureShow;
  //for category selector
  int selectedIndex = 0;
  final List<String> categories = [
    'college', //college
    'Study habits',
    'Interest',
    'Languages',
  ];
  @override
  void initState() {
    super.initState();
    print('tags page called');
    _items = college;
    if (widget.isEdit && widget.currentTags != null) {
      allTags = widget.currentTags;
      setState(() {
        blureShow = widget.isEdit;
      });
    }
    blureShow = widget.isEdit;
  }

  Future<void> changepRroviderList(UserTagsProvider userTagProvider) async {
    print('selected index is =----------- $selectedIndex');
    switch (selectedIndex) {
      case 0:
        // userTagProvider.changeTagCollege(
        //     (userTagProvider.college ?? [] + _getAllItem(tagStateKeyList[0]))
        //         .toSet()
        //         .toList());
        print('provider change called');
        await userTagProvider.changeTagCollege(_getAllItem(tagStateKeyList[0]));
        // return college;
        print('done');
        break;
      case 1:
        // userTagProvider.changeTagsStudyHabits((userTagProvider.strudyHabits ??
        //         [] + _getAllItem(tagStateKeyList[1]))
        //     .toSet()
        //     .toList());
        await userTagProvider
            .changeTagsStudyHabits(_getAllItem(tagStateKeyList[1]));
        // return strudyHabits;

        break;
      case 2:
        // userTagProvider.changeTagInterest(
        //     (userTagProvider.interest ?? [] + _getAllItem(tagStateKeyList[2]))
        //         .toSet()
        //         .toList());
        await userTagProvider
            .changeTagInterest(_getAllItem(tagStateKeyList[2]));
        // return Interest;

        break;
      case 3:
        // userTagProvider.changeTagLanguage(
        //     (userTagProvider.language ?? [] + _getAllItem(tagStateKeyList[3]))
        //         .toSet()
        //         .toList());
        await userTagProvider
            .changeTagLanguage(_getAllItem(tagStateKeyList[3]));
        // return language;
        break;
      default:
        break;
      // return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userTags = Provider.of<UserTags>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = maxWidth;
    final userTagProvider = Provider.of<UserTagsProvider>(context);
    Color submitButtonColor = widget.buttonColor;
    Color submitButtonTextColor = Colors.white;
    String submitButtonString = 'Next';

    Size mediaQuery = MediaQuery.of(context).size;
    if (allTags.length >= 5) {
      submitButtonColor = widget.buttonColor;
      submitButtonTextColor = Colors.white;
      submitButtonString = 'Complete';
    }
    // var allTags = (userTags != null)
    //     ? [
    //         userTags.college,
    //         userTags.interest,
    //         userTags.language,
    //         userTags.strudyHabits
    //       ].expand((x) => x).toList()
    //     : [];
    // final List<Function> providerFunctions = [
    //   userTagProvider.changeTagCollege(_getAllItem(tagStateKeyList[0])),
    // ];

    return SafeArea(
      child: Container(
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
        height: widget.isEdit ? (mediaQuery.height * 0.9) : mediaQuery.height,
        color: widget.isEdit ? null : themeOrange,
        child: Stack(
          children: [
            Column(
              children: [
                widget.isEdit
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(10, 25, 8, 0),
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
                                decoration:
                                    const BoxDecoration(color: Colors.white),
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
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height:
                      widget.isEdit ? (_height * 0.9) * 0.56 : _height * 0.56,
                  color: themeOrange,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height:
                              widget.isEdit ? _height * 0.05 : _height * 0.13,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35, top: 0, bottom: 0, right: 35),
                          child: Container(
                            child: Text(
                              'Choose the tags that best describe you!',
                              textAlign: TextAlign.center,
                              style: largeTitleTextStyleBold(Colors.white, 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mediaQuery.height * 0.012,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 35, top: 0, bottom: 0, right: 35),
                            child: Text(
                              'We match you with others who have similar tags',
                              textAlign: TextAlign.center,
                              style: simpleTextSansStyleBold(
                                  Color(0xFFF7D5C5), 14),
                            )),
                        SizedBox(
                          height: mediaQuery.height * 0.044,
                        ),
                        categorySelector(
                            widget.buttonColor, mediaQuery, userTagProvider),
                        Container(
                          width: _width,
                          color: Color(0xFFFF9B6B).withOpacity(1),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: buildBottomTags(
                                      widget.buttonColor,
                                      _items,
                                      tagStateKeyList[selectedIndex],
                                      userTagProvider),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RaisedGradientButton(
                //   width: 200,
                //   height: 40,
                //   gradient: LinearGradient(
                //     colors: <Color>[orengeColor, orengeColor],
                //   ),
                //   onPressed: () {
                //     //TODO send data to database
                //     userTagProvider.addTagsToContact(context);
                //   },
                //   //之后需要根据friendsProvider改这部分display
                //   //TODO
                //   child: Text(
                //     'Complete',
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: Colors.white,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: _width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   height: 10,
                          //   color: Color(0xDA6D39).withOpacity(1),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 21, top: mediaQuery.height * 0.025),
                            child: Text(
                              'Chosen tags',
                              style: largeTitleTextStyleBold(Colors.white, 16),
                            ),
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 21, bottom: 30),
                              child: buildTopTags(
                                widget.buttonColor,
                                allTags,
                                tagStateKeyList[4],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: widget.isEdit
                        ? (_height * 0.9) * 0.06
                        : _height * 0.094,
                    left: _width * 0.15,
                    right: _width * 0.15,
                  ),
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
                      color: (allTags.length >= 5)
                          ? Colors.white
                          : Color(0xFFFF9B6B).withOpacity(1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () async {
                        if (widget.isEdit) {
                          await userTagProvider.addTagsToContact(context);
                          Navigator.pop(context);
                        } else if (allTags.length >= 5) {
                          await userTagProvider.addTagsToContact(context);
                          widget.pageController.animateToPage(4,
                              duration: Duration(milliseconds: 800),
                              curve: Curves.easeInCubic);
                        } else {
                          // selectedIndex++;
                          // changeCategory(selectedIndex);
                        }
                      },
                      child: AutoSizeText(
                        allTags.length >= 5
                            ? (widget.isEdit ? 'Save' : 'Complete')
                            : '${allTags.length.toString()} / 5',
                        style: simpleTextSansStyleBold(
                            (allTags.length >= 5) ? themeOrange : Colors.white,
                            16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  blureShow = false;
                  allTags = [];
                });
              },
              child: Center(
                child: new ClipRect(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 0.70, sigmaY: 0.70),
                    child: new Container(
                      width: blureShow ? _width : 0,
                      height: blureShow ? _height * 0.9 : 0,
                      decoration: new BoxDecoration(
                          color: Colors.grey.withOpacity(0.001)),
                      child: new Center(
                          child: AutoSizeText(
                        'Tap to edit',
                        style: largeTitleTextStyle(Colors.grey[700], 38),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeCategory(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        // userTagProvider
        //     .changeTagCollege(_getAllItem(tagStateKeyList[0]));
        _items = college;
      } else if (index == 1) {
        // userTagProvider.changeTagInterest(_getAllItem(tagStateKeyList[1]));
        _items = strudyHabits;
      } else if (index == 2) {
        // userTagProvider
        //     .changeTagLanguage(_getAllItem(tagStateKeyList[2]));
        _items = interest;
      } else if (index == 3) {
        // userTagProvider
        //     .changeTagsStudyHabits(_getAllItem(tagStateKeyList[3]));
        _items = language;
      } else {
        _items = [];
      }
    });
  }

  Widget categorySelector(Color color, Size mediaQuery, userTagProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xFFFF9B6B).withOpacity(1),
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],*/
      ),
      height: widget.isEdit
          ? (mediaQuery.height * 0.9) * 0.07
          : mediaQuery.height * 0.07,
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                changeCategory(index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: maxWidth * 0.04,
                  vertical: widget.isEdit
                      ? (mediaQuery.height * 0.9) * 0.0246
                      : mediaQuery.height * 0.0246,
                ),
                child: AutoSizeText(
                  categories[index],
                  style: TextStyle(
                    decoration: index == selectedIndex
                        ? TextDecoration.underline
                        : null,
                    decorationColor: widget.buttonColor,
                    decorationThickness: 3,
                    decorationStyle: TextDecorationStyle.solid,
                    color:
                        index == selectedIndex ? Colors.white : Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Tags buildTopTags(
    Color tagColor,
    List tagLists,
    GlobalKey<TagsState> tagStateKey,
  ) {
    return Tags(
      horizontalScroll: false,
      alignment: WrapAlignment.start,
      key: tagStateKey,
      spacing: 15,
      runSpacing: 18,
      // textField: TagsTextField(
      //   textStyle: TextStyle(fontSize: _fontSize),
      //   constraintSuggestion: true,
      //   suggestions: [],
      //   onSubmitted: (String str) {
      //     // Add item to the data source.
      //     setState(() {
      //       // required
      //       tagLists.add(str);
      //     });
      //   },
      // ),
      itemCount: tagLists.length, // required
      itemBuilder: (int index) {
        final item = tagLists[index];
        return ItemTags(
          customData: false,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 6.0,
          ),
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item,
          activeColor: tagColor,
          textColor: Colors.white,
          color: tagColor,
          // active: item.active,
          // customData: item.customData,
          textStyle: TextStyle(
            fontSize: _fontSize,
            // color: Colors.white,
          ),
          combine: ItemTagsCombine.withTextBefore,
          removeButton: ItemTagsRemoveButton(
            backgroundColor: Colors.transparent,
            size: 14,
            onRemoved: () {
              // Remove the item from the data source.
              setState(() {
                // required
                choosenTagNumb--;
                tagLists.removeAt(index);
              });
              //required
              return true;
            },
          ), // OR null,
          onPressed: (item) {
            setState(() {
              // required
              choosenTagNumb--;
              tagLists.removeAt(index);
            });
          },
          onLongPressed: (item) => print(item),
        );
      },
    );
  }

  Tags buildBottomTags(Color tagColor, List tagLists,
      GlobalKey<TagsState> tagStateKey, UserTagsProvider userTagProvider) {
    return Tags(
      alignment: WrapAlignment.start,
      key: tagStateKey,
      spacing: 15,
      runSpacing: 18,
      itemCount: tagLists.length, // required
      itemBuilder: (int index) {
        final item = tagLists[index];
        return ItemTags(
          customData: false,
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          color: tagColor,
          key: Key(index.toString()),
          index: index, // required
          title: item,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 6.0,
          ),
          border: Border.all(color: tagColor),
          activeColor: Colors.white,
          textActiveColor: tagColor,
          // active: item.active,
          // customData: item.customData,
          textStyle: TextStyle(fontSize: _fontSize, color: Colors.white),
          textColor: Colors.white,

          combine: ItemTagsCombine.withTextBefore,
          onPressed: (item) async {
            if (!allTags.contains(item.title)) {
              await changepRroviderList(userTagProvider);

              setState(() {
                allTags.add(item.title);
              });
            } else {
              setState(() {
                allTags.remove(item.title);
              });
            }
          },
        );
      },
    );
  }

  final List<GlobalKey<TagsState>> tagStateKeyList = [
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
  ];

// Allows you to get a list of all the ItemTags
  List _getAllItem(GlobalKey<TagsState> tagStateKey) {
    List<Item> lst = tagStateKey.currentState?.getAllItem;
    List<String> lst2 = [];
    if (lst != null)
      lst.where((a) => a.active == false).forEach((a) => lst2.add(a.title));
    return lst2;
  }
}
