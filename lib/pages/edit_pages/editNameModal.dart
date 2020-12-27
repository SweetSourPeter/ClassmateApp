import 'dart:math';

import 'package:app_test/pages/explore_pages/loadingSeatReminderList.dart';
import 'package:app_test/pages/explore_pages/seatNotifyAdd.dart';
import 'package:app_test/services/course_reminder_db.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/constant.dart';

class EditNameModal extends StatefulWidget {
  final String userName;
  final String id;
  EditNameModal({this.userName, this.id});

  @override
  _EditNameModalState createState() => _EditNameModalState();
}

class _EditNameModalState extends State<EditNameModal> {
  String subtitle;
  final databaseMehods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    double modal_height = MediaQuery.of(context).size.height - 50;
    final TextEditingController _controller = TextEditingController();
    _controller.text = widget.userName;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    return Container(
        height: modal_height,
        child: Container(
          child:
              // RefreshIndicator(
              // key: refreshKey,
              // onRefresh: () async {
              //   await refreshList();
              // },
              // child:
              Column(
            children: [
              topLineBar(),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: AppBar(
                  backgroundColor: Colors.white30,
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: themeOrange,
                        size: 38,
                      )),
                  elevation: 0,
                  title: Text('Name',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22)),
                  actions: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15, right: 30),
                      child: GestureDetector(
                        child: Text(
                          'Save',
                          style: GoogleFonts.montserrat(
                              color: themeOrange, fontSize: 20),
                        ),
                        onTap: () {
                          String nicknam = _controller.text;

                          if (nicknam.length > 0 &&
                              nicknam != widget.userName) {
                            databaseMehods.updateUserName(widget.id, nicknam);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: _controller,
                  onChanged: (texto) {},
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 21),
                  autofocus: true,
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      //labelText: '',
                      //hintText: "Como será minha senha...",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          // ),
        ));
  }
}
