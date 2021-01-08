import 'package:app_test/models/user.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/animatedButton.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'topBar.dart';
import 'package:app_test/models/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfo extends StatefulWidget {
  final String userID;
  final Future<UserTags> userTag;
  final Future<UserData> userData;
  BasicInfo({
    Key key,
    @required this.userID,
    @required this.userTag,
    @required this.userData,
  }) : super(key: key);

  @override
  _BasicInfoState createState() => _BasicInfoState(
        userID,
        userTag,
        userData,
      );
}

class _BasicInfoState extends State<BasicInfo> {
  String userID;
  Future<UserTags> userTag;
  Future<UserData> userData;
  _BasicInfoState(this.userID, this.userTag, this.userData); //constructor
  final databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    int matchingPercentage = 80;
    return FutureBuilder(
        future: Future.wait([widget.userData, widget.userTag]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: _height * 0.45,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(0, 0.2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          height: 130,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: (_width / 2) - (119 / 2),
                                child: CircleAvatar(
                                  backgroundColor: themeOrange,
                                  radius: 119 / 2,
                                ),
                              ),
                              Positioned(
                                left: (_width / 2) - (119 / 2) + 4,
                                bottom: 4,
                                child:
                                    createUserImage(111 / 2, snapshot.data[0]),
                              ),
                              Positioned(
                                left: (_width / 2) - (119 / 2),
                                bottom: 0,
                                child: Container(
                                    height: 130,
                                    width: 119,
                                    child: FittedBox(
                                      child: Image.asset(
                                          'assets/icon/earCircle.png'),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.028,
                        ),
                        Text(
                          snapshot.data[0].userName,
                          style: largeTitleTextStyleBold(themeOrange, 18),
                        ),
                        Text(snapshot.data[0].email,
                            style: GoogleFonts.openSans(
                              fontSize: 16.0,
                              color: Color(0xFF636363),
                            )),
                        SizedBox(
                          height: _height * 0.028,
                        ),
                        ShrinkButton(
                          profileColor: snapshot.data[0].profileColor,
                          userTag: snapshot.data[1],
                          userName: snapshot.data[0].userName,
                          width: 90.0,
                          height: 30.0,
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [
                          //     listProfileColor[
                          //         snapshot.data[0].profileColor.toInt()],
                          //     listProfileColor[
                          //         snapshot.data[0].profileColor.toInt()],
                          //   ],
                          // ),
                          gradient:
                              listColors[snapshot.data[0].profileColor.toInt()],
                          duration: Duration(milliseconds: 100),
                          initialText: matchingPercentage.toString() + "%",
                          finalText: " match",
                          initialStyle: GoogleFonts.montserrat(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          finalStyle: GoogleFonts.openSans(
                              fontSize: 10.0, color: Colors.white),
                          onPressed: () {
                            //TODO
                          },
                        ),
                      ],
                    ),
                  ),
                  TopBar(
                    userID: userID,
                    userName: snapshot.data[0].userName,
                    profileUserEmail: snapshot.data[0].email,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

// class CustomDialog extends StatelessWidget {
//   final String name;
//   const CustomDialog(this.name, {Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         child: dialogContent(context),
//       ),
//     );
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.only(
//             top: 100,
//             bottom: 16,
//             left: 16,
//             right: 16,
//           ),
//           margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(17),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black,
//                     blurRadius: 10.0,
//                     offset: Offset(0.0, 10.0))
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
// Future dropDownDialog(context) {
//   return showGeneralDialog(
//     context: context,
//     barrierLabel: "Barrier",
//     barrierDismissible: true,
//     barrierColor: Color(0x01000000),
//     transitionDuration: Duration(milliseconds: 200),
//     pageBuilder: (context, anim1, anim2) {
//       return Container();
//     },
//     transitionBuilder: (context, anim1, anim2, child) {
//       return FadeTransition(
//         opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
//         child: Container(
//           height: 10,
//         ),
//       );
//     },
//   );
// }
