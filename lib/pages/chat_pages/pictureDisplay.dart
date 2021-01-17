import 'package:flutter/material.dart';
import 'dart:io';

class PictureDisplay extends StatefulWidget {
  final File imageFile;
  PictureDisplay({this.imageFile});

  @override
  _PictureDisplayState createState() => _PictureDisplayState();
}

class _PictureDisplayState extends State<PictureDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        if (widget.imageFile != null) ...[
          Container(
            height: 300.0,
            width: 300.0,
            child: Image.file(widget.imageFile),
          ),

        ]
      ],
    );
  }
}
