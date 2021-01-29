import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/my_pages/forgetpassword.dart';
import 'package:app_test/pages/my_pages/sign_up.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:app_test/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  final PageController pageController;
  const SignIn({
    Key key,
    this.pageController,
  }) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

final formKey = GlobalKey<FormState>();
bool isLoading = false;

//Auth and Database instance created
AuthMethods authMethods = new AuthMethods();
// DatabaseMehods databaseMehods = new DatabaseMehods();

TextEditingController emailTextEditingController = new TextEditingController();
TextEditingController passwordTextEditingController =
    new TextEditingController();
String errorMessage;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

_toastInfo(String info) {
  Fluttertoast.showToast(
    msg: info,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
    gravity: ToastGravity.CENTER,
  );
}

class _SignInState extends State<SignIn> {
  signMeIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        print('object');
        // print(val.error.toString());
        isLoading = false;
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Wrapper(false)));
      }).catchError((error) {
        //TODO
        setState(() {
          isLoading = false;
        });
        // switch (error.code) {
        //   case "ERROR_INVALID_EMAIL":
        //     tempError = "Your email address appears to be malformed.";
        //     break;
        //   case "ERROR_WRONG_PASSWORD":
        //     tempError = "Your password is wrong.";
        //     break;
        //   case "ERROR_USER_NOT_FOUND":
        //     tempError = "User with this email doesn't exist.";
        //     break;
        //   case "ERROR_USER_DISABLED":
        //     tempError = "User with this email has been disabled.";
        //     break;
        //   case "ERROR_TOO_MANY_REQUESTS":
        //     tempError = "Too many requests. Try again later.";
        //     break;
        //   case "ERROR_OPERATION_NOT_ALLOWED":
        //     tempError = "Signing in with Email and Password is not enabled.";
        //     break;
        //   default:
        //     tempError = "An undefined Error happened.";
        // }
        // _scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text(error.code),
        //   duration: Duration(seconds: 3),
        // ));
        _toastInfo(error.code.toString() ?? 'Unknown Error');
      });
    }
  }

  //below for the wiget
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    _getBackBtn() {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: _height * 0.06, left: _width * 0.098),
          child: GestureDetector(
            onTap: () {
              widget.pageController.animateToPage(1,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInCubic);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    _getSignIn() {
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
          color: (emailTextEditingController.text.isNotEmpty &&
                  passwordTextEditingController.text.isNotEmpty)
              ? Colors.white
              : Color(0xFFFF9B6B).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            signMeIn();
          },
          child: AutoSizeText(
            'Continue',
            style: simpleTextSansStyleBold(
                (emailTextEditingController.text.isNotEmpty &&
                        passwordTextEditingController.text.isNotEmpty)
                    ? themeOrange
                    : Colors.white,
                16),
          ),
        ),
      );
    }

    _getTextFields() {
      return Padding(
        padding: EdgeInsets.only(
          left: _width * 0.12,
          right: _width * 0.12,
          top: _height * 0.12,
          bottom: _height * 0.20,
        ),
        child: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _height * 0.018,
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
                        _height * 0.036, 'School Email', 11),
                  ),
                  SizedBox(
                    height: _height * 0.018,
                  ),
                  TextFormField(
                    style: simpleTextStyle(Colors.white, 16),
                    controller: passwordTextEditingController,
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Please provoid valid password format";
                    },
                    decoration: textFieldInputDecoration(
                      _height * 0.036,
                      'Password',
                      11,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.0246,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Forgetpassword()));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                ],
              ),
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
              height: _height * 0.037,
            ),
            Text(
              'Welcome',
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
            Text(
              'Back !',
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      //gesturedetector used for hiding the keyboard after click anywhere else
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },

      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          body: isLoading
              ? Container(child: LoadingScreen(themeOrange))
              : Scaffold(
                  resizeToAvoidBottomPadding: false,
                  backgroundColor: themeOrange,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _getBackBtn(),
                        _getHeader(),
                        _getTextFields(),
                        _getSignIn(),
                        // Container(
                        //   height: _height * (1 - 0.14),
                        //   width: _width,
                        //   child: Column(
                        //     mainAxisSize:
                        //         MainAxisSize.min, // Use children total size
                        //     children: <Widget>[

                        //       // _getBottomRow(context),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

// _getBackBtn() {
//   return Positioned(
//     top: 35,
//     left: 25,
//     child: Icon(
//       Icons.arrow_back_ios,
//       color: Colors.white,
//     ),
//   );
// }

}
