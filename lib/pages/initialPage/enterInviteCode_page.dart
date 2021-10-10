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

class EnterInviteCodeStartPage extends StatefulWidget {
  final PageController pageController;
  const EnterInviteCodeStartPage({
    Key key,
    this.pageController,
  }) : super(key: key);

  @override
  _EnterInviteCodeStartPageState createState() =>
      _EnterInviteCodeStartPageState();
}

class _EnterInviteCodeStartPageState extends State<EnterInviteCodeStartPage> {
  TextEditingController userIDTextEditingController =
      new TextEditingController();

  final GlobalKey<FormState> _formKeyGroupID = GlobalKey<FormState>();
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = maxWidth;
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
              height: _height * 0.2,
            ),
            AutoSizeText(
              'Enter your Friend\'s ',
              style: largeTitleTextStyleBold(Colors.white, 22),
            ),
            AutoSizeText(
              'Invite Code ',
              style: largeTitleTextStyleBold(Colors.white, 22),
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
            decoration: textFieldInputDecoration(
                _height * 0.9 * 0.036,
                // : _height * 0.036,
                'Invite Code...',
                11),
            // buildInputDecorationPinky(
            //   false,
            //   Icon(
            //     Icons.access_time,
            //     color: Colors.black,
            //   ),
            //   'Invite code',
            //   11,
            // ),
            validator: (String value) {
              if (value == user.userID) {
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
                style: simpleTextStyle(Colors.white, 16),
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
          color: ((userIDTextEditingController.text.isNotEmpty))
              ? Colors.white
              : Color(0xFFFF9B6B).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async {
            await databaseMethods
                .getUserDetailsByID(userIDTextEditingController.text)
                .catchError((e) {
              _toastInfo('the code is invalid, Please check your spelling');
            }).then((value) async {
              print('object');
              if (value == null) {
                print(value.userID);
                //TODO if the user dont exitst
                print('null users id');
                _toastInfo('the code is invalid, Please check your spelling');
              } else if (userIDTextEditingController.text == user.userID) {
                _toastInfo('the code is invalid, Please don\'t use your own');
              } else if (value.invitedUserID == null) {
                await databaseMethods.updateUserInvite(
                    userIDTextEditingController.text,
                    [user.userID]).then((value) {
                  _toastInfo('Success!');
                  widget.pageController.animateToPage(1,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInCubic);
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
                    inviteUserTemp = [user.userID];
                  } else {
                    inviteUserTemp = value.blockedUserID;

                    inviteUserTemp.add(user.userID);
                  }
                  await databaseMethods
                      .updateUserInvite(userIDTextEditingController.text,
                          inviteUserTemp.cast<String>())
                      .then((value) {
                    _toastInfo('Success!');
                    widget.pageController.animateToPage(1,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInCubic);
                  });
                }
              }
            });
          },
          child: AutoSizeText(
            'Submit Invite Code',
            style: simpleTextSansStyleBold(
                (userIDTextEditingController.text.isNotEmpty)
                    ? themeOrange
                    : Colors.white,
                16),
          ),
        ),
      );
    }

    _skipButton() {
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
          color: ((userIDTextEditingController.text.isNotEmpty) &&
                  _formKeyGroupID.currentState.validate())
              ? Color(0xFFFF9B6B).withOpacity(1)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInCubic);
          },
          child: AutoSizeText(
            'Skip',
            style: simpleTextSansStyleBold(
                (userIDTextEditingController.text.isNotEmpty)
                    ? Colors.white
                    : themeOrange,
                16),
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
        color: themeOrange,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: themeOrange,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                        style: simpleTextStyle(Colors.white, 14),
                      ),
                    ),
                    // collapsed: Text(
                    //   'article.body',
                    //   softWrap: true,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    expanded: _getRules(),
                    theme: ExpandableThemeData(
                      tapBodyToCollapse: true,
                      // ignore: deprecated_member_use
                      tapHeaderToExpand: true,
                      // ignore: deprecated_member_use
                      hasIcon: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _getInviteCode(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _skipButton(),
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
