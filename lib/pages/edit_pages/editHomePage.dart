import 'package:app_test/models/user.dart';
import 'package:app_test/pages/initialPage/tagSelectingStepper.dart';
import 'package:app_test/pages/initialPage/third_page.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/pages/edit_pages/editNameModel.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/auth.dart';
import 'package:provider/provider.dart';
import '../../models/constant.dart';

class EditHomePage extends StatefulWidget {
  @override
  _EditHomePageState createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  AuthMethods authMethods = new AuthMethods();

  String nickName;
  @override
  void initState() {
    super.initState();
    nickName = 'loading';
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 1.0;
    double menuContainerHeight = mediaQuery.height / 2;
    final userdata = Provider.of<UserData>(context);
    final databaseMehods = DatabaseMethods();

    databaseMehods.getUserDetailsByID(userdata.userID).then((value) {
      setState(() {
        nickName = value.userName;
      });
    });

    // TODO: implement build
    return Scaffold(
      backgroundColor: riceColor,
      body: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Setting',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: riceColor,
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
              color: riceColor,
              height: mediaQuery.height,
              width: sidebarSize,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      //key: widget.key,
                      margin: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      height: mediaQuery.height / 1.25,
                      child: Column(
                        children: <Widget>[
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Name",
                            editText: nickName,
                            iconData: Icons.edit,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                  context,
                                  EditNameModel(
                                      userName: userdata.userName,
                                      userId: userdata.userID));
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Tags",
                            editText: 'College, Interest...',
                            iconData: Icons.edit,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                  context,
                                  TagSelecting(
                                      buttonColor: userdata.profileColor == null
                                          ? listProfileColor[0]
                                          : listProfileColor[
                                              userdata.profileColor.toInt()],
                                      pageController:
                                          PageController(initialPage: 0),
                                      isEdit: true));
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            text: "Avatar",
                            editText: '',
                            iconData: Icons.edit,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isAvatar: true,
                            user: userdata,
                            isEdit: true,
                            onTap: () {
                              showBottomPopSheet(
                                context,
                                ThirdPage(
                                    // buttonColor: Colors.amber,
                                    userName: userdata.userName,
                                    initialIndex: userdata.profileColor == null
                                        ? 0
                                        : userdata.profileColor.toInt(),
                                    pageController:
                                        PageController(initialPage: 3),
                                    isEdit: true,
                                    valueChanged: (index) => {}),
                              );
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          ButtonLink(
                            onTap: () {
                              authMethods.signOut().then((value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper(false)),
                                );
                              });
                            },
                            text: "Log Out",
                            iconData: Icons.login,
                            textSize: 14,
                            height: (menuContainerHeight) / 8,
                            isSimple: true,
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: dividerColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
