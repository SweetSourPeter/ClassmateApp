import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/custom-checkbox.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatefulWidget {
  final PageController pageController;
  final Color buttonColor;
  const PrivacyPage({Key key, this.pageController, this.buttonColor})
      : super(key: key);
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage>
    with AutomaticKeepAliveClientMixin {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool checkedToSvalue = false;
  bool checkedPPvalue = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _width = maxWidth;
    double _height = MediaQuery.of(context).size.height;
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        print(url);
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
                'Check the boxes to accept',
                style: largeTitleTextStyleBold(Colors.white, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'Your privacy is very important and nothing\n ever happens without your approval!',
                style: simpleTextSansStyleBold(Color(0XFFF7D5C5), 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    DatabaseMethods databaseMethods = new DatabaseMethods();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: _height * 0.13),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: themeOrange,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _getHeader(),
                Padding(
                  padding:
                      EdgeInsets.only(top: _height * 0.19, left: _width * 0.19),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomCheckbox(
                            isChecked: checkedToSvalue,
                            size: 32,
                            iconSize: 24,
                            selectedColor: Colors.white,
                            selectedIconColor: themeOrange,
                            valueChanged: (index) {
                              setState(() {
                                checkedToSvalue = index;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "I accept the",
                            style: simpleTextStyle(Colors.white, 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://docs.qq.com/doc/DUGl3Z2htWHRzYm1Y');
                            },
                            child: Text(
                              " Term of Service",
                              style: simpleTextSansStyleBold(Colors.white, 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      Row(
                        children: [
                          CustomCheckbox(
                            isChecked: checkedPPvalue,
                            size: 32,
                            iconSize: 24,
                            selectedColor: Colors.white,
                            selectedIconColor: themeOrange,
                            valueChanged: (index) {
                              setState(() {
                                checkedPPvalue = index;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "I accept the",
                            style: simpleTextStyle(Colors.white, 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://docs.qq.com/doc/DUEhxcUl3cmtKWk5Q');
                            },
                            child: Text(
                              " Privacy Policy",
                              style: simpleTextSansStyleBold(Colors.white, 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // TextField(
                  //   onChanged: (texto) {
                  //     setState(() {
                  //       _nikname = texto;
                  //     });
                  //   },
                  //   cursorColor: Colors.white,
                  //   style: TextStyle(color: Colors.white, fontSize: 21),
                  //   decoration: textFieldInputDecoration('Your name...', 11),
                  // ),
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
                      highlightColor: Color(0xFFFF9B6B),
                      highlightElevation: 0,
                      elevation: 0,
                      color: (checkedToSvalue && checkedPPvalue)
                          ? Colors.white
                          : Color(0xFFFF9B6B).withOpacity(1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        if (checkedToSvalue && checkedPPvalue) {
                          databaseMethods
                              .updateUserAgreement(user.userID,
                                  checkedToSvalue && checkedPPvalue)
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Wrapper(
                                  false,
                                  false,
                                  '',
                                ),
                              ),
                            );
                          });
                        }
                      },
                      child: Text(
                        'Create Account',
                        style: simpleTextSansStyleBold(
                            (checkedToSvalue && checkedPPvalue)
                                ? themeOrange
                                : Colors.white,
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
