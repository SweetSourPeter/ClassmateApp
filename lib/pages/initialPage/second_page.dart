import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<String> valueChanged;
  const SecondPage({
    Key key,
    this.pageController,
    this.valueChanged,
  }) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String _nikname = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 36,
              ),
              Text(
                'What should your classmates call you?',
                style: largeTitleTextStyleBold(Colors.white, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'Your profile picture dispalys the first letters of your nick name',
                style: simpleTextStyle(Colors.white, 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: _height * 0.13),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: themeOrange,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _getHeader(),
                Padding(
                  padding:
                      EdgeInsets.only(top: _height * 0.22, left: 45, right: 45),
                  child: TextField(
                    onChanged: (texto) {
                      setState(() {
                        _nikname = texto;
                      });
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 21),
                    decoration: textFieldInputDecoration('Your name...', 11),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _height * 0.2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: _height * 0.06,
                    width: _width * 0.75,
                    child: RaisedButton(
                      hoverElevation: 0,
                      highlightColor: Color(0xDA6D39),
                      highlightElevation: 0,
                      elevation: 0,
                      color: (_nikname.isNotEmpty)
                          ? Colors.white
                          : Color(0xDA6D39).withOpacity(1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        if (_nikname.length > 0) {
                          widget.pageController.animateToPage(1,
                              duration: Duration(milliseconds: 800),
                              curve: Curves.easeInCubic);
                          databaseMethods.updateUserName(user.userID, _nikname);
                          widget.valueChanged(_nikname);
                          print('username saved');
                        }
                      },
                      child: Text(
                        'Continue',
                        style: simpleTextSansStyleBold(
                            (_nikname.isNotEmpty) ? themeOrange : Colors.white,
                            16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
