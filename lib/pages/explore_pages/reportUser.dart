import 'dart:ffi';

import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({Key key}) : super(key: key);

  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  DatabaseMethods databaseMehods = new DatabaseMethods();

  var pageIndex = 0;
  void setIndex(int value) {
    setState(() {
      pageIndex = value;
    });
    print(pageIndex);
  }

  void saveReportData(String reports, String badUserID, String goodUserID) {
    //TODO change bad user ID
    databaseMehods.saveReports(reports, badUserID, goodUserID);
  }

  TextEditingController reportTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    switch (pageIndex) {
      case 0:
        return reportSelectingPage(user.userID);
      case 1:
        return userTypeTheProblem(context, user.userID);
      case 2:
        return thankYouPage(user.userID);
      default:
        return reportSelectingPage(user.userID);
    }
    // userTypeTheProblem(context);
    // reportSelectingPage();
  }

  Container thankYouPage(String userID) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topLineBar(),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_circle_outline,
                  color: lightOrangeColor,
                  size: 50,
                )),
            Divider(),
            ListTile(
              title: Text(
                'Thank you for letting us know',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Your feedback is important in helping us keep the community safe',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView userTypeTheProblem(
      BuildContext context, String userID) {
    return SingleChildScrollView(
        child: Column(
      children: [
        topLineBar(),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Report',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            'Tell us what\'s wrong?',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'We won\'t let them know if you take any of these actions.',
            style: TextStyle(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.w300),
          ),
          // onTap: () => Void //TODO,
        ),
        Container(
            // height: 200,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  20.0, 20.0, 20.0, 0.0), // content padding
              child: TextField(
                controller: reportTextEditingController,
                decoration: buildInputDecorationPinky(
                    false, Icon(Icons.ac_unit), 'What happened...', 30),
              ),
            ) // From with TextField inside
            ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setIndex(2);
            saveReportData(reportTextEditingController.text, '1111111', userID);
          },
          child: SizedBox(
            height: 40,
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.blueAccent, fontSize: 20),
            ),
          ),
        ),
      ],
    ));
  }

  Container reportSelectingPage(String userID) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topLineBar(),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Why are you reporting this person?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'We won\'t let them know if you take any of these actions.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
              ),
              // onTap: () => Void //TODO,
            ),
            ListTile(
              title: Text(
                'Pretending to be a Real Person',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
                saveReportData(
                    'Pretending to be a Real Person', '1111111', userID);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Pretending to be Someone Fake',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
                saveReportData(
                    'Pretending to be Someone Fake', '1111111', userID);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Posting inappropriate Things',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
                saveReportData(
                    'Posting inappropriate Things', '1111111', userID);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Harassment or Bullying',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
                saveReportData('Harassment or Bullying', '1111111', userID);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Something Else...',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => setIndex(1),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
