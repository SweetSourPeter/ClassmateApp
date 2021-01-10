import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/change_color.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TagSelecting extends StatefulWidget {
  final PageController pageController;
  final Color buttonColor;
  final bool isEdit;
  const TagSelecting(
      {Key key, this.pageController, this.buttonColor, this.isEdit})
      : super(key: key);
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
  //for category selector
  int selectedIndex = 0;

  final List<String> categories = [
    'College',
    'Interest',
    'Languages',
    'Study habits',
  ];
  @override
  void initState() {
    super.initState();
    _items = college;
    // if you store data on a local database (sqflite), then you could do something like this
  }

  void changepRroviderList(UserTagsProvider userTagProvider) {
    switch (selectedIndex) {
      case 0:
        userTagProvider.changeTagCollege(_getAllItem(tagStateKeyList[0]));
        // return college;
        break;
      case 1:
        userTagProvider.changeTagInterest(_getAllItem(tagStateKeyList[1]));
        // return Interest;
        break;
      case 2:
        userTagProvider.changeTagLanguage(_getAllItem(tagStateKeyList[2]));
        // return language;
        break;
      case 3:
        userTagProvider.changeTagsStudyHabits(_getAllItem(tagStateKeyList[3]));
        // return strudyHabits;
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
    double _width = MediaQuery.of(context).size.width;
    final userTagProvider = Provider.of<UserTagsProvider>(context);
    Color submitButtonColor = widget.buttonColor;
    Color submitButtonTextColor = Colors.white;
    String submitButtonString = 'Next';

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
    Size mediaQuery = MediaQuery.of(context).size;
    // final List<Function> providerFunctions = [
    //   userTagProvider.changeTagCollege(_getAllItem(tagStateKeyList[0])),
    // ];

    return Scaffold(
        backgroundColor: themeOrange,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: mediaQuery.height * 0.56,
                color: themeOrange,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery.height * 0.13,
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
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 35, top: 0, bottom: 0, right: 35),
                          child: Text(
                            'We match you with others who have similar tags',
                            textAlign: TextAlign.center,
                            style:
                                simpleTextSansStyleBold(Color(0xFFF7D5C5), 14),
                          )),
                      SizedBox(
                        height: 30,
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
                          padding: EdgeInsets.only(left: 21, top: 15),
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
                  bottom: 76.0,
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
                    onPressed: () {
                      if (allTags.length >= 5) {
                        userTagProvider.addTagsToContact(context);

                        widget.isEdit
                            ? Navigator.pop(context)
                            : widget.pageController.animateToPage(3,
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInCubic);
                      } else {
                        // selectedIndex++;
                        // changeCategory(selectedIndex);
                      }
                    },
                    child: AutoSizeText(
                      allTags.length >= 5
                          ? 'Complete'
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
        ));
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
        _items = interest;
      } else if (index == 2) {
        // userTagProvider
        //     .changeTagLanguage(_getAllItem(tagStateKeyList[2]));
        _items = language;
      } else if (index == 3) {
        // userTagProvider
        //     .changeTagsStudyHabits(_getAllItem(tagStateKeyList[3]));
        _items = strudyHabits;
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
      height: mediaQuery.height * 0.07,
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
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: Text(
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
          onPressed: (item) {
            print(item.title);
            setState(() {
              if (!allTags.contains(item.title)) {
                changepRroviderList(userTagProvider);
                allTags.add(item.title);
              } else {
                allTags.remove(item.title);
              }
            });
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
    print('get all item called');
    List<Item> lst = tagStateKey.currentState?.getAllItem;
    List<String> lst2 = [];
    if (lst != null)
      lst.where((a) => a.active == false).forEach((a) => lst2.add(a.title));
    print(lst2);
    return lst2;
  }
}
