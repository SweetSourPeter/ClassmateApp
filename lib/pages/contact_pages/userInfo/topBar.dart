import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:flutter/services.dart';
import 'package:app_test/pages/explore_pages/reportUser.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget {
  final String userID;
  final String userName;
  final String profileUserEmail;
  final String currentUserEmail;
  final String currentUserID;
  const TopBar({
    @required this.userID,
    @required this.userName,
    @required this.profileUserEmail,
    @required this.currentUserEmail,
    @required this.currentUserID,
    Key key,
  }) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  // bool isBlocked = false;
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData>(context, listen: false);
    // if () {
    //   isBlocked = ();
    // }

    double _height = MediaQuery.of(context).size.height;
    double _width = getRealWidth(MediaQuery.of(context).size.width);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: themeOrange,
            ),
            color: Colors.black,
            onPressed: () {
              //navigate to previous page
              Navigator.pop(context);
              print("previous page");
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            color: themeOrange,
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
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: _height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print(currentUser.blockedUserID != null &&
                                    currentUser.blockedUserID
                                        .contains(widget.userID));
                                if (currentUser.blockedUserID != null &&
                                    currentUser.blockedUserID
                                        .contains(widget.userID)) {
                                  print('Called');
                                  var blockedUserTemp =
                                      currentUser.blockedUserID;

                                  blockedUserTemp.remove(widget.userID);
                                  databaseMethods
                                      .updateUserBlock(widget.currentUserID,
                                          blockedUserTemp.cast<String>())
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  var blockedUserTemp =
                                      currentUser.blockedUserID;
                                  if (currentUser.blockedUserID == null) {
                                    print('1');
                                    blockedUserTemp = [widget.userID];
                                  } else {
                                    blockedUserTemp = currentUser.blockedUserID;

                                    blockedUserTemp.add(widget.userID);
                                  }

                                  databaseMethods
                                      .updateUserBlock(widget.currentUserID,
                                          blockedUserTemp.cast<String>())
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    (currentUser.blockedUserID != null &&
                                            currentUser.blockedUserID
                                                .contains(widget.userID))
                                        ? 'unBlock'
                                        : "Block",
                                    style: GoogleFonts.openSans(
                                        fontSize: 18.0,
                                        color: (currentUser.blockedUserID !=
                                                    null &&
                                                currentUser.blockedUserID
                                                    .contains(widget.userID))
                                            ? themeOrange
                                            : Colors.black),
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
                                showBottomPopSheet(
                                    context,
                                    ReportUser(
                                      badUserEmail: widget.profileUserEmail,
                                      profileID: widget.userID,
                                    ));
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Report",
                                    style: GoogleFonts.openSans(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  new ClipboardData(
                                      text: '${widget.profileUserEmail}'),
                                ).then((result) {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'The user Profile Email is copied.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Copy Profile Email",
                                    style: GoogleFonts.openSans(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(
                                        text:
                                            'Join me on Meechu!!!\nDownload "Meechu" on mobile and search your classmates with email.\n\nEmail: ${widget.profileUserEmail}'))
                                    .then((result) {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'You can PASTE to Share this profile with others.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              child: Center(
                                child: Material(
                                  child: Text(
                                    "Share This Profile",
                                    style: GoogleFonts.openSans(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //               EdgeInsets.symmetric(
                        // horizontal: _width * 0.065, vertical: _height * 0.046),
                        margin: EdgeInsets.only(
                            bottom: _height * 0.0086,
                            left: _width * 0.065,
                            right: _width * 0.065),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(23.0)),
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
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(
                            bottom: _height * 0.04,
                            left: _width * 0.065,
                            right: _width * 0.065),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                      SizedBox(
                        height: 8,
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
