import 'package:app_test/models/constant.dart';
import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AtPeople extends StatefulWidget {
  final String courseId;
  final List<dynamic> members;

  AtPeople({
    this.courseId,
    this.members
  });

  @override
  _AtPeopleState createState() => _AtPeopleState();
}

class _AtPeopleState extends State<AtPeople> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isSearching;
  TextEditingController searchTextEditingController = TextEditingController();
  // Stream memberStream;
  List<dynamic> memberInfo;

  @override
  void initState() {
    super.initState();
    isSearching = false;
    // print(widget.members);
    memberInfo = widget.members;

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = _width * 0.05;

    return SafeArea(
      child: Container(
        height: _height*0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            // bottomLeft: Radius.circular(30.0),
            // bottomRight: Radius.circular(30.0),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:sidebarSize*0.55),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/arrow-down.png',
                        height: 19.97,
                        width: 20.84,
                      ),
                      // iconSize: 30.0,
                      color: const Color(0xFFFF7E40),
                      onPressed: () {
                        // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                        // databaseMethods.setUnreadGroupChatNumberToZero(
                        //     widget.courseId, currentUser.userID);
                        Navigator.of(context).pop();
                    }),
                  ),
                  Center(
                    child: Text(
                      'Choose Member to @',
                      style: GoogleFonts.montserrat(
                        fontWeight:FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: sidebarSize*2.8,)
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: sidebarSize, right: sidebarSize),
                height: 50,
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
                    fillColor: Color(0xFFF9F6F1),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF646464),
                    ),
                    suffixIcon:
                    searchTextEditingController.text.isEmpty
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
                      borderSide:
                      BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.transparent),
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
              Expanded(
                child: memberList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget memberList() {
    if (memberInfo != null) {
      double _height = MediaQuery.of(context).size.height;
      double _width = MediaQuery.of(context).size.width;
      double sidebarSize = _width * 0.05;
      final children = <Widget>[];

      children.add(Container(
        padding: EdgeInsets.only(left: sidebarSize*1.2, top: sidebarSize*0.8),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, ['Everyone', 'Everyone']);
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Image.asset(
                'assets/images/everyone.png',
                width: 2*sidebarSize,
                height: 2*sidebarSize,
              ),
              Container(
                padding: EdgeInsets.only(left: sidebarSize*0.9),
                child: Text(
                  'Everyone',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                  ),
                ),
              ),
            ],
          ),
        ),
      ));

      String prev = '';
      String current = '';

      for (var i = 0; i < memberInfo.length; i++) {
        current = memberInfo[i][0][0].toString().toUpperCase();
        if (current != prev) {
          children.add(
              Padding(
                padding: EdgeInsets.only(top: sidebarSize*0.6),
                child: Container(
                  color: Color(0xffF9F6F1),
                  child: Padding(
                    padding: EdgeInsets.only(left: sidebarSize*1.7),
                    child: Text(
                      current,
                      style: GoogleFonts.montserrat(
                          color: Color(0xffFF7E40),
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              )
          );
        }
        children.add(
            MemberTile(
                memberInfo[i][0],
                memberInfo[i][1],
                memberInfo[i][2]
            )
        );
        prev = memberInfo[i][0][0].toString().toUpperCase();
      }

      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: children.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return children[index];
          });
    }
    return Container();
  }
}

class MemberTile extends StatelessWidget {
  final String memberName;
  final String memberId;
  final double memberProfileColor;

  MemberTile(
      this.memberName,
      this.memberId,
      this.memberProfileColor);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = _width * 0.05;

    return Container(
      padding: EdgeInsets.only(left: sidebarSize*1.2, top: sidebarSize*0.8),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, [memberName, memberId]);
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: listProfileColor[memberProfileColor.toInt()],
              radius: sidebarSize,
              child: Container(
                child: Text(
                  memberName.split(' ').length >= 2
                      ? memberName.split(' ')[0][0].toUpperCase() +
                      memberName
                          .split(' ')[
                      memberName.split(' ').length - 1][0]
                          .toUpperCase()
                      : memberName[0].toUpperCase(),
                  style: GoogleFonts.montserrat(
                      fontSize:
                      memberName.split(' ').length >= 2 ? 14 : 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: sidebarSize*0.9),
              child: Text(
                memberName,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 14
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}