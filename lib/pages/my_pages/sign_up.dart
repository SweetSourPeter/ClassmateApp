import 'package:app_test/MainMenu.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _selectedSchool;
  List<String> _schools = [
    "Boston University",
    "pennsylvania state university",
  ];
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool emailExist = false;
  String errorMessage;

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMehods = new DatabaseMethods();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // TextEditingController usernameTextEditingController =
  //     new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
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

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text, _selectedSchool)
          .then((val) {
        isLoading = false;
        print("User value is " + "${val.user.uid.toString()}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      }).catchError((error) {
        isLoading = false;
        print(error.code);
        String tempError;
        switch (error.code) {
          case "ERROR_OPERATION_NOT_ALLOWED":
            tempError = "Anonymous accounts are not enabled";
            break;
          case "ERROR_WEAK_PASSWORD":
            tempError = "Your password is too weak";
            break;
          case "ERROR_INVALID_EMAIL":
            tempError = "Your email is invalid";
            break;
          case "ERROR_EMAIL_ALREADY_IN_USE":
            tempError = "Email is already in use on different account";
            break;
          case "ERROR_INVALID_CREDENTIAL":
            tempError = "Your email is invalid";
            break;
          default:
            tempError = "An undefined Error happened.";
        }
        print(tempError + 'this is it');
        setState(() {
          errorMessage = tempError;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(tempError),
          duration: Duration(seconds: 3),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : CustomPaint(
                painter: BackgroundSignUp(),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      // child: Container(
                      child: Column(
                        children: <Widget>[
                          _getHeader(),
                          _getTextFields(),
                          _getSignIn(),
                          _getBottomRow(context),
                        ],
                      ),
                      // ),
                    ),
                    _getBackBtn()
                  ],
                ),
              ),
      ),
    );
  }

  _getBackBtn() {
    return Positioned(
      top: 35,
      left: 25,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  _getBottomRow(context) {
    return Expanded(
      flex: 1,
      child: Row(
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
      ),
    );
  }

  _getSignIn() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Sign up',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: () {
              //sign up revoked
              emailExist = false;
              signMeUp();
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 40,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _getTextFields() {
    return Expanded(
      flex: 4,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    iconEnabledColor: Colors.white,
                    value: _selectedSchool,
                    items: _schools.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSchool = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'School',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "School is required";
                      }
                      return null;
                    },
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // TextFormField(
                  //   validator: (val) {
                  //     if (val.isEmpty)
                  //       return "The name can't be empty";
                  //     else if (val.length < 4)
                  //       return "The name length must be greater than 4";
                  //     else
                  //       return null;
                  //   },
                  //   controller: usernameTextEditingController,
                  //   decoration: InputDecoration(
                  //       enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white)),
                  //       labelText: 'UserName',
                  //       labelStyle: TextStyle(color: Colors.white)),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
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
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Please provoid password with at least 6 words";
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    height: 25,
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
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Text(
          'Create\nAccount',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),
    );
  }
}

//used for both SignUp & ForgetPassword page
class BackgroundSignUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.55, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = Colors.lightBlue.shade300;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
