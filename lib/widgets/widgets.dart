import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//input that is commenly used inside the app
InputDecoration buildInputDecorationPinky(
    bool isIcon, Icon prefixIcon, String hintText, double boarderRadius) {
  return InputDecoration(
    prefixIcon: isIcon ? prefixIcon : null,
    fillColor: Colors.white,
    filled: true,
    // prefixIcon: Icon(Icons.search, color: Colors.grey),
    hintText: hintText,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: themeOrange, width: 1.0),
      borderRadius: BorderRadius.circular(
        boarderRadius,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: themeOrange, width: 1.0),
      borderRadius: BorderRadius.circular(boarderRadius),
      // borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: themeOrange, width: 1.0),
      borderRadius: BorderRadius.circular(boarderRadius),
      // borderSide: BorderSide.none
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[400], width: 1.0),
      borderRadius: BorderRadius.circular(boarderRadius),
      // borderSide: BorderSide.none
    ),

    contentPadding: EdgeInsets.all(32), //height of the iput fie
    hintStyle: TextStyle(color: Colors.grey), // KEY PROP
  );
}

InputDecoration textFieldInputDecoration(
    double height, String hintText, double boarderRadius) {
  return InputDecoration(
    fillColor: Color(0xFFFF9B6B).withOpacity(1),
    filled: true,
    // prefixIcon: Icon(Icons.search, color: Colors.grey),
    hintText: hintText,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(boarderRadius),
      // borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(boarderRadius),
      // borderSide: BorderSide.none
    ),

    contentPadding: EdgeInsets.all(height), //height of the iput fie
    hintStyle: TextStyle(color: Color(0xF7D5C5).withOpacity(0.7)), // KEY PROP
  );
}

TextStyle simpleTextStyle(Color color, double fontsize) {
  return GoogleFonts.openSans(
    textStyle: TextStyle(color: color, fontSize: fontsize),
  );
}

TextStyle simpleTextStyleBlack() {
  return GoogleFonts.openSans(
    textStyle: TextStyle(color: Colors.black, fontSize: 16),
  );
}

TextStyle simpleTextSansStyleBold(Color color, double fontsize) {
  return GoogleFonts.openSans(
    textStyle: TextStyle(
        color: color, fontSize: fontsize, fontWeight: FontWeight.bold),
  );
}

TextStyle largeTitleTextStyle(Color color, double fontsize) {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(color: color, fontSize: fontsize),
  );
}

TextStyle largeTitleTextStyleBold(Color color, double fontsize) {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
        color: color, fontSize: fontsize, fontWeight: FontWeight.bold),
  );
}

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

class PlainGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const PlainGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

//used on top of dragble sheet and showModalBottomSheet
Padding topLineBar() {
  return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 8, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
          bottomLeft: Radius.circular(35.0),
          bottomRight: Radius.circular(35.0),
        ),
        child: SizedBox(
          width: 42.0,
          height: 4.0,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: themeOrange),
          ),
        ),
      )
      // child: Container(
      //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
      //   color: Colors.black,
      // )
      );
}

// used to create user image
String calculateUserName(String name) {
  var splitString = name.split(" ");
  if (splitString.length >= 2 &&
      name.split(' ')[name.split(' ').length - 1].isNotEmpty) {
    return (splitString[0][0] + splitString[1][0]);
  } else {
    return (splitString[0][0]);
  }
}

Container createUserImage(double radius, UserData userdata, TextStyle style) {
  // print('name:=======');
  // var string = "Hello world!";
  // print(string.split(" "));
  return Container(
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: userdata.profileColor == null
            ? listColors[0]
            : listColors[userdata.profileColor.toInt()]),
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: Container(
        child: (userdata.userName != null)
            ? Text(
                calculateUserName(userdata.userName).toUpperCase(),
                style: style,
              )
            : Text(
                ' ',
                style: style,
              ),
      ),
      // backgroundImage: (userdata.userImageUrl == null)
      //     ? null
      //     : NetworkImage(
      //         'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg'),
    ),
  );
}

CircleAvatar creatAddIconImage(double radius) {
  return CircleAvatar(
    backgroundColor: transparent,
    radius: radius,
    backgroundImage: AssetImage('./assets/images/add_icon.png'),
  );
}

