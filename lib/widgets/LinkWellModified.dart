library linkwell;

import 'package:app_test/models/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class Helper {
  const Helper(this.value);

  static var regex = new RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

  static var phoneRegex = new RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)");

  static var defaultTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );

  static var linkDefaultTextStyle = TextStyle(fontSize: 17, color: Colors.blue);

  final int value;
}

TextSpan linkwellFunc(
  String text,
  TextStyle style,
  TextStyle linkStyle,
  UserData currentUser,
) {
  final RegExp exp = Helper.regex;
  final List links = <String>[];
  final List textSpanWidget = <TextSpan>[];
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  Map<String, String> listOfNames;

  /// We now run a forEach Loop to add our matche to
  /// the links List
  matches.forEach((match) {
    links.add(text.substring(match.start, match.end));
  });
  _buildNormalText() {
    /// Adds TextSpan to textSpanWidget
    /// checks if style is null and set deafult style
    /// otherwise set style to user defined
    textSpanWidget.add(TextSpan(
        text: text, style: style == null ? Helper.defaultTextStyle : style));
  }

  _joinMeeting(String chatRoomId) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // old version jitsi meet
      // FeatureFlag featureFlag = FeatureFlag();
      // featureFlag.welcomePageEnabled = false;
      // not sure how to use this in new version
      // featureFlagEnum.RESOLUTION = FeatureFlagVideoResolution
      //     .MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions()
        ..serverURL = chatRoomId // Required, spaces will be trimmed
        // ..serverURL = "https://na-cc.com"
        ..subject = chatRoomId
        ..userDisplayName = currentUser.userName
        ..userEmail = currentUser.email
        // ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true
        ..featureFlags.addAll(featureFlags);

      await JitsiMeet.joinMeeting(options).then((value) {});
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  _buildBody() async {
    /// var t is assigned to class text

    var t = text;

    /// a foreach is run on all the links found
    links.forEach((value) async {
      /// var wid which represents widget

      var wid = t.split(value.trim());

      /// if not value is found after splitting
      /// we simple place text inside TextSpan
      /// and add to textSpanWidget
      if (wid[0] != '') {
        var text = TextSpan(
          text: wid[0],
          style: style == null ? Helper.defaultTextStyle : style,
        );

        /// added
        textSpanWidget.add(text);
      }

      /// when a link is found
      /// we check if its an email,
      /// so we can instruct url_launcher
      /// that this is an email
      if (value.toString().contains('@') && !value.toString().contains('/')) {
        final Uri params = Uri(
          scheme: 'mailto',
          path: value,
        );

        String url = params.toString();

        var name = value;

        if (listOfNames != null) {
          if (listOfNames.containsKey(value)) {
            name = (listOfNames[value] != null || listOfNames[value] != '')
                ? listOfNames[value]
                : value;
          }
        }

        var link = TextSpan(
            text: name,
            style: linkStyle == null ? Helper.linkDefaultTextStyle : linkStyle,
            recognizer: new TapGestureRecognizer()..onTap = () => launch(url));

        /// added
        textSpanWidget.add(link);
      } else if (value.toString().contains('https://meet.jit.si')) {
        String start = 'https://meet.jit.si/';
        int startIndex = value.indexOf(start);
        String result = value.substring(startIndex + start.length).trim();
        print(result);
        var link = TextSpan(
            text: value.toString(),
            style: linkStyle == null ? Helper.linkDefaultTextStyle : linkStyle,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                _joinMeeting(result);
              });

        /// added
        textSpanWidget.add(link);
      } else {
        /// else we let url_laucher know that this is url and not an email

        var l = value.toString().contains('https://')
            ? value
            : value.toString().contains('http://')
                ? value
                : 'http://' + value;
        var name = l;

        if (listOfNames != null) {
          if (listOfNames.containsKey(value)) {
            name = (listOfNames[value] != null || listOfNames[value] != '')
                ? listOfNames[value]
                : value;
          }
        }

        var link = TextSpan(
            text: name,
            style: linkStyle == null ? Helper.linkDefaultTextStyle : linkStyle,
            recognizer: new TapGestureRecognizer()..onTap = () => launch(l));

        /// added
        textSpanWidget.add(link);
      }

      if (wid[1] != '') {
        if (value == links.last) {
          var text = TextSpan(
            text: wid[1],
            style: style == null ? Helper.defaultTextStyle : style,
          );

          /// added
          textSpanWidget.add(text);
        } else {
          t = wid[1];
        }
      }
    });
  }

  /// We run a check to know if urls and Emails are found
  /// by checking if links.isNotEmpty
  /// if true
  /// we call BuildBody
  /// else we call BuildNormalBody
  if (links.isNotEmpty) {
    _buildBody();
  } else {
    _buildNormalText();
  }
  return TextSpan(children: textSpanWidget);
}

