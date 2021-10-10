import 'dart:async';

import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/services/auth.dart';

class EmailResendPage extends StatefulWidget {
  final PageController pageController;
  final bool isEdit;
  final ValueChanged<String> valueChanged;
  const EmailResendPage({
    Key key,
    this.pageController,
    this.isEdit = false,
    this.valueChanged,
  }) : super(key: key);
  @override
  _EmailResendPageState createState() => _EmailResendPageState();
}

class _EmailResendPageState extends State<EmailResendPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = new TextEditingController();

  int secondsRemaining = 60;
  bool buttonActivated = false;
  Timer timer;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _width = maxWidth;
    double _height = MediaQuery.of(context).size.height;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: widget.isEdit ? _height * 0.9 * 0.044 : _height * 0.044,
              ),
              Text(
                'Did you receive the verification email?',
                style: largeTitleTextStyleBold(Colors.white, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: widget.isEdit ? _height * 0.9 * 0.016 : _height * 0.016,
              ),
              Text(
                'If not, click the button below to resend',
                style: simpleTextStyle(Colors.white, 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: widget.isEdit
          ? BoxDecoration(
              color: themeOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                // bottomLeft: Radius.circular(30.0),
                // bottomRight: Radius.circular(30.0),
              ),
            )
          : null,
      height: widget.isEdit ? (_height * 0.9) : _height,
      color: widget.isEdit ? null : themeOrange,
      child: Padding(
        padding: EdgeInsets.only(top: widget.isEdit ? (22) : 0),
        child: Form(
          key: formKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: themeOrange,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.isEdit
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35.0),
                                topRight: Radius.circular(35.0),
                                bottomLeft: Radius.circular(35.0),
                                bottomRight: Radius.circular(35.0),
                              ),
                              child: SizedBox(
                                width: 65.0,
                                height: 6.0,
                                child: const DecoratedBox(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                ),
                              )
                              // child: Container(
                              //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
                              //   color: Colors.black,
                              // )
                              ),
                        )
                      : Container(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: widget.isEdit
                              ? (_height * 0.9 * 0.13 - 22)
                              : _height * 0.13 - 22),
                      child: _getHeader()),
                  Padding(
                    padding: EdgeInsets.only(
                        top: widget.isEdit
                            ? _height * 0.9 * 0.22
                            : _height * 0.22,
                        left: 45,
                        right: 45),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: widget.isEdit
                            ? _height * 0.5 * 0.2
                            : _height * 0.2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height:
                          widget.isEdit ? _height * 1.9 * 0.06 : _height * 0.06,
                      width: _width * 0.75,
                      child: RaisedButton(
                        hoverElevation: 0,
                        highlightColor: Color(0xDA6D39),
                        highlightElevation: 0,
                        elevation: 0,
                        color: buttonActivated
                            ? Color(0xFFFF9B6B).withOpacity(1)
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          if (buttonActivated) {
                            return null;
                          }
                          buttonActivated = true;

                          authMethods.sendVerifyEmail();

                          timer = Timer.periodic(Duration(seconds: 1), (timer) {
                            if (!mounted) {
                              return;
                            }
                            if (secondsRemaining != 0) {
                              setState(() {
                                secondsRemaining--;
                              });
                            } else {
                              setState(() {
                                buttonActivated = false;
                                secondsRemaining = 60;
                              });
                              timer.cancel();
                            }
                          });
                        },
                        child: buttonActivated
                            ? Text(
                                'Resend after $secondsRemaining seconds',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            : Text('Resend',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
