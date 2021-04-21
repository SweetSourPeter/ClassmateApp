import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterInviteCode extends StatefulWidget {
  const EnterInviteCode({
    Key key,
  }) : super(key: key);

  @override
  _EnterInviteCodeState createState() => _EnterInviteCodeState();
}

class _EnterInviteCodeState extends State<EnterInviteCode> {
  TextEditingController userIDTextEditingController =
      new TextEditingController();
  PageController _pageController;
  final GlobalKey<FormState> _formKeyGroupID = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    DatabaseMethods databaseMethods = DatabaseMethods();
    _toastInfo(String info) {
      Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER,
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
            AutoSizeText(
              'Enter your Friend\'s ',
              style: largeTitleTextStyleBold(Colors.black, 22),
            ),
            AutoSizeText(
              'Invite Code ',
              style: largeTitleTextStyleBold(Colors.black, 22),
            ),
          ],
        ),
      );
    }

    _urlForm() {
      return Form(
        key: _formKeyGroupID,
        child: Container(
          height: 100,
          child: TextFormField(
            controller: userIDTextEditingController,
            decoration: buildInputDecorationPinky(
              false,
              Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              'Invite code',
              11,
            ),
            validator: (String value) {
              if (value == userdata.userID) {
                return 'Invite Code must from other users';
              }
              if (value == null) {
                return 'Please fill in code';
              }

              // if (!RegExp(
              //         r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$')
              //     .hasMatch(value.toUpperCase())) {
              //   return "Group ID is not Valid";
              // }
              return null;
            },
          ),
        ),
      );
    }

    _getRules() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.037,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _width * 0.04,
                vertical: _height * 0.037,
              ),
              child: AutoSizeText(
                'Invite Code helps you get FREE Open Seat Alerts：\n\n 1. Two free alerts when you first signup \n\n 2. Two free alerts for each of the first two users who used your invite code \n\n 3. Unlock unlimite alerts when three users used your invite code',
                style: simpleTextStyle(Colors.black, 16),
              ),
            ),
            SizedBox(
              height: _height * 0.08,
            ),
          ],
        ),
      );
    }

    _getInviteCode() {
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
          color: themeOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async {
            print(userdata.userID);
            print(userdata.invitedUserID);
            await databaseMethods
                .getUserDetailsByID(userIDTextEditingController.text)
                .catchError((e) {
              _toastInfo('the code is invalid, Please check your spelling');
            }).then((value) async {
              print('object');
              if (value == null) {
                //TODO if the user dont exitst
                print('null users id');
                _toastInfo('the code is invalid, Please check your spelling');
              } else if (userIDTextEditingController.text == userdata.userID) {
                _toastInfo('the code is invalid, Please don\'t use your own');
              } else if (value.invitedUserID == null) {
                await databaseMethods.updateUserInvite(
                    userIDTextEditingController.text,
                    [userdata.userID]).then((value) {
                  _toastInfo('Success!');
                  Navigator.pop(context);
                });
              } else {
                if (value.invitedUserID
                    .contains(userIDTextEditingController.text)) {
                  //TODO if the user ID has been used
                  _toastInfo('You have used this code before');
                } else {
                  print('object valid every thing');
                  var inviteUserTemp = value.invitedUserID;
                  if (value.invitedUserID == null) {
                    inviteUserTemp = [userdata.userID];
                  } else {
                    inviteUserTemp = value.blockedUserID;

                    inviteUserTemp.add(userdata.userID);
                  }
                  await databaseMethods
                      .updateUserInvite(userIDTextEditingController.text,
                          inviteUserTemp.cast<String>())
                      .then((value) {
                    _toastInfo('Success!');
                    Navigator.pop(context);
                  });
                }
              }
            });
          },
          child: AutoSizeText(
            'Submit Invite Code',
            style: simpleTextSansStyleBold(Colors.white, 16),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        //close the key board
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 14, top: 15),
                      child: Container(
                        // color: orengeColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: kDefaultPadding),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 27,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                right: 39,
                                bottom: _height * 0.1,
                              ),
                              //TODO replace Icon
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    new ClipboardData(
                                        text: '${userdata.userID}'),
                                  ).then((result) {
                                    _toastInfo('Copied');
                                  });
                                },
                                child: Text(
                                  'My Code',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.openSans(
                                    color: themeOrange,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _getHeader(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: _width * 0.08,
                      right: _width * 0.08,
                      top: _height * 0.2,
                      bottom: _height * 0.03,
                    ),
                    child: _urlForm(),
                  ),
                  ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AutoSizeText(
                        'What is invite code for?',
                        textAlign: TextAlign.center,
                        style: simpleTextStyle(Colors.black, 14),
                      ),
                    ),
                    // collapsed: Text(
                    //   'article.body',
                    //   softWrap: true,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    expanded: _getRules(),
                    tapBodyToCollapse: true,
                    // ignore: deprecated_member_use
                    tapHeaderToExpand: true,
                    // ignore: deprecated_member_use
                    hasIcon: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _getInviteCode(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
