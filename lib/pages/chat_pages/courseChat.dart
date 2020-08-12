import 'package:flutter/material.dart';

class courseChat extends StatefulWidget {
  @override
  _courseChatState createState() => _courseChatState();
}

class _courseChatState extends State<courseChat> {
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