Container creatUserImageWithString(
    double radius, String userName, double userProfileColor, TextStyle style) {
  return Container(
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: userProfileColor == null
            ? listColors[0]
            : listColors[userProfileColor.toInt()]),
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: Container(
        child: (userName != null)
            ? Text(
                calculateUserName(userName).toUpperCase(),
                style: style,
              )
            : Text(
                ' ',
                style: style,
              ),
      ),
      // backgroundImage: (userdata.userImageUrl == null)
      //     ? null
      //     : NetworkImage(
      //         'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg'),
    ),
  );
}

class ButtonLink extends StatefulWidget {
  final String text;
  final String userName;
  final IconData iconData;
  final double textSize;
  final double height;
  final double userProfileColor;
  final GestureTapCallback onTap;
  @required
  final bool isSimple;
  @required
  final bool isSwitch;
  @required
  final bool isEdit;
  @required
  final String editText;
  @required
  final UserData user;
  @required
  final bool isAvatar;

  ButtonLink(
      {this.text,
      this.iconData,
      this.textSize,
      this.userName,
      this.height,
      this.userProfileColor,
      this.onTap,
      this.isSimple = false,
      this.isSwitch = false,
      this.isEdit = false,
      this.editText = '',
      this.user = null,
      this.isAvatar = false});

  @override
  _ButtonLinkState createState() => _ButtonLinkState();
}

class _ButtonLinkState extends State<ButtonLink> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final userdata = Provider.of<UserData>(context);

    return Column(
      children: [
        FlatButton(
          padding: widget.isEdit
              ? EdgeInsets.fromLTRB(20, 10, 20, 10)
              : EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: widget.height,
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: widget.isSimple
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                mainAxisSize:
                    widget.isSimple ? MainAxisSize.min : MainAxisSize.max,
                children: <Widget>[
                  (widget.isSimple || widget.isEdit)
                      ? Container()
                      : Icon(
                          widget.iconData,
                          color: themeOrange,
                          size: widget.textSize * 1.5,
                        ),
                  SizedBox(
                    width: widget.isSimple ? 0 : 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.text,
                          style: GoogleFonts.openSans(
                            color: Color(0xFF000000),
                            fontSize: widget.textSize,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                  widget.isSimple ? Container() : new Spacer(),
                  widget.isAvatar
                      ? creatUserImageWithString(
                          widget.height / 3.5,
                          userdata.userName,
                          widget.userProfileColor,
                          largeTitleTextStyle(Colors.white, 12),
                        )
                      : Container(),
                  widget.isEdit && widget.editText.length > 0
                      ? Text(
                          widget.editText,
                          style: GoogleFonts.openSans(
                              color: Colors.black45, fontSize: widget.textSize),
                        )
                      : Container(),
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
                                      // print(isSwitched);
                                    });
                                  },
                                  activeTrackColor: themeOrange,
                                  activeColor: Colors.white,
                                ))
                      : Container(),
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

/*class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final GestureTapCallback onTap;

  MyButton({this.text, this.iconData, this.textSize, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.black45,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.black87, fontSize: textSize),
              ),
              new Spacer(),
              Icon(
                Icons.chevron_right,
                size: 26,
                color: Colors.black54,
              )
            ],
          ),
          Divider(
            height: 25,
            indent: 45,
            thickness: 0.5,
            color: Colors.black38,
          ),
        ],
      ),
      onPressed: () {
        onTap();
      },
    );
  }
}*/

Padding userInfoDetailsBox(Size mediaQuery, String topText, String bottomText) {
  return Padding(
    padding: EdgeInsets.fromLTRB(mediaQuery.width / 7, 0, 0, 0),
    child: Column(
      children: [
        Container(
          height: 20,
          child: Text(
            topText,
            style: TextStyle(
                fontSize: 16, color: themeOrange, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          bottomText,
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}

void showBottomPopSheet(BuildContext context, Widget widget) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 10,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            // bottomLeft: Radius.circular(30.0),
            // bottomRight: Radius.circular(30.0),
          )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(child: widget);
      });
}
