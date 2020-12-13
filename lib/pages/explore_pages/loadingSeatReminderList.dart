import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: whiteAndGray,
          size: 50.0,
        ),
      ),
    );
  }
}
