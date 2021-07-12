import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/database.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/pages/contact_pages/userInfo/friendProfile.dart';
import "package:collection/collection.dart";

class ChooseGroupLeader extends StatefulWidget {
  final String courseId;
  final String myEmail;
  final String myName;
  final List<List<dynamic>> groupMembers;
  final String adminName;
  final String adminId;
  ChooseGroupLeader(
      {this.courseId,
      this.myEmail,
      this.myName,
      this.groupMembers,
      this.adminName,
      this.adminId});
  @override
  _ChooseGroupLeaderState createState() => _ChooseGroupLeaderState();
}

class _ChooseGroupLeaderState extends State<ChooseGroupLeader> {
  bool showTextKeyboard;
  TextEditingController searchTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int numberOfMembers = 0;
  String courseName;
  String courseSection;
  String courseTerm;
  List<List<dynamic>> members;
  String adminName;
  String adminId;
  bool isSearching;
  bool onSelected;
  bool pressAttention = false;
  String newAdminId;

  @override
  void initState() {
    super.initState();
    adminId = widget.adminId;
    adminName = widget.adminName;
    members = widget.groupMembers;
    numberOfMembers = widget.groupMembers.length;
    showTextKeyboard = false;
    isSearching = false;
    onSelected = false;
    newAdminId = '';
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = _width * 0.05;
    double gridWidth = (_width - 40 - 4 * 15) / 10;

    List<Widget> _renderMemberInfo(radius) {
      return List.generate(numberOfMembers, (index) {
        final memberName = members[index][0];

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (members == null) Text(''),
              if (index == 0)
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: sidebarSize * 1.5),
                          child: Text(
                            members[index][0][0].toUpperCase(),
                            style: GoogleFonts.montserrat(
                                color: Color(0xffFF7E40),
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        )),
                  ),
                )
              else if (members[index - 1][0][0] != members[index][0][0])
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: sidebarSize * 1.5),
                          child: Text(
                            members[index][0][0].toUpperCase(),
                            style: GoogleFonts.montserrat(
                                color: Color(0xffFF7E40),
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        )),
                  ),
                ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    onSelected = true;
                    newAdminId = members[index][1];
                  });
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            // User profile photo
                            Container(
                              padding: EdgeInsets.only(
                                  left: sidebarSize * 1.0,
                                  top: ((index != 0) &&
                                          (members[index - 1][0][0] !=
                                              members[index][0][0]))
                                      ? sidebarSize * 0.4
                                      : 0),
                              child: CircleAvatar(
                                backgroundColor: listProfileColor[
                                    members != null
                                        ? members[index][2].toInt()
                                        : 1],
                                radius: sidebarSize * 1.2,
                                child: Container(
                                  child: Text(
                                    memberName.split(' ').length >= 2
                                        ? memberName
                                                .split(' ')[0][0]
                                                .toUpperCase() +
                                            memberName
                                                .split(' ')[memberName
                                                        .split(' ')
                                                        .length -
                                                    1][0]
                                                .toUpperCase()
                                        : memberName[0].toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            memberName.split(' ').length >= 2
                                                ? 14
                                                : 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),

                            // User name
                            Container(
                              padding: EdgeInsets.only(left: sidebarSize * 0.8),
                              child: Text(
                                members != null ? members[index][0] : '',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Check mark
                      members[index][1] == newAdminId
                          ? Container(
                              padding:
                                  EdgeInsets.only(right: sidebarSize * 1.8),
                              child: Text(
                                '√',
                                style: GoogleFonts.montserrat(
                                    color: Color(0xffbacFF7E40),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              if (index <= numberOfMembers - 2 &&
                  members[index + 1][0][0] == members[index][0][0])
                Container(
                  margin: EdgeInsets.only(
                      right: sidebarSize * 0.6,
                      left: sidebarSize * 3.3,
                      top: sidebarSize * 0.8),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              SizedBox(
                height: sidebarSize * 0.8,
              )
            ],
          ),
        );
      });
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: const Color(0xfff9f6f1),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  onSelected = false;
                  newAdminId = '';
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 73.68,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sidebarSize * 0.55),
                            child: Container(
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/images/arrow-back.png',
                                  height: 17.96,
                                  width: 10.26,
                                ),
                                // iconSize: 30.0,
                                color: const Color(0xFFFF7E40),
                                onPressed: () {
                                  // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                                  // databaseMethods.setUnreadGroupChatNumberToZero(
                                  //     widget.courseId, currentUser.userID);
                                  Navigator.of(context).pop();
                                },
                              ),
                              // iconSize: 30.0,
                            ),
                          ),
                          Container(
                            child: Text(
                              'Choose New Leader',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 40),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: sidebarSize,
                          right: sidebarSize,
                          top: sidebarSize * 0.8,
                          bottom: sidebarSize * 0.8),
                      height: sidebarSize * 4,
                      child: TextField(
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color(0xFFFF813C),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        controller: searchTextEditingController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF646464),
                          ),
                          suffixIcon: searchTextEditingController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Color(0xff646464),
                                    // size: 30,
                                  ),
                                  onPressed: () {
                                    // initiateSearch();
                                    searchTextEditingController.clear();
                                  }),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          contentPadding: EdgeInsets.only(left: 0),
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xffFF813C),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: _height * 0.6,
                      padding: EdgeInsets.only(top: 10),
                      child: Scrollbar(
                        thickness: 4,
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [..._renderMemberInfo(gridWidth - 5)],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ButtonTheme(
                        minWidth: _width * 0.85,
                        height: _height * 0.075,
                        child: RaisedButton(
                          child: Text('Confirm',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: onSelected
                                      ? Colors.white
                                      : Color(0xffC7C7C7))),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: onSelected ? Color(0xFFFF7E40) : Colors.white,
                          onPressed: () {
                            databaseMethods.updateAdminId(
                                widget.courseId, newAdminId);
                            Navigator.of(context).pop();
                          },
                          // color: pressAttention ? Colors.grey : Color(0xFFFF7E40),
                          // onPressed: () => setState(() => pressAttention = !pressAttention),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
