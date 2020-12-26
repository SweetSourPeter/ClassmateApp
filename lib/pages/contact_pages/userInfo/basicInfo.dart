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
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    int matchingPercentage = 80;
    return FutureBuilder(
        future: Future.wait([widget.userData, widget.userTag]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    color: Colors.orange[50],
//            add background image here
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: NetworkImage("https://picsum.photos/200"),
//                fit: BoxFit.cover,
//              )
//            ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60.0,
                          child:
                              createUserImage(sidebarSize / 5, snapshot.data[0]),
                          // creatUserImage(sidebarSize / 5, userData),
                          //     CircleAvatar(
                          //   backgroundImage: AssetImage('assets/images/olivia.jpg'),
                          //   radius: 60.0,
                          // ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        ShrinkButton(
                          userTag: snapshot.data[1],
                          userName: snapshot.data[0].userName,
                          width: 90.0,
                          height: 30.0,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [themeOrange, gradientYellow],
                          ),
                          duration: Duration(milliseconds: 100),
                          initialText: matchingPercentage.toString() + "%",
                          finalText: " match",
                          initialStyle: GoogleFonts.montserrat(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          finalStyle: GoogleFonts.openSans(
                              fontSize: 10.0, color: Colors.white),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Text(
//                        matchingCapacity.toString() + "% ",
//                        style: GoogleFonts.montserrat(
//                          fontSize: 12.0,
//                          fontWeight: FontWeight.bold,
//                          color: Colors.white
//                        )
//                      ),
//                      Text(
//                        "match",
//                        style: GoogleFonts.openSans(
//                          fontSize: 10.0,
//                          color: Colors.white
//                        ),
//                      )
//                    ],
//                  ),
                          onPressed: () {
                            //TODO
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(snapshot.data[0].userName,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: themeOrange,
                            )),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(snapshot.data[0].email,
                            style: GoogleFonts.openSans(
                                fontSize: 10.0, color: Colors.black))
                      ],
                    ),
                  ),
                  TopBar(),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
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
