import 'package:app_test/views/MainMenu.dart';
import 'package:app_test/views/searchUser.dart';
import 'package:app_test/views/sign_in.dart';
// import 'package:app_test/views/sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classmeme',
      debugShowCheckedModeBanner: false, //hide debug icon
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          SignIn(),
          // MainMenu(),
//           SearchUsers(),
    );
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
  }
}
