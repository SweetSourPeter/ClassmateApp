import 'package:app_test/MainMenu.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openStartPage();
  }

  openStartPage() async {
    await Future.delayed(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Wrapper(false, false, "0"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeOrange,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Transform.scale(
              scale: 1.2,
              child: LogoWidget(140, 156),
            ),
          ),
        ],
      ),
    );
  }
}
