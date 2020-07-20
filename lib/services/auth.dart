import 'package:app_test/main.dart';
import 'package:app_test/modals/user.dart';
import 'package:app_test/modals/user.dart';
import 'package:app_test/views/MainScreen.dart';
import 'package:app_test/views/sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userID: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      // FirebaseA
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    bool emailExist = false;
    FirebaseUser firebaseUser;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;
      print(firebaseUser.email);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          emailExist = true;
        }
        emailExist = true;
      }
      print("error code is " + e.code.toString());
    }
    return emailExist ? null : _userFromFirebaseUser(firebaseUser);
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser userDetails = result.user;

    if (result == null) {
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

// // //check if the user has already login
//     FutureBuilder<FirebaseUser> isLoginOrNot() {
//             future: FirebaseAuth.instance.currentUser();
//             builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
//                        if (snapshot.hasData){
//                         print('logged in');
//                            FirebaseUser user = snapshot.data; // this is your user instance
//                            /// is because there is user already logged
//                            return MainMenu();
//                         }
//                         print('Not logged in');

//                          /// other way there is no user logged.
//                          return SignIn();
//              };
//     }
