import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class TagSelecting extends StatefulWidget {
  TagSelecting({Key key}) : super(key: key);

  @override
  _TagSelectingState createState() => _TagSelectingState();
}

class _TagSelectingState extends State<TagSelecting> {
  List _items = [];

  List allTags = [];
  double _fontSize = 14;
  //for category selector
  int selectedIndex = 0;

  final List<String> categories = [
    'College',
    'GPA',
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
        userTagProvider.changeTagGPA(_getAllItem(tagStateKeyList[1]));
        // return gpa;
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
    final userTagProvider = Provider.of<UserTagsProvider>(context);

    // var allTags = (userTags != null)
    //     ? [
    //         userTags.college,
    //         userTags.gpa,
    //         userTags.language,
    //         userTags.strudyHabits
    //       ].expand((x) => x).toList()
    //     : [];
    Size mediaQuery = MediaQuery.of(context).size;
    // final List<Function> providerFunctions = [
    //   userTagProvider.changeTagCollege(_getAllItem(tagStateKeyList[0])),
    // ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: mediaQuery.height * 0.45,
            color: orengeColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: mediaQuery.height * 0.06,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: mediaQuery.width * 0.10, top: 0, bottom: 0),
                      child: Container(
                        // color: orengeColor,
                        child: Text(
                          'Choose your tags',
                          textAlign: TextAlign.left,
                          style: largeTitleTextStyle(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: mediaQuery.width * 0.10, top: 0, bottom: 0),
                        child: Text(
                          'Tags help us to match you with who have similar background, study habits and hobbies.',
                          style: simpleTextStyle(),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: mediaQuery.width * 0.10, bottom: 30),
                      child: buildTopTags(allTags, tagStateKeyList[4])),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categorySelector(mediaQuery, userTagProvider),
                    SizedBox(
                      height: 20,
                    ),
                    buildBottomTags(_items, tagStateKeyList[selectedIndex],
                        userTagProvider),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedGradientButton(
                      width: 200,
                      height: 40,
                      gradient: LinearGradient(
                        colors: <Color>[orengeColor, orengeColor],
                      ),
                      onPressed: () {
                        //TODO send data to database
                        print('object');
                        userTagProvider.addTagsToContact(context);
                      },
                      //之后需要根据friendsProvider改这部分display
                      //TODO
                      child: Text(
                        'Complete',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categorySelector(Size mediaQuery, userTagProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      height: mediaQuery.height * 0.1,
      // color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                if (index == 0) {
                  // userTagProvider
                  //     .changeTagCollege(_getAllItem(tagStateKeyList[0]));
                  _items = college;
                } else if (index == 1) {
                  // userTagProvider.changeTagGPA(_getAllItem(tagStateKeyList[1]));
                  _items = gpa;
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
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 20.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  decoration:
                      index == selectedIndex ? TextDecoration.underline : null,
                  decorationColor: Colors.deepOrange[200],
                  decorationThickness: 3,
                  decorationStyle: TextDecorationStyle.solid,
                  color: index == selectedIndex ? Colors.black : Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Tags buildTopTags(
    List tagLists,
    GlobalKey<TagsState> tagStateKey,
  ) {
    return Tags(
      alignment: WrapAlignment.start,
      key: tagStateKey,
      spacing: 20,
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
            vertical: 8.0,
          ),
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item,
          activeColor: Colors.deepOrange,
          textColor: Colors.white,
          color: Colors.deepOrange,
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
                tagLists.removeAt(index);
              });
              //required
              return true;
            },
          ), // OR null,
          onPressed: (item) {
            setState(() {
              // required
              tagLists.removeAt(index);
            });
          },
          onLongPressed: (item) => print(item),
        );
      },
    );
  }

  Tags buildBottomTags(List tagLists, GlobalKey<TagsState> tagStateKey,
      UserTagsProvider userTagProvider) {
    return Tags(
      alignment: WrapAlignment.start,
      key: tagStateKey,
      spacing: 20,
      runSpacing: 18,
      itemCount: tagLists.length, // required
      itemBuilder: (int index) {
        final item = tagLists[index];
        return ItemTags(
          customData: false,
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          color: Colors.deepOrange,
          key: Key(index.toString()),
          index: index, // required
          title: item,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          border: Border.all(color: Colors.deepOrange),
          activeColor: Colors.white,
          textActiveColor: Colors.deepOrange,
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