// /// LinkWellModify class created
// class LinkWellModify {
//   /// The RegEx pattern is created
//   final RegExp exp = Helper.regex;

//   /// This is holds all links when detected
//   final List links = <String>[];

//   /// This hold all Names of links provided by the User
//   /// this is set to null by default
//   final Map<String, String> listOfNames;

//   /// This hold TextSpan Widgets List
//   /// which is then placed as child in the RichText Widget
//   final List textSpanWidget = <TextSpan>[];

//   /// This hold the text the user provides
//   final String text;

//   /// This hold user defined styling
//   /// It's an instanciation of Flutter Widget TextStyle
//   final TextStyle style;

//   /// This hold user defined styling
//   /// for the links
//   /// It's also an instanciation of Flutter Widget TextStyle
//   final TextStyle linkStyle;

//   /// This hold user defined textAlignment
//   /// It's also an instanciation of Flutter Widget TextAlign
//   /// It has a default value of TextAlign.start,
//   final TextAlign textAlign;

//   /// This hold user defined MaxLines
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create max lines
//   /// it can take a default value of null
//   final int maxLines;

//   /// This hold user defined locale
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to define textOverflow
//   /// by default this is set to TextOverflow.clip
//   final Locale locale;

//   /// This hold user defined overflow
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create locale
//   /// by default can also be null
//   final TextOverflow overflow;

//   /// This hold user defined StrutStyle
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create strutstyle
//   /// by default can also be null
//   final StrutStyle strutStyle;

//   /// This hold user defined softWrap
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create softwrap
//   /// by default this is set to null
//   final bool softWrap;

//   /// This hold user defined textScaleFactor
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create textScaleFactor
//   /// by default can also be null
//   final double textScaleFactor;

//   /// This hold user defined textScaleFactor
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create textScaleFactor
//   /// by default can also be null
//   final TextWidthBasis textWidthBasis;

//   /// This hold user defined textScaleFactor
//   /// because LinkWellModify makes user of Flutter RichText Widget
//   /// it also gives user the option to create textScaleFactor
//   /// by default can also be null
//   final TextDirection textDirection;

//   /// This hold user defined Widget key
//   /// by default can also be null
//   final Key key;

//   /// LinkWellModify class is constructed here
//   LinkWellModify(
//     this.text, {
//     this.key,
//     this.style,
//     this.linkStyle,
//     this.textAlign = TextAlign.start,
//     this.textDirection,
//     this.softWrap = true,
//     this.overflow = TextOverflow.clip,
//     this.textScaleFactor = 1.0,
//     this.maxLines,
//     this.locale,
//     this.strutStyle,
//     this.listOfNames,
//     this.textWidthBasis = TextWidthBasis.parent,
//   })  : assert(text != null),
//         assert(textAlign != null),
//         assert(softWrap != null),
//         assert(overflow != null),
//         assert(textScaleFactor != null),
//         assert(maxLines == null || maxLines > 0),
//         assert(textWidthBasis != null) {
//     /// At construction _initialize function is called
//     _initialize();
//     check();
//   }

//   /// _initialize function
//   _initialize() {
//     /// An Iterable with variable name matches
//     /// Is assigned to our regular expression with
//     /// allMatched method call
//     Iterable<RegExpMatch> matches = exp.allMatches(this.text);

//     /// We now run a forEach Loop to add our matche to
//     /// the links List
//     matches.forEach((match) {
//       this.links.add(text.substring(match.start, match.end));
//     });

