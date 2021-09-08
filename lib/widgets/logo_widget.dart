import 'package:flutter/material.dart';

//  height: 140,
// width: 156,
class LogoWidget extends StatelessWidget {
  LogoWidget(this.height, this.width);

  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: FittedBox(
          child: Image.asset('assets/icon/white logo@3x.png'),
          fit: BoxFit.fill,
        ));
  }
}
