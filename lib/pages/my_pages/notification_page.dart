import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/constant.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = maxWidth;

    return Container(
      height: _height * 0.9,
      decoration: BoxDecoration(
        color: themeOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          // bottomLeft: Radius.circular(30.0),
          // bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0),
                bottomLeft: Radius.circular(35.0),
                bottomRight: Radius.circular(35.0),
              ),
              child: SizedBox(
                width: 65.0,
                height: 6.0,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.9 * 0.3,
          ),
          Container(
            child: Text(
              'Would you like to receive notifications from Meechu?',
              style: largeTitleTextStyleBold(Colors.white, 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: _height * 0.9 * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  'Yes',
                  style: largeTitleTextStyleBold(Colors.white, 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Text(
                  'No',
                  style: largeTitleTextStyleBold(Colors.white, 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
