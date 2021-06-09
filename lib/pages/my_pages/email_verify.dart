import 'package:app_test/services/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:app_test/services/auth.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:app_test/models/constant.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import "package:firebase_auth/firebase_auth.dart" as auth;

class EmailVerifySent extends StatefulWidget {
  @override
  _EmailVerifySentState createState() => _EmailVerifySentState();
}

class _EmailVerifySentState extends State<EmailVerifySent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool hasSend = false;

  // AuthMethods authMethods = new AuthMethods();

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
    AuthMethods authMethods = new AuthMethods();
    _toastInfo(String info) {
      Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER,
      );
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
          color: (!hasSend) ? Colors.white : Color(0xFFFF9B6B).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (hasSend) {
              _toastInfo('Too many request');
            } else {
              startTimer();
              setState(() {
                hasSend = true;
              });
              authMethods.sendVerifyEmail().then((val) {
                _toastInfo('Email successfully sent');
              }).catchError((error) {
                if (!mounted) {
                  return; // Just do nothing if the widget is disposed.
                }

                _toastInfo(error.code ?? 'Unknown Error');
              });
            }
          },
          child: AutoSizeText(
            hasSend ? '$_start Seconds to Resend' : 'Send It',
            style: simpleTextSansStyleBold(
                (!hasSend) ? themeOrange : Colors.white, 16),
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
              // authMethods.signOut().then((value) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => Wrapper(false)),
              //   );
              // });
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
              height: _height * 0.07,
            ),
            Text(
              'Please Verify Your Email',
              textAlign: TextAlign.center,
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
            SizedBox(
              height: _height * 0.016,
            ),
            Text(
              'The email would usually be sent with in 30 secs',
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
          top: _height * 0.05,
          bottom: _height * 0.09,
        ),
        child: Container(
            alignment: Alignment.center,
            height: _height * 0.354,
            width: _width * 0.416,
            child: Image.asset('assets/images/emailFly.png')),
      );
    }

    return SafeArea(
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
          body: SingleChildScrollView(
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
    );
  }
}
