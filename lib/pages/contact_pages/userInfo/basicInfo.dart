import 'package:app_test/models/user.dart';
import 'package:app_test/widgets/animatedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'topBar.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfo extends StatelessWidget{

  const BasicInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int matchingPercentage = 80;

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
            alignment: Alignment(0,0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 68.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/olivia.jpg'),
                    radius: 60.0,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                ShrinkButton(
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
                    color: Colors.white
                  ),
                  finalStyle: GoogleFonts.openSans(
                    fontSize: 10.0,
                    color: Colors.white
                  ),
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
                  onPressed: (){
                    //show dialog
                    dropDownDialog(context);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Alexandra Murphy",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: themeOrange,
                  )
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "amurphy@bu.edu",
                  style: GoogleFonts.openSans(
                    fontSize: 10.0,
                    color: Colors.black
                  )
                )
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }

}

Future dropDownDialog(context) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Color(0x01000000),
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
        child: child,
      );
    },
  );
}