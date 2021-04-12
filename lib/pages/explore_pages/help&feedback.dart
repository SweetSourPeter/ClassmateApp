import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpFeedback extends StatefulWidget {
  final String userEmail;
  const HelpFeedback({
    Key key,
    this.userEmail,
  }) : super(key: key);

  @override
  _HelpFeedbackState createState() => _HelpFeedbackState();
}

class _HelpFeedbackState extends State<HelpFeedback> {
  DatabaseMethods databaseMehods = new DatabaseMethods();
  List<String> faqTitle = [
    'Course FAQ',
    'Friends FAQ',
    'Course Seats FAQ',
    'Personal Account FAQ',
  ];
  List<String> courseIssue10 = [
    'Course FAQ',
    'How do I delete my course?',
    'I cannot find the course I am taking. How do I create a group chat for it?',
    'I found a toxic individual in the chat. How do I report?',
    'What should I do if I found someone cheating?',
    'How do I transmit files to my friends?',
    'else...'
  ];
  List<String> friendsIssue20 = [
    'Friends FAQ',
    'How do I delete my friends?',
    'Why is friend added automatically?',
    'How do I report another user?',
    'How do I transmit files to my friends?',
    'How can I view friends\' course List?'
  ];
  List<String> setNotifierIssue30 = [
    'Seat Notifier FAQ',
    'Where do I find my email notifications?',
    'How do I cancel a certain notification?',
    'Why am I not getting the emails?',
    'Why is open seat alert not available to my school?',
    'I would like to access the open seat alert at my school, how may I do that? '
  ];
  List<String> accountIssue40 = [
    'Account FAQ',
    'How do I change app theme Color?',
    'How do I logout? ',
    'What are my tags used for?',
    'How do I change my school?',
    'How do I change my email?'
  ];

  var pageIndex = 0;
  void setIndex(int value) {
    setState(() {
      pageIndex = value;
    });
    print(pageIndex);
    print((pageIndex / 10 % 10).toInt() * 10);
  }

  void saveReportData(String reports, String userEmail, String userID) {
    //TODO change bad user ID
    databaseMehods.saveReportsFAQ(reports, userEmail, userID);
  }

  TextEditingController reportTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    switch (pageIndex) {
      case 0:
        return reportSelectingPage(user.userID);
      case 50:
        return userTypeTheProblem(context, user.userID, widget.userEmail);
      case 100:
        return fqaPage(user.userID);
      case 10:
      case 20:
      case 30:
      case 40:
        return issueCaseSwitching(user.userID);
      default:
        return faqAnswer(user.userID);
    }
    // userTypeTheProblem(context);
    // reportSelectingPage();
  }

  Container fqaPage(String userID) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
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
      BuildContext context, String userID, String userEmail) {
    print(userEmail);
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        topLineBar(),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                    onTap: () {
                      setIndex(0);
                    },
                    child: Icon(Icons.chevron_left, size: 34))),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Something Else...',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
            if (reportTextEditingController.text.isNotEmpty) {
              setIndex(100);
              saveReportData(
                  reportTextEditingController.text, userEmail, userID);
            }
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

  SingleChildScrollView faqAnswer(String userID) {
    List<String> courseIssueDetails = [
      'Course Issue',
      'Press and hold the course card for one second. A flow window will pop out with options including delete and share.',
      'To create a new course group chat, go to search/add course page and click on the blue \'Tap here\' text box.',
      'To report a user, navigate to the user profile page and click on the top right icon (three dots), and select "report". ',
      'If you found someone cheating, please advise your course professor to take action.',
      'Unfortunately, file transmission is not supported in this version. To share file, you may use DropBox or Google Drive, and share the link via chat.',
    ];
    List<String> friendsIssueDetails = [
      'Friends Issue',
      'Not supported yet.',
      'With a design goal of nourishing an open and friendly environment, we are experimenting by not including an adding friend function on your part, instead, friends are added automatically.  We would like to know your take on this!',
      'To report a user, navigate to the user profile page and click on the top right icon (three dots), and select "report".',
      'Unfortunately, file transmission is not supported in this version. To share file, you may use DropBox or Google Drive, and share your link via chat.',
      'Navigate to the a user profile to view his/her course list. If such list is not found, that user probably set such list as private, or has not added a course yet.',
    ];
    List<String> seatsNotifierIssueDetails = [
      'Seats Notifier issue',
      'All notification emails are sent to the email address that you used to setup your account.',
      'To cancel notification, press and hold the notification card and select the delete option.',
      'Check your email spam folder, and make sure email from us no longer goes into spam. Notice our email will usually experience a 3-5 minutes delay.',
      'Open seat alert service is only provided to Boston University users currently.  We are working hard on providing the same service in other schools, and we appreciate your patience. ',
      'Please contact our custom support via naclassmates@gmail.com and let us know.  We are working hard on providing the same service in other schools, and we appreciate your patience. '
    ];
    List<String> accountIssueDetails = [
      'Account Issue',
      'App theme color function will be added in future updates. Thanks for your patience.',
      'To logout, go to the account page. The logout button can be found at the bottom.',
      'Tags enable our algorithm to match you with study mates that suit you. ',
      'Each account can only be linked to one school. A new account has to be registered if you have a change of school.',
      'Each account can only be linked to one email address. A new account has to be registered if you have a change of email.',
    ];
    List<List> issueDetailsList = [
      courseIssueDetails,
      friendsIssueDetails,
      seatsNotifierIssueDetails,
      accountIssueDetails
    ];
    List<List> largeIssueList = [
      courseIssue10,
      friendsIssue20,
      setNotifierIssue30,
      accountIssue40
    ];
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        topLineBar(),
        SizedBox(
          height: 10,
        ),
        Divider(),
        ListTile(
          leading: GestureDetector(
              onTap: () {
                setIndex((pageIndex / 10 % 10).toInt() * 10);
              },
              child: Icon(Icons.chevron_left, size: 34)),
          title: Text(
            largeIssueList[(pageIndex / 10 % 10).toInt() - 1][pageIndex % 10],
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              issueDetailsList[(pageIndex / 10 % 10).toInt() - 1]
                  [pageIndex % 10],
              style: simpleTextStyleBlack(),
            ),
          ),
          // onTap: () => Void //TODO,
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ));
  }

  Container reportSelectingPage(String userID) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
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
                'Here are the FAQ about our service.',
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
                setIndex(10);
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
                setIndex(20);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Course Registration Open Seat Alert',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(30);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Account ',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex(40);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Something Else...',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => setIndex(50),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Container issueCaseSwitching(String userID) {
    List<List> largeIssueList = [
      courseIssue10,
      friendsIssue20,
      setNotifierIssue30,
      accountIssue40
    ];
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            topLineBar(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                        onTap: () {
                          setIndex(0);
                        },
                        child: Icon(Icons.chevron_left, size: 34))),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    largeIssueList[(pageIndex / 10 % 10).toInt() - 1][0],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              title: Text(
                'Here are the FAQ about our service.',
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
                largeIssueList[(pageIndex / 10 % 10).toInt() - 1][1],
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex((pageIndex / 10 % 10).toInt() * 10 + 1);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                largeIssueList[(pageIndex / 10 % 10).toInt() - 1][2],
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex((pageIndex / 10 % 10).toInt() * 10 + 2);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                largeIssueList[(pageIndex / 10 % 10).toInt() - 1][3],
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex((pageIndex / 10 % 10).toInt() * 10 + 3);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                largeIssueList[(pageIndex / 10 % 10).toInt() - 1][4],
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                setIndex((pageIndex / 10 % 10).toInt() * 10 + 4);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Something Else...',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => setIndex(50),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
