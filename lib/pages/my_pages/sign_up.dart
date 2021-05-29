import 'package:app_test/models/constant.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/loadingAnimation.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  final PageController pageController;
  const SignUpPage({
    Key key,
    this.pageController,
  }) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

// http://universities.hipolabs.com/search?name=University%20of%20California,%20Santa%20Barbara
class _SignUpPageState extends State<SignUpPage> {
  String _selectedSchool;
  List<String> _schools = [
    "Boston University",
    "University of California, Santa Barbara",
    "Pennsylvania State University",
  ];
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool emailExist = false;
  String errorMessage;

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // TextEditingController usernameTextEditingController =
  //     new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  _toastInfo(String info) {
    Fluttertoast.showToast(
      msg: info,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
      gravity: ToastGravity.CENTER,
    );
  }

  signMeUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      // Map<String, String> userInfoMap = {
      //   "name": emailTextEditingController.text,
      //   "email": emailTextEditingController.text,
      //   "school": _selectedSchool,
      // };
      print('valid');
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text, _selectedSchool)
          .then((val) {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => StartPage()));
        print('auth method finish');
        isLoading = false;
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Wrapper(true)),
        // );
      }).catchError((error) {
        if (!mounted) {
          return; // Just do nothing if the widget is disposed.
        }
        setState(() {
          isLoading = false;
        });
        // String tempError;
        // switch (error.code) {
        //   case "ERROR_OPERATION_NOT_ALLOWED":
        //     tempError = "Anonymous accounts are not enabled";
        //     break;
        //   case "ERROR_WEAK_PASSWORD":
        //     tempError = "Your password is too weak";
        //     break;
        //   case "ERROR_INVALID_EMAIL":
        //     tempError = "Your email is invalid";
        //     break;
        //   case "ERROR_EMAIL_ALREADY_IN_USE":
        //     tempError = "Email is already in use on different account";
        //     break;
        //   case "ERROR_INVALID_CREDENTIAL":
        //     tempError = "Your email is invalid";
        //     break;
        //   default:
        //     tempError = "An undefined Error happened.";
        // }
        // setState(() {
        //   errorMessage = error.code;
        // });
        // _scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text(error.code ?? ''),
        //   duration: Duration(seconds: 3),
        // ));
        _toastInfo(error.code.toString() ?? 'Unknown Error');
      });
    }
  }

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

    _getBottomRow(context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            '',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
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
                  passwordTextEditingController.text.isNotEmpty &&
                  _selectedSchool.isNotEmpty)
              ? Colors.white
              : Color(0xFFFF9B6B).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            emailExist = false;
            signMeUp();
          },
          child: AutoSizeText(
            'CONTINUE',
            style: simpleTextSansStyleBold(
                (emailTextEditingController.text.isNotEmpty &&
                        passwordTextEditingController.text.isNotEmpty &&
                        _selectedSchool.isNotEmpty)
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
          top: _height * 0.09,
          bottom: _height * 0.146,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Form(
            key: formKey,
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: _height * 0.018,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: Color(0xFFFF9B6B),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      iconEnabledColor: Colors.white,
                      value: _selectedSchool,
                      items: _schools.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          child: Text(
                            value,
                            style: simpleTextStyle(Colors.white, 16),
                          ),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSchool = value;
                        });
                      },
                      decoration: textFieldInputDecoration(
                        _height * 0.036,
                        'Choose your School',
                        11,
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "School is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: _height * 0.018,
                    ),
                    TextFormField(
                      style: simpleTextStyle(Colors.white, 16),
                      controller: emailTextEditingController,
                      validator: (val) {
                        if (emailExist) {
                          return "Email already Exist";
                        } else {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please enter correct email";
                        }
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
                        return val.length >= 6
                            ? null
                            : "Please provide password with at least 6 characters";
                      },
                      decoration: textFieldInputDecoration(
                          _height * 0.036, 'Password', 11),
                    ),
                    SizedBox(
                      height: _height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      );
    }

    _getHeader() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.049,
            ),
            Text(
              'Awesome, let\'s get your',
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
            Text(
              'account set up!',
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
          ],
        ),
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
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            body: isLoading
                ? Container(child: LoadingScreen(themeOrange))
                : Scaffold(
                    resizeToAvoidBottomInset: false,
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
      ),
    );
  }
}
