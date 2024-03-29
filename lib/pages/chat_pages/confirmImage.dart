import 'dart:io';
import 'package:app_test/models/user.dart';
// import 'package:app_test/pages/initialPage/tagSelectingStepper.dart';
// import 'package:app_test/pages/initialPage/third_page.dart';
import 'package:app_test/services/database.dart';
// import 'package:app_test/services/wrapper.dart';
// import 'package:app_test/pages/edit_pages/editNameModel.dart';
// import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/auth.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';

class ConfirmImage extends StatefulWidget {
  final File imageFile;

  ConfirmImage({this.imageFile});

  @override
  _ConfirmImageState createState() => _ConfirmImageState();
}

class _ConfirmImageState extends State<ConfirmImage> {
  AuthMethods authMethods = new AuthMethods();

  UserData currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = null;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;
    final userdata = Provider.of<UserData>(context);
    final databaseMethods = DatabaseMethods();

    databaseMethods.getUserDetailsByID(userdata.userID).then((value) {
      setState(() {
        currentUser = value;
      });
    });

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF7D5C5),
      body: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFF7D5C5),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.navigate_before,
                    color: themeOrange,
                    size: 38,
                  )),
            ),
            body: Container(
                color: Color(0xFFF7D5C5),
                height: mediaQuery.height,
                width: sidebarSize,
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: menuContainerHeight / 3),
                        child: Image.file(widget.imageFile),
                      ),
                      Positioned(
                        bottom: 29,
                        right: 15,
                        child: MaterialButton(
                          onPressed: () {},
                          color: Color(0xFFFF813C),
                          textColor: Colors.white,
                          child: Icon(
                            Icons.send,
                            size: 24,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
