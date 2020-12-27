import 'package:flutter/material.dart';

class CourseChat extends StatefulWidget {
  @override
  _CourseChatState createState() => _CourseChatState();
}

class _CourseChatState extends State<CourseChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: _GooglePlayAppBar(),
        ),
      ),
    );
  }
}

Widget _GooglePlayAppBar() {
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: IconButton(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.blueGrey,
            ),
            onPressed: null,
          ),
        ),
        Container(
          child: Text(
            'Google Play',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          child: IconButton(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.blueGrey,
            ),
            onPressed: null,
          ),
        ),
      ],
    ),
  );
}
