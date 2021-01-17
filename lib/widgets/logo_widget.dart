import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140,
        width: 156,
        child: FittedBox(
          child: Image.asset('assets/icon/white logo@3x.png'),
          fit: BoxFit.fill,
        ));
  }
}
