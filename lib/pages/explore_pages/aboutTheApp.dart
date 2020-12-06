import 'package:app_test/models/constant.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:flutter/material.dart';

class AboutTheAPP extends StatelessWidget {
  const AboutTheAPP({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
            // centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.white,
            // title: Text("Create Course"),
          ),
          body: Center(
              child: Column(
            children: [LogoWidget()],
          ))),
    );
  }
}
