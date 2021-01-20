import "package:flutter/material.dart";
import 'package:app_test/services/auth.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

class Forgetpassword extends StatefulWidget {
  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool hasSend = false;
  TextEditingController emailTextEditingController =
      new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthMethods authMethods = new AuthMethods();

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            hasSend = false;
            timer.cancel();
            _start = 60;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    sendIt() {
      if (formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
          hasSend = false;
        });
        authMethods.resetPassword(emailTextEditingController.text).then((val) {
          print('object');
          // print(val.error.toString());
          startTimer();
          setState(() {
            isLoading = false;
            hasSend = true;
          });
        }).catchError((error) {
          //TODO
          setState(() {
            isLoading = false;
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(error.code),
              duration: Duration(seconds: 3),
            ));
          });
        });
      }
    }

    _enterEmail() {
      return Container(
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
          color: (emailTextEditingController.text.isNotEmpty && !hasSend)
              ? Colors.white
              : Color(0xFFFF9B6B).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (!hasSend && emailTextEditingController.text.isNotEmpty) {
              sendIt();
            }
          },
          child: AutoSizeText(
            hasSend ? '$_start Seconds to Resend' : 'Send It',
            style: simpleTextSansStyleBold(
                (emailTextEditingController.text.isNotEmpty && !hasSend)
                    ? themeOrange
                    : Colors.white,
                16),
          ),
        ),
      );
    }

    _getBackBtn() {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: _height * 0.06, left: _width * 0.098),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      );
    }

    _getHeader() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.1,
            ),
            Text(
              'Forget Your Password?',
              textAlign: TextAlign.center,
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              'No worries! Enter your email and we will send you a reset.',
              style: simpleTextStyle(Colors.white, 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    _getTextFields() {
      return Padding(
        padding: EdgeInsets.only(
          left: _width * 0.12,
          right: _width * 0.12,
          top: _height * 0.12,
          bottom: _height * 0.1,
        ),
        child: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    style: simpleTextStyle(Colors.white, 16),
                    controller: emailTextEditingController,
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please enter correct email";
                    },
                    decoration: textFieldInputDecoration(
                        _height * 0.036, 'Enter Your Email', 11),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: themeOrange,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: themeOrange,
            resizeToAvoidBottomPadding: false,
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    backgroundColor: themeOrange,
                  ))
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _getBackBtn(),
                        _getHeader(),
                        _getTextFields(),
                        _enterEmail(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
