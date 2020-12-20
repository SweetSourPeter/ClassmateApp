import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpFeedback extends StatefulWidget {
  const HelpFeedback({Key key}) : super(key: key);

  @override
  _HelpFeedbackState createState() => _HelpFeedbackState();
}

class _HelpFeedbackState extends State<HelpFeedback> {
  DatabaseMehods databaseMehods = new DatabaseMehods();
  List<String> faqTitle = [
    'Course FAQ',
    'Friends FAQ',
    'Course Seats FAQ',
    'Personal Account FAQ',
  ];
  List<String> faqAnswer = [
    'Course deletion/share can be done by holding on the course widget card.',
    'Friends are added automaticaly after a chat, you can delete the contact by entering their profile page',
    'Course Seats Notification will be sent to your account email when there is a seat. Wecurrently only have this service provide in Boston University',
    'Logout, profile Settings can be found in your personal account page.',
  ];
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
        return fqaPage(user.userID);
      default:
        return reportSelectingPage(user.userID);
    }
    // userTypeTheProblem(context);
    // reportSelectingPage();
  }

  Container fqaPage(String userID) {
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
                'Your feedback is important to our future improvments',
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
            'Issue',
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
            'We will get back to you ASAP.',
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
            // saveReportData(reportTextEditingController.text, '1111111', userID);
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
                'Help & Feedback',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Here are the FQA about our service.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Can\'t find the problem? Click on \'Something Else\'.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
              ),
              // onTap: () => Void //TODO,
            ),
            ListTile(
              title: Text(
                'Course ',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Friends',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Course Seats Notification',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Personal Account ',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(2);
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
