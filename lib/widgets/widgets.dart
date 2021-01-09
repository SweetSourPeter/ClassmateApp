import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//input that is commenly used inside the app
InputDecoration buildInputDecorationPinky(
    bool isIcon, Icon prefixIcon, String hintText, double boarderRadius) {
  return InputDecoration(
    prefixIcon: isIcon ? prefixIcon : null,
    fillColor: builtyPinkColor,
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

    contentPadding: EdgeInsets.all(10),
    hintStyle: TextStyle(color: Colors.grey), // KEY PROP
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle(Color color) {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(color: color, fontSize: 16),
  );
}

TextStyle simpleTextStyleBlack() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(color: Colors.black, fontSize: 16),
  );
}

TextStyle biggerTextStyle() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(color: Colors.white, fontSize: 17),
  );
}

TextStyle largeTitleTextStyle(Color color) {
  return GoogleFonts.montserrat(
    textStyle:
        TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.w700),
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
      padding: EdgeInsets.fromLTRB(10, 10, 8, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: SizedBox(
          width: 55.0,
          height: 5.0,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: lightOrangeColor),
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
CircleAvatar createUserImage(double radius, UserData userdata) {
  return CircleAvatar(
    backgroundColor: themeOrange,
    radius: radius,
    child: Container(
      child: (userdata.userImageUrl == null)
          ? Text(
              userdata.userName[0].toUpperCase(),
              style: TextStyle(fontSize: 35, color: Colors.white),
            )
          : null,
    ),
    backgroundImage: (userdata.userImageUrl == null)
        ? null
        : NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg'),
  );
}

CircleAvatar creatAddIconImage(double radius) {
  return CircleAvatar(
    backgroundColor: transparent,
    radius: radius,
    backgroundImage: AssetImage('./assets/images/add_icon.png'),
  );
}

CircleAvatar creatUserImageWithString(
    double radius, String userImageUrl, String userName) {
  print("my user image url is $userImageUrl");
  return CircleAvatar(
    backgroundColor: themeOrange,
    radius: radius,
    child: Container(
      child: (userImageUrl == '')
          ? Text(
              userName[0].toUpperCase(),
              style: TextStyle(fontSize: 35, color: Colors.white),
            )
          : null,
    ),
    backgroundImage: (userImageUrl == '')
        ? null
        : NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg'),
  );
}

class ButtonLink extends StatefulWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final GestureTapCallback onTap;
  @required
  final bool isSimple;
  @required
  final bool isSwitch;
  @required
  final bool isEdit;
  @required
  String editText;

  ButtonLink(
      {this.text,
      this.iconData,
      this.textSize,
      this.height,
      this.onTap,
      this.isSimple = false,
      this.isSwitch = false,
      this.isEdit = false,
      this.editText = ''});

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
          padding: widget.isEdit
              ? EdgeInsets.fromLTRB(20, 10, 20, 10)
              : EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: widget.height,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  (widget.isSimple || widget.isEdit)
                      ? Container()
                      : Icon(
                          widget.iconData,
                          color: themeOrange,
                          size: widget.textSize * 1.5,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: GoogleFonts.montserrat(
                            color:
                                !widget.isSimple ? Colors.black87 : themeOrange,
                            fontSize: widget.textSize),
                      ),
                      widget.isEdit && widget.editText.length > 0
                          ? Text(
                              widget.editText,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black45,
                                  fontSize: widget.textSize),
                            )
                          : Container(),
                    ],
                  ),
                  widget.isSimple ? Icon(
                    widget.iconData,
                    color: themeOrange,
                    size: widget.textSize * 1.5,
                  ) : Container(),
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
                                  activeTrackColor: themeOrange,
                                  activeColor: Colors.white,
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
          side: BorderSide(width: 15, color: Colors.transparent),
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
