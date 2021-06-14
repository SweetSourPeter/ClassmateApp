import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';


class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeOrange,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text(
              '404 page not found',
            ),
          ),
        ),
      ),
    );
  }
}
