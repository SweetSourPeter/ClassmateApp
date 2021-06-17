import 'package:app_test/models/courseInfo.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class RedirectPage extends StatefulWidget {
  final String courseId;

  RedirectPage({
    this.courseId,
  });

  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final course = Provider.of<List<CourseInfo>>(context);
    return (userdata == null && course == null)
        ? Container()
        : MultiProvider(
            providers: [
              Provider<UserData>.value(
                value: userdata,
              ),
              Provider<List<CourseInfo>>.value(
                value: course,
              ),
            ],
            child: GroupChat(
              courseId: widget.courseId,
              myEmail: userdata.email,
              myName: userdata.userName,
              initialChat: 0,
              isRedirect: true,
            ),
          );
  }
}

Future delay() async {
  await new Future.delayed(new Duration(seconds: 3));
}
