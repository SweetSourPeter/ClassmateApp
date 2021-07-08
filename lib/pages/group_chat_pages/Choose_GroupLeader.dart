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
  ChooseGroupLeader({this.courseId, this.myEmail, this.myName, this.groupMembers, this.adminName, this.adminId});
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

  bool pressAttention = false;


  @override
  void initState() {
    adminId = widget.adminId;
    adminName = widget.adminName;
    members = widget.groupMembers;
    numberOfMembers = widget.groupMembers.length;
    showTextKeyboard = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    double gridWidth = (size - 40 - 4 * 15) / 10;

    List<Widget> _renderMemberInfo(radius) {
      return List.generate(numberOfMembers, (index) {
        final memberName = members[index][0];

        return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (members == null) Text(''),
                if (index == 0) Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: 40),
                          child: Text(
                              members[index][0][0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                  color: const Color(0xFFFF7E40), fontSize: 15),
                          ),
                        )
                    ),
                  ),
                )
                else if (members[index - 1][0][0] != members[index][0][0]) Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: 40),
                          child: Text(
                              members[index][0][0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                  color: const Color(0xFFFF7E40), fontSize: 15),
                          ),
                        )
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: ()=> {
                    databaseMethods.updateAdminName(widget.courseId,members[index][0]),
                    databaseMethods.updateAdminId(widget.courseId, members[index][1])
                  },
                  child: Container(
                    child: Row(
                      children: [
                        // User profile photo
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            backgroundColor: listProfileColor[
                            members != null ? members[index][2].toInt() : 1],
                            radius: 30,
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
                        ),

                    // User name
                        Container(
                          padding: EdgeInsets.only(left: 100),
                          child: Text(
                            members != null ? members[index][0] : '',
                            style: GoogleFonts.montserrat(
                                color: Colors.black, fontSize: 20),),
                        ),
                      ],
                    ),

                  ),
                ),

                const Divider(
                  height: 30,
                  thickness: 1,
                  // indent: 20,
                  // endIndent: 20,
                ),
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
              onTap: () => FocusScope.of(context).unfocus(),
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
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            // height: 17.96,
                            // width: 10.26,
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 35,
                              ),
                              // iconSize: 30.0,
                              color: const Color(0xFFFF7E40),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
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
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: TextField(

                      decoration: InputDecoration(

                        prefixIcon: Center(
                          child: Icon(
                            Icons.search,
                            color: Color(0xFFFFCDB6),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        // prefixIcon: Icon(Icons.search, color: Colors.grey),

                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                          // borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),

                  ),

                  Container(
                    height: 450,
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
                      minWidth: 250,
                      height: 50,
                      child: RaisedButton(
                        child: Text('Confirm', style: TextStyle(fontSize: 16,color: Colors.white)),
                        //textColor: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFFFF7E40),
                        onPressed: () {Navigator.of(context).pop();},
                        // color: pressAttention ? Colors.grey : Color(0xFFFF7E40),
                        // onPressed: () => setState(() => pressAttention = !pressAttention),
                      ),
                    ),
                  ),

                ],
              )),
        ),
      ),
    );
  }
}
