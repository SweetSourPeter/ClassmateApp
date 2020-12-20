import 'package:app_test/models/user.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/pages/contact_pages/FriendsScreen.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/pages/explore_pages/seatNotifyDashboard.dart';
import 'package:app_test/pages/edit_pages/EditNameModal.dart';
import 'package:app_test/pages/explore_pages/aboutTheApp.dart';
import 'package:app_test/pages/explore_pages/seatNotifyAdd.dart';
import 'package:app_test/widgets/course_menu.dart';
import 'package:app_test/widgets/favorite_contacts.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/constant.dart';

class EditHomePage extends StatefulWidget {
  final Function(int) getSize;
  final UserData userdata;

  EditHomePage({this.getSize, this.userdata});

  @override
  _EditHomePageState createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: orengeColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 38,
            )),
      ),
      body: Container(
        color: riceColor,
        height: mediaQuery.height,
        width: sidebarSize,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              //key: widget.key,
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              height: menuContainerHeight,
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  ButtonLink(
                    text: "NAME",
                    editText: widget.userdata.userName,
                    iconData: Icons.edit,
                    textSize: widget.getSize(3),
                    height: (menuContainerHeight) / 8,
                    isEdit: true,
                    onTap: () {
                      showBottomPopSheet(
                          context,
                          EditNameModal(
                            userName: widget.userdata.userName
                          ));
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
