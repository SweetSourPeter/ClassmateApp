import 'package:app_test/views/MainMenu.dart';
import 'package:app_test/views/forgetpassword.dart';
import 'package:app_test/views/sign_up.dart';
import "package:flutter/material.dart";
import 'package:app_test/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

final formKey = GlobalKey<FormState>();
bool isLoading = false;

AuthMethods authMethods = new AuthMethods();

TextEditingController emailTextEditingController = new TextEditingController();
TextEditingController passwordTextEditingController =
    new TextEditingController();

class _SignInState extends State<SignIn> {
  signMeIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
        authMethods
            .signInWithEmailAndPassword(emailTextEditingController.text,
                passwordTextEditingController.text)
            .then((val) {
          isLoading = false;
          // print("${val.uid}");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainMenu()));
        });
      });
    }
  }

  //below for the wiget
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //gesturedetector used for hiding the keyboard after click anywhere else
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : CustomPaint(
                painter: BackgroundSignIn(),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: <Widget>[
                          _getHeader(),
                          _getTextFields(),
                          _getSignIn(),
                          _getBottomRow(context),
                        ],
                      ),
                    ),
                    // _getBackBtn(),
                  ],
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

  _getBottomRow(context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => forgetpassword()));
            },
            child: Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
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
          GestureDetector(
            onTap: () {
              authMethods.signInWithGoogle(context);
            },
            child: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                radius: 40,
                child: Text("G",
                    style: TextStyle(color: Colors.white, fontSize: 30))),
          ),
          // Text(
          //   'Sign in',
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          // ),
          GestureDetector(
            onTap: () {
              signMeIn();
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
                  TextFormField(
                    controller: emailTextEditingController,
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please enter correct email";
                    },
                    decoration: InputDecoration(labelText: 'Email'),
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
                          : "Please provoid valid password format";
                    },
                    decoration: InputDecoration(labelText: 'Password'),
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

// _getTextFields() {
//   return Expanded(
//     flex: 4,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: <Widget>[
//         SizedBox(
//           height: 15,
//         ),
//         TextField(
//           controller: emailTextEditingController,
//           decoration: InputDecoration(labelText: 'Email'),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         TextField(
//           controller: passwordTextEditingController,
//           decoration: InputDecoration(labelText: 'Password'),
//         ),
//         SizedBox(
//           height: 25,
//         ),
//       ],
//     ),
//   );
// }

  _getHeader() {
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Text(
          'Welcome\nBack',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),
    );
  }
}

class BackgroundSignIn extends CustomPainter {
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
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    blueWave.close();
    paint.color = Colors.lightBlue.shade300;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.orange.shade300;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
