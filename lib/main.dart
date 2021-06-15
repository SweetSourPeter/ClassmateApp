// import 'package:app_test/views/sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_test/course_route_path.dart';
import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart' as user_replaced;
import 'package:app_test/pages/contact_pages/searchUser.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:app_test/providers/contactProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/routes/AuthGuard.dart';
import 'package:app_test/routes/router.gr.dart';
import 'package:app_test/unknown_pages/unknown_page.dart';
import 'package:app_test/web_initial_pages/web_whole.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:app_test/services/auth.dart';
import 'package:app_test/routes/router.dart';
import 'package:app_test/routes/router.gr.dart';

import 'models/courseInfo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     // Initialize FlutterFire
  //     future: Firebase.initializeApp(),
  //     builder: (context, snapshot) {
  //       // Check for errors
  //       if (snapshot.hasError) {
  //         return Directionality(
  //           textDirection: TextDirection.ltr,
  //                     child: Center(
  //               child: Text('Opps, sothing went wrong, please check later')),
  //         );
  //       }

  //       // Once complete, show your application
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return MultiProvider(
  //           providers: [
  //             StreamProvider(
  //                 create: (context) => AuthMethods().user), //Login user
  //             ChangeNotifierProvider(
  //                 create: (context) => CourseProvider()), //course Provider
  //             ChangeNotifierProvider(
  //                 create: (context) => ContactProvider()), //contacts Provider
  //             ChangeNotifierProvider(
  //                 create: (context) => UserTagsProvider()), //tag Provider
  //           ],
  //           child: MaterialApp(
  //             debugShowCheckedModeBanner: false,
  //             home: SplashScreen(),
  //           ),
  //         );
  // }

  // Otherwise, show something whilst waiting for initialization to complete
  //       return CircularProgressIndicator();
  //     },
  //   );
  // }
  // final _exNavigatorKey = GlobalKey<ExtendedNavigatorState>();
  @override
  Widget build(BuildContext context) {
    setErrorBuilder();
    return MultiProvider(
      providers: [
        StreamProvider(create: (context) => AuthMethods().user), //Login user
        ChangeNotifierProvider(
            create: (context) => CourseProvider()), //course Provider
        ChangeNotifierProvider(
            create: (context) => ContactProvider()), //contacts Provider
        ChangeNotifierProvider(
            create: (context) => UserTagsProvider()), //tag Provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          highlightColor: themeOrange, // color for scroll bar
        ),
        onGenerateRoute: (settings) {
          final settingsUri = Uri.parse(settings.name);
          print("setting uri is");
          print(settingsUri);
          // final courseID = settingsUri.queryParameters['id'];
          final user = AuthMethods().user;
          print("user");
          print(user.isEmpty);

          //user didn't log in, go to home page
          if (user.isEmpty == null) {
            return MaterialPageRoute(builder: (context) {
              return NavPage();
            });
          } else {
            // the user are logged in
            // Handle '/'
            if (settingsUri.pathSegments.length == 0) {
              return MaterialPageRoute(builder: (context) {
                return NavPage();
                // return Wrapper(false, false, "0");
              });
            }

            // Handle '/course/:id'
            if (settingsUri.pathSegments.length == 2) {
              if (settingsUri.pathSegments.first != 'course') {
                return MaterialPageRoute(builder: (context) {
                  return UnknownPage();
                });
              }

              final classid = settingsUri.pathSegments.elementAt(1);
              //user didn't input courseid, thus go back to homepage
              if (classid == null) {
                return MaterialPageRoute(builder: (context) {
                  return UnknownPage();
                });
              }

              //call multiprovider with correct arguments
              return MaterialPageRoute(builder: (context) {
                setErrorBuilder();
                return Wrapper(false, true, classid);
              });
            }
          }
          //Handle other unknown Routes
          return MaterialPageRoute(builder: (context) {
            return UnknownPage();
          });
        },

        // builder: ExtendedNavigator(
        //   key: _exNavigatorKey,
        //   router: ModularRouter(),
        //   initialRoute: Routes.navPage,
        //   // builder: (_, extendedNav) => Theme(
        //   //   data: themeOrange(),
        //   //   child: extendedNav,
        //   // ),
        // ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Classmeme',
  //     debugShowCheckedModeBanner: false, //hide debug icon
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //       visualDensity: VisualDensity.adaptivePlatformDensity,
  //     ),
  //     home:
  //         SignIn(),
  // MainMenu(),
//           SearchUsers(),
  // );

  // FutureBuilder<FirebaseUser>(
  //             future: FirebaseAuth.instance.currentUser(),
  //             builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
  //                       if (snapshot.hasData){
  //                           FirebaseUser user = snapshot.data; // this is your user instance
  //                           /// is because there is user already logged
  //                           return MaterialApp(
  //                             debugShowCheckedModeBanner: false, //hide debug icon
  //                             home: MainMenu(),
  //                           );
  //                         }
  //                         /// other way there is no user logged.
  //                         return MaterialApp(
  //                           debugShowCheckedModeBanner: false, //hide debug icon
  //                           home: SignIn(),
  //                         );
  //             }
  //           );
  // }
}

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: themeOrange,
    ));
  };
}
