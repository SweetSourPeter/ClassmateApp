import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/explore_pages/reportUser.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // void showBottomSheet() {
    //   showModalBottomSheet(
    //       shape: RoundedRectangleBorder(
    //           side: BorderSide(width: 15, color: Colors.transparent),
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(30.0),
    //             topRight: Radius.circular(30.0),
    //             // bottomLeft: Radius.circular(30.0),
    //             // bottomRight: Radius.circular(30.0),
    //           )),
    //       context: context,
    //       isScrollControlled: true,
    //       builder: (context) {
    //         return ReportUser();
    //       });
    // }

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              //navigate to previous page
              Navigator.pop(context);
              print("previous page");
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: () {
              //navigate to previous page
              showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: Duration(milliseconds: 200),
                pageBuilder: (context, anim1, anim2) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 400,
                      ),
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("blocked");
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Block",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20.0, color: themeOrange),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("reported");
                                Navigator.of(context).pop();
                                showBottomPopSheet(context, ReportUser());
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Report",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20.0, color: themeOrange),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("copied");
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Copy Profile URL",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("shared");
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Share This Profile",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      Container(
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Material(
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.openSans(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(
                            bottom: 5.0, left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ],
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
