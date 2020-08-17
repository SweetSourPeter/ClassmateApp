import 'package:app_test/models/constant.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  // bool showCancel = false;
  bool haveUserSearched = false;
  // FocusNode _focus = new FocusNode();
  QuerySnapshot searchSnapshot;
  DatabaseMehods databaseMehods = new DatabaseMehods();
  // @override
  // void initState() {
  //   super.initState();
  //   _focus.addListener(_onFocusChange);
  // }

  @override
  void initState() {
    // TODO: implement initState
    initiateSearch();
    super.initState();
  }

  clearSearchTextInput() {
    searchTextEditingController.clear();
  }

  TextEditingController searchTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        setState(() {
          // showCancel = true;
        });
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      onPanUpdate: (details) {
        if (details.delta.dx > 4) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: orengeColor,
            title: Text("Find User"),
          ),
          body: buildContainerBody()),
    );
  }

  Container buildContainerBody() {
    return Container(
      color: builtyPinkColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Focus(
                    // onFocusChange: (focus) => showCanclChange(),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        initiateSearch();
                      },
                      // focusNode: _focus,
                      controller: searchTextEditingController,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        // prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Search User with email...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          // borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey), // KEY PROP
                      ),
                    ),
                  )),
                  // showCancel
                  searchTextEditingController.text.isEmpty
                      ? Container()
                      :
                      // Container(
                      // height: 40,
                      // width: 40,
                      // padding: EdgeInsets.only(left: kDefaultPadding),
                      // child:
                      IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            // initiateSearch();
                            clearSearchTextInput();
                          })
                  // )
                  // : Container(),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }

  bool searchBegain = false;
  initiateSearch() async {
    var temp =
        await databaseMehods.getUsersByEmail(searchTextEditingController.text);
    // if (temp == null) return;
    setState(() {
      searchSnapshot = temp;
      if (searchSnapshot.documents != null) {
        if ((searchSnapshot.documents.length >= 1) &&
            (searchTextEditingController.text.isNotEmpty)) {
          searchBegain = true;
        }
      }

      print('aaaa');
      print(searchSnapshot.toString() + 'aaaaaaaaaaa');
      print(searchSnapshot.documents.length);
      // print(searchTextEditingController.text);
    });
  }

  Widget searchList() {
    return searchBegain && searchTextEditingController.text.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true, //when you have listview in column
            itemBuilder: (context, index) {
              return SearchTile(
                userName:
                    // "peter",
                    searchSnapshot.documents[index].data['userName'],
                userEmail:
                    // "731957665@qq.com",
                    searchSnapshot.documents[index].data['email'],
              );
            })
        : Container(
            // padding: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
            // child: Row(
            //   children: <Widget>[
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Text(
            //           "Please enter the correct Email",
            //           style: simpleTextStyle(),
            //         ),
            //       ],
            //     ),
            //     Spacer(),
            //   ],
            // ),
            );
  }
}

//searchTile for searchList

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName ?? '',
                style: simpleTextStyle(),
              ),
              Text(
                userEmail ?? '',
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
