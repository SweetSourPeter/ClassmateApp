import "package:flutter/material.dart";
import 'package:app_test/services/auth.dart';


class forgetpassword extends StatefulWidget {
  @override
  _forgetpasswordState createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool hasSend = false;
  TextEditingController emailTextEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: isLoading ? Container(
        child:  Center(child: CircularProgressIndicator())) :
      
      CustomPaint(
        painter: BackgroundSignUp(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 90),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getTextFields(),
                  _enterEmail(),
                  
                ],
              ),
            ),
            _getBackBtn()
          ],
        ),
      ),
    );
  }

sendIt() {

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
        hasSend = true;
        authMethods.resetPassword(emailTextEditingController.text).then((val){
          // print("${val.uid}");
          // Navigator.pushReplacement(context, MaterialPageRoute(
          //   builder: (context) => MainMenu()

          // ));
        });
      });

      
    }
  }



_enterEmail() {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: hasSend? <Widget>[
        Text('Check your email to reset your password\n',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
        GestureDetector(
          onTap: (){
            //todo
            sendIt();
          },
                  child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            radius: 40,
            child: Icon(
              Icons.replay,
              color: Colors.white,
            ),
          ),
        )
        //IF it has not sent the email
      ] : <Widget>[
          Text('Please enter the email of your account\n',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
        GestureDetector(
          onTap: (){
            //todo
            sendIt();
          },
                  child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            radius: 40,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        )
      ]
    ),
  );
}

_getBackBtn() {
  return Positioned(
    top: 35,
    left: 25,
    child: Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
  );
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Find\nYour Account',
        style: TextStyle(color: Colors.white, fontSize: 40),
      ),
    ),
  );
}

_getTextFields() {
  // return Expanded(
  //   flex: 4,
  //   child: Form(
  //         child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         SizedBox(
  //           height: 15,
  //         ),
  //         TextField(
  //           decoration: InputDecoration(
  //             enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  //             labelText: 'Enter your Email', labelStyle: TextStyle(color: Colors.white)),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  return Expanded(
    flex: 4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
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
                validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Please enter correct email";
                        },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Enter Your Email', labelStyle: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 20,
              ),
          ],),
        ),
      ),
        )] 
        
      
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
