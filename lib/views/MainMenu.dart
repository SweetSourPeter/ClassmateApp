import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool _searchToggle = false;
  TextEditingController searchUserByEmailTextEditingController =
      new TextEditingController();

  void showToast() {
    setState(() {
      _searchToggle = !_searchToggle;
      print(_searchToggle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_searchToggle) showToast();
      },
      child: Scaffold(backgroundColor: Colors.white, appBar: buildAppBar()),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        iconSize: 35,
        color: darkBlueColor,
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: Icon(Icons.menu),
        onPressed: () {
          //add
        },
      ),
      title: Visibility(
        // visible: searchToggle? true:false,
        visible: _searchToggle,
        child: Expanded(
          child: Container(
            // width: 200,
            child: TextField(
              controller: searchUserByEmailTextEditingController,
              autofocus: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                // prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search User ...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: Colors.grey), // KEY PROP
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: !_searchToggle,
          child: IconButton(
            iconSize: 38,
            color: darkBlueColor,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            icon: Icon(Icons.search),
            onPressed: (showToast),
            // {
            //   // ignore: unnecessary_statements
            //   showToast;
            //   // searchToggle = !searchToggle;
            //   print(_searchToggle);
            //   //do something
            // },
          ),
        )
      ],
    );
  }
}
