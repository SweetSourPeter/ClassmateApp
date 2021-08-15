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

  AtPeople({
    this.courseId,
  });

  @override
  _AtPeopleState createState() => _AtPeopleState();
}

class _AtPeopleState extends State<AtPeople> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isSearching;
  TextEditingController searchTextEditingController = TextEditingController();
  Stream memberStream;

  @override
  void initState() {
    super.initState();
    isSearching = false;
    databaseMethods.getGroupChatMembers(widget.courseId).then((value) {
      setState(() {
        memberStream = value;
      });
    });
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
    return StreamBuilder(
      stream: memberStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double _height = MediaQuery.of(context).size.height;
          double _width = MediaQuery.of(context).size.width;
          double sidebarSize = _width * 0.05;
          final children = <Widget>[];

          children.add(Container(
            padding: EdgeInsets.only(left: sidebarSize*1.2, top: sidebarSize*0.8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFFF7E40),
                  radius: sidebarSize,
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
          ));

          for (var i = 0; i < snapshot.data.docs.length; i++) {
              children.add(
                  MemberTile(
                    snapshot.data.docs[i].data()['userID'],
                    1.0
                  )
              );
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
      },
    );
  }
}

class MemberTile extends StatelessWidget {
  final String memberName;
  final double memberProfileColor;

  MemberTile(
      this.memberName,
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
          Navigator.pop(context, memberName);
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: listProfileColor[memberProfileColor.toInt()],
              radius: sidebarSize,
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