//     /// We run a check to know if urls and Emails are found
//     /// by checking if links.isNotEmpty
//     /// if true
//     /// we call BuildBody
//     /// else we call BuildNormalBody
//     if (links.isNotEmpty) {
//       _buildBody();
//     } else {
//       _buildNormalText();
//     }
//   }

//   /// _buildNormalText()
//   /// this is called when no links is detected
//   /// It simple build add TextSpan widget to our
//   /// textSpanWidget List
//   _buildNormalText() {
//     /// Adds TextSpan to textSpanWidget
//     /// checks if style is null and set deafult style
//     /// otherwise set style to user defined
//     textSpanWidget.add(TextSpan(
//         text: this.text,
//         style: style == null ? Helper.defaultTextStyle : style));
//   }

//   /// _buildBody()
//   /// this is called when links are detected
//   /// It simple build add TextSpan widget to our
//   /// textSpanWidget List
//   _buildBody() async {
//     /// var t is assigned to class text

//     var t = this.text;

//     /// a foreach is run on all the links found
//     this.links.forEach((value) async {
//       /// var wid which represents widget

//       var wid = t.split(value.trim());

//       /// if not value is found after splitting
//       /// we simple place text inside TextSpan
//       /// and add to textSpanWidget
//       if (wid[0] != '') {
//         var text = TextSpan(
//           text: wid[0],
//           style: style == null ? Helper.defaultTextStyle : style,
//         );

//         /// added
//         textSpanWidget.add(text);
//       }

//       /// when a link is found
//       /// we check if its an email,
//       /// so we can instruct url_launcher
//       /// that this is an email
//       if (value.toString().contains('@') && !value.toString().contains('/')) {
//         final Uri params = Uri(
//           scheme: 'mailto',
//           path: value,
//         );

//         String url = params.toString();

//         var name = value;

//         if (this.listOfNames != null) {
//           if (this.listOfNames.containsKey(value)) {
//             name = (this.listOfNames[value] != null ||
//                     this.listOfNames[value] != '')
//                 ? this.listOfNames[value]
//                 : value;
//           }
//         }

//         var link = TextSpan(
//             text: name,
//             style: linkStyle == null ? Helper.linkDefaultTextStyle : linkStyle,
//             recognizer: new TapGestureRecognizer()..onTap = () => launch(url));

//         /// added
//         textSpanWidget.add(link);
//       } else {
//         /// else we let url_laucher know that this is url and not an email

//         var l = value.toString().contains('https://')
//             ? value
//             : value.toString().contains('http://')
//                 ? value
//                 : 'http://' + value;
//         var name = l;

//         if (this.listOfNames != null) {
//           if (this.listOfNames.containsKey(value)) {
//             name = (this.listOfNames[value] != null ||
//                     this.listOfNames[value] != '')
//                 ? this.listOfNames[value]
//                 : value;
//           }
//         }

//         var link = TextSpan(
//             text: name,
//             style: linkStyle == null ? Helper.linkDefaultTextStyle : linkStyle,
//             recognizer: new TapGestureRecognizer()..onTap = () => launch(l));

//         /// added
//         textSpanWidget.add(link);
//       }

//       if (wid[1] != '') {
//         if (value == links.last) {
//           var text = TextSpan(
//             text: wid[1],
//             style: style == null ? Helper.defaultTextStyle : style,
//           );

//           /// added
//           textSpanWidget.add(text);
//         } else {
//           t = wid[1];
//         }
//       }
//     });
//   }

//   TextSpan check() {
//     return TextSpan(
//       children: textSpanWidget,
//     );
//     // TextSpan build(BuildContext context) {
//     //   return TextSpan(
//     //     children: textSpanWidget,
//     //   );
//     // SelectableText.rich(
//     //     TextSpan(
//     //       children: textSpanWidget,
//     //     ),
//     //     textAlign: TextAlign.start,
//     //     toolbarOptions: ToolbarOptions(selectAll: true, copy: true),
//     //     style: GoogleFonts.openSans(
//     //       fontSize: 16,
//     //       color: Colors.black,
//     //     ));
//   }
// }
