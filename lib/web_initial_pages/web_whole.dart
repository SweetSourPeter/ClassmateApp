import 'package:app_test/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:app_test/widgets/logo_widget.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/models/constant.dart';
import 'web_landing_page.dart';
import 'download_landing.dart';
import 'why_landing.dart';
import 'supprt_landing.dart';

class NavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopNavPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return DesktopNavPage();
        } else if (constraints.maxWidth > 360) {
          return MobileNavPage();
        } else {
          return MobileSmallNavPage();
        }
      },
    );
  }
}

class DesktopNavPage extends StatelessWidget {
  var list = ["Download", "Why Meechu?", "Support"];
  var colors = [Colors.orange, Colors.blue, Colors.red, Colors.green];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(
              top: 20, bottom: 20, left: _width * 0.03, right: _width * 0.03),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7D40), //#FF7D40
                  Color(0xFFFF844B), //#FF844B
                  Color(0xFFFFDAC9), //#FFDAC9
                ]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoWidget(80, 89),
                        AutoSizeText(
                          "MEECHU",
                          style: largeTitleTextStyleBold(Colors.white, 26),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: List.generate(3, (index) {
                      return GestureDetector(
                        onTap: () {
                          _scrollToIndex(index);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0.01 * _width, 0),
                          margin: EdgeInsets.all(8),
                          child: AutoSizeText(
                            list[index],
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: 11, horizontal: 0.03 * _width),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Wrapper(true, false, "0", false);
                          },
                        ),
                      );
                    },
                    // onPressed: () => Wrapper(false, false, "0"),
                    child: AutoSizeText(
                      "Open Meechu in Browser(Beta)",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: themeOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: PageView(
                    scrollDirection: Axis.vertical,
                    pageSnapping: false,
                    controller: controller,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: DownloadLanding(),
                      ),
                      SingleChildScrollView(
                        child: WhyLanding(),
                      ),
                      SingleChildScrollView(
                        child: SupportLanding(),
                        // child: Center(
                        //   child: Text(
                        //     "Support",
                        //     style: TextStyle(color: Colors.white, fontSize: 50),
                        //   ),
                        // ),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  void _scrollToIndex(int index) {
    controller.animateToPage(index,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
  }
}

class MobileNavPage extends StatelessWidget {
  var list = ["Download", "Why Meechu?", "Support"];
  var colors = [Colors.orange, Colors.blue, Colors.red, Colors.green];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7D40), //#FF7D40
                  Color(0xFFFF844B), //#FF844B
                  Color(0xFFFFDAC9), //#FFDAC9
                ]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoWidget(60, 65),
                        AutoSizeText(
                          "MEECHU",
                          style: largeTitleTextStyleBold(Colors.white, 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return GestureDetector(
                      onTap: () {
                        _scrollToIndex(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: AutoSizeText(
                          list[index],
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: PageView(
                    scrollDirection: Axis.vertical,
                    pageSnapping: false,
                    controller: controller,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: DownloadLanding(),
                      ),
                      SingleChildScrollView(
                        child: WhyLanding(),
                      ),
                      SingleChildScrollView(
                        child: SupportLanding(),
                        // child: Center(
                        //   child: Text(
                        //     "Support",
                        //     style: TextStyle(color: Colors.white, fontSize: 50),
                        //   ),
                        // ),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  void _scrollToIndex(int index) {
    controller.animateToPage(index,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
  }
}

class MobileSmallNavPage extends StatelessWidget {
  var list = ["Download", "Why Meechu?", "Support"];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7D40), //#FF7D40
                  Color(0xFFFF844B), //#FF844B
                  Color(0xFFFFDAC9), //#FFDAC9
                ]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoWidget(60, 65),
                        AutoSizeText(
                          "MEECHU",
                          style: largeTitleTextStyleBold(Colors.white, 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return GestureDetector(
                      onTap: () {
                        _scrollToIndex(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6),
                        child: AutoSizeText(
                          list[index],
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: PageView(
                    scrollDirection: Axis.vertical,
                    pageSnapping: false,
                    controller: controller,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: DownloadLanding(),
                      ),
                      SingleChildScrollView(
                        child: WhyLanding(),
                      ),
                      SingleChildScrollView(
                        child: SupportLanding(),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  void _scrollToIndex(int index) {
    controller.animateToPage(index,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
  }
}

// void _navigateToStart(BuildContext context) {
//   ExtendedNavigator.of(context).push(
//     Routes.wrapper,
//     arguments: WrapperArguments(reset: false),
//   );
// }