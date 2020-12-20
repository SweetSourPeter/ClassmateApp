import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  final Color buttonColor;
  const SecondPage({Key key, this.pageController, this.buttonColor})
      : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  final databaseMehods = DatabaseMehods();
  String _nikname = '';
  double _scaleHolder = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    Size mediaQuery = MediaQuery.of(context).size;
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: _height * 0.23),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'How would you like your friends to call you?',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.only(top: _height * 0.22),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _nikname.length <= 16
                              ? 'Your nickname is: $_nikname '
                              : "please limit to 16 characters",
                          style: TextStyle(fontSize: 14, color: Colors.white38),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '${_nikname.length} / 16',
                          style: TextStyle(fontSize: 14, color: Colors.white38),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    TextField(
                      onChanged: (texto) {
                        setState(() {
                          _nikname = texto;
                        });
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          //labelText: '',
                          hintText: "Type here...",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 18),
                          border: InputBorder.none),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: _height * 0.20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 10),
                        blurRadius: 15),
                  ],
                ),
                height: mediaQuery.height * 0.06,
                width: mediaQuery.width * 0.3,
                child: RaisedButton(
                  onHighlightChanged: (press) {
                    setState(() {
                      if (press) {
                        _scaleHolder = 0.1;
                      } else {
                        _scaleHolder = 0.0;
                      }
                    });
                  },
                  hoverColor: widget.buttonColor,
                  hoverElevation: 0,
                  highlightColor: widget.buttonColor,
                  highlightElevation: 0,
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    //TODO add username
                    widget.pageController.animateToPage(2,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInCubic);
                    databaseMehods.updateUserName(user.userID, _nikname);
                    print('username saved');
                  },
                  child: Text('Complete',
                      style: simpleTextStyle(widget.buttonColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
