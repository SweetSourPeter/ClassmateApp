import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/material.dart';

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

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle simpleTextStyleBlack() {
  return TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

TextStyle largeTitleTextStyle(Color color) {
  return TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.w700);
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
CircleAvatar creatUserImage(double radius, UserData userdata) {
  return CircleAvatar(
    backgroundColor: orengeColor,
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

CircleAvatar creatUserImageWithString(
    double radius, String userImageUrl, String userName) {
  print("my user image url is $userImageUrl");
  return CircleAvatar(
    backgroundColor: orengeColor,
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
