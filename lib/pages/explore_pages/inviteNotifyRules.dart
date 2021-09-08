import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class InviteNotifyRules extends StatelessWidget {
  const InviteNotifyRules({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    _getHeader() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.037,
            ),
            AutoSizeText(
              'How To Get',
              style: largeTitleTextStyleBold(Colors.black, 22),
            ),
            AutoSizeText(
              'FREE',
              style: largeTitleTextStyleBold(Colors.black, 22),
            ),
            AutoSizeText(
              'Seat Notification !',
              style: largeTitleTextStyleBold(Colors.black, 22),
            ),
          ],
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
                'Invite Code helps you get FREE Open Seat Alerts：\n\n 1. Two free alerts when you first signup \n\n 2. Two free alerts for each of the first two users who used your invite code \n\n 3. Unlock unlimited alerts when three users used your invite code',
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

    _toastInfo(String info) {
      Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER,
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
          onPressed: () {
            //TODO
            Clipboard.setData(
              new ClipboardData(text: '${userdata.userID}'),
            ).then((result) {
              _toastInfo('Copied');
            });
          },
          child: AutoSizeText(
            'My Invite Code',
            style: simpleTextSansStyleBold(Colors.white, 16),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: riceColor,
      appBar: AppBar(
        leading: Container(
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
        // centerTitle: true,
        elevation: 0.0,
        backgroundColor: riceColor,
        // title: Text("Create Course"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _getHeader(),
            _getRules(),
            _getInviteCode(),
          ],
        ),
      ),
    );
  }
}
