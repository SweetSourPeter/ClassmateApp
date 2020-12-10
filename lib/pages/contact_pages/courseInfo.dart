import 'package:app_test/models/constant.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/constant.dart';
import '../../MainMenu.dart';
import 'package:provider/provider.dart';

class CourseInfo extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CourseInfo> {
  bool isSwitched = false;

  List<Widget> _renderNinepeoplePreview() {
    return List.generate(10, (index) {
      if (index == 9) {
        return GestureDetector(
          child: Container(
            child: Column(
              children: <Widget>[
                creatAddIconImage(),
                Text(
                  'Invite',
                  style:
                      GoogleFonts.montserrat(color: orengeColor, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }
      return Container(
        //color: orengeColor,
        child: Column(
          children: <Widget>[
            creatUserImage(
                30,
                UserData(
                  userID: 'asd',
                  school: 'asd',
                  email: 'asd',
                  userImageUrl: 'asd',
                  userName: 'asd',
                )),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(
                'text',
                style:
                    GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.navigate_before,
              color: themeOrange,
              size: 38,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('CS111 A1',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
            Text('25 people',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        elevation: 0,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 15, right: 30),
              child: GestureDetector(
                child: Text(
                  'Share',
                  style: TextStyle(color: themeOrange, fontSize: 20),
                ),
              ))
        ],
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: riceColor,
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 30),
                  margin: EdgeInsets.only(top: 25),
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Container(
                      height: 20,
                      //color: Colors.black,
                      child: Stack(children: <Widget>[
                        Positioned(
                          child: Text('Group Members',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400, fontSize: 18)),
                          top: 0,
                        ),
                        Positioned(
                            child: GestureDetector(
                              child: Row(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Text("25 people",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: Colors.black38,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            top: -3,
                            right: 0),
                      ]),
                    ),
                    Container(
                      height: 200,
                      //color: Colors.pink,
                      child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(0),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            crossAxisCount: 5,
                            childAspectRatio: 1 / 1.1,
                            children: _renderNinepeoplePreview(),
                          )),
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Divider(
                        height: 0,
                        thickness: 1,
                      ),
                      ButtonLink(
                        text: "Media, Links, and Docs",
                        iconData: Icons.folder,
                        textSize: 18,
                        height: 20,
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        indent: 45,
                      ),
                      ButtonLink(
                        text: "Chat Search",
                        iconData: Icons.search,
                        textSize: 18,
                        height: 0,
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        indent: 45,
                      ),
                      ButtonLink(
                          text: "Mute",
                          iconData: Icons.notifications_off,
                          textSize: 18,
                          height: 20,
                          isSwitch: true),
                      Divider(
                        height: 0,
                        thickness: 1,
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        ButtonLink(
                            text: "Clear Chat",
                            iconData: Icons.cleaning_services,
                            textSize: 18,
                            height: 0,
                            isSimple: true),
                        Divider(
                          height: 0,
                          thickness: 1,
                        )
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      Divider(
                        height: 0,
                        thickness: 1,
                      ),
                      ButtonLink(
                          text: "Exit Group",
                          iconData: Icons.cleaning_services,
                          textSize: 18,
                          height: 0,
                          isSimple: true),
                      Divider(
                        height: 0,
                        thickness: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ButtonLink extends StatefulWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final GestureTapCallback onTap;
  @required
  bool isSimple;
  @required
  bool isSwitch;

  ButtonLink(
      {this.text,
      this.iconData,
      this.textSize,
      this.height,
      this.onTap,
      this.isSimple = false,
      this.isSwitch = false});

  @override
  _ButtonLinkState createState() => _ButtonLinkState();
}

class _ButtonLinkState extends State<ButtonLink> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        FlatButton(
          height: 50,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  !widget.isSimple
                      ? Icon(
                          widget.iconData,
                          color:
                              !widget.isSimple ? Colors.black45 : orengeColor,
                        )
                      : Container(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.text,
                    style: GoogleFonts.montserrat(
                        color: !widget.isSimple ? Colors.black87 : orengeColor,
                        fontSize: widget.textSize),
                  ),
                  new Spacer(),
                  !widget.isSimple
                      ? Container(
                          child: !widget.isSwitch
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 26,
                                  color: Colors.black54,
                                )
                              : Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      print(isSwitched);
                                    });
                                  },
                                  activeTrackColor: orengeColor,
                                  activeColor: Colors.orangeAccent,
                                ))
                      : Container()
                ],
              ),
            ],
          ),
          onPressed: () {
            widget.onTap();
          },
        )
      ],
    );
  }
}
