import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReportUser extends StatefulWidget {
  final String badUserEmail;
  final String profileID;

  const ReportUser({Key key, this.profileID, this.badUserEmail})
      : super(key: key);

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

  void saveReportData(String reports, String badUserID, String badUserEmail,
      String goodUserID) {
    //TODO change bad user ID
    databaseMehods.saveReports(reports, badUserID, badUserEmail, goodUserID);
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

  Padding topLineBar() {
    return Padding(
        padding: EdgeInsets.only(top: 15, bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
            bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0),
          ),
          child: SizedBox(
            width: 38.0,
            height: 3.0,
            child: const DecoratedBox(
              decoration: const BoxDecoration(color: Color(0xffFF9E70)),
            ),
          ),
        )
        // child: Container(
        //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
        //   color: Colors.black,
        // )
        );
  }

  SingleChildScrollView userTypeTheProblem(
      BuildContext context, String userID) {
    return SingleChildScrollView(
        child: Column(
      children: [
        topLineBar(),
        Container(
          width: 64,
          height: 24,
          alignment: Alignment.center,
          child: Text(
            'Report',
            style:
                GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Divider(
          thickness: 1,
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 35),
          alignment: Alignment.centerLeft,
          child: Text(
            'Tell us what\'s wrong?',
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 35, top: 5, bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'We won\'t let them know if you take any of these actions.',
            style: TextStyle(
              color: Color(0xff6F6F6F),
              fontSize: 10,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  35.0, 10.0, 35.0, 0.0), // conten// t padding
              child: TextField(

                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: reportTextEditingController,
                decoration: new InputDecoration(
                    focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Color(0xffD0CBC4),
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Color(0xffD0CBC4),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 12,
                      color: Color(0xffA8A8A8)
                    ),
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Tell us what\'s wrong',
              )
                // buildInputDecorationPinky(
                //     false, Icon(Icons.ac_unit), 'Tell us what\'s wrong', 30),
              ),
            ) // From with TextField inside
            ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setIndex(2);
            saveReportData(reportTextEditingController.text, widget.profileID,
                widget.badUserEmail, userID);
          },
          child: SizedBox(
            height: 40,
            child: Text(
              'Submit',
              style: GoogleFonts.openSans(
                color: Color(0xffFF7E40),
                fontSize: 16,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
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
            topLineBar(),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 35),
              alignment: Alignment.centerLeft,
              child: Text(
                'Why are you reporting this person?',
                style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 35, top: 5, bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                'We won\'t let them know if you take any of these actions.',
                style: TextStyle(
                  color: Color(0xff6F6F6F),
                  fontSize: 10,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setIndex(2);
                saveReportData('Pretending to be a Real Person',
                    widget.profileID, widget.badUserEmail, userID);
              },
              child: Container(
                padding: EdgeInsets.only(left: 35, right: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pretending to be a Real Person',
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    Image.asset(
                      'assets/images/arrow-forward.png',
                      color: Color(0xff949494),
                      width: 8,
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setIndex(2);
                saveReportData('Pretending to be Someone Fake',
                    widget.profileID, widget.badUserEmail, userID);
              },
              child: Container(
                padding: EdgeInsets.only(left: 35, right: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pretending to be Someone Fake',
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    Image.asset(
                      'assets/images/arrow-forward.png',
                      color: Color(0xff949494),
                      width: 8,
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setIndex(2);
                saveReportData('Posting inappropriate Things', widget.profileID,
                    widget.badUserEmail, userID);
              },
              child: Container(
                padding: EdgeInsets.only(left: 35, right: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posting inappropriate Things',
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    Image.asset(
                      'assets/images/arrow-forward.png',
                      color: Color(0xff949494),
                      width: 8,
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setIndex(2);
                saveReportData('Harassment or Bullying', widget.profileID,
                    widget.badUserEmail, userID);
              },
              child: Container(
                padding: EdgeInsets.only(left: 35, right: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Harassment or Bullying',
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    Image.asset(
                      'assets/images/arrow-forward.png',
                      color: Color(0xff949494),
                      width: 8,
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setIndex(1),
              child: Container(
                padding: EdgeInsets.only(left: 35, right: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Something Else...',
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    Image.asset(
                      'assets/images/arrow-forward.png',
                      color: Color(0xff949494),
                      width: 8,
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 20,
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
