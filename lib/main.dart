// import 'package:app_test/views/sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/providers/contactProvider.dart';
import 'package:app_test/providers/courseProvider.dart';
import 'package:app_test/providers/tagProvider.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/services/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        home: SplashScreen(),
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
