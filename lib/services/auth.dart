import 'package:app_test/main.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/MainScreen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_test/services/userDatabase.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userID: user.uid) : null;
  }

  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();
    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() {
    return _auth.currentUser();
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser firebaseUser;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (error) {
      throw error;
      // switch (error.code) {
      //   case "ERROR_INVALID_EMAIL":
      //     errorMessage = "Your email address appears to be malformed.";
      //     break;
      //   case "ERROR_WRONG_PASSWORD":
      //     errorMessage = "Your password is wrong.";
      //     break;
      //   case "ERROR_USER_NOT_FOUND":
      //     errorMessage = "User with this email doesn't exist.";
      //     break;
      //   case "ERROR_USER_DISABLED":
      //     errorMessage = "User with this email has been disabled.";
      //     break;
      //   case "ERROR_TOO_MANY_REQUESTS":
      //     errorMessage = "Too many requests. Try again later.";
      //     break;
      //   case "ERROR_OPERATION_NOT_ALLOWED":
      //     errorMessage = "Signing in with Email and Password is not enabled.";
      //     break;
      //   default:
      //     errorMessage = "An undefined Error happened.";
      // }
    }
    // if (errorMessage != null) {
    //   print('returning the error message');
    //   throw (errorMessage);
    //   // return Future.error(errorMessage);
    // }

    // return _userFromFirebaseUser(firebaseUser);
  }

  // sign up with email and password
  Future signUpWithEmailAndPassword(
      String email, String password, String university) async {
    // bool emailExist = false;
    // FirebaseUser firebaseUser;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      await UserDatabaseService(userID: firebaseUser.uid)
          .updateUserData(email, email, university);
      return _userFromFirebaseUser(firebaseUser);
    } catch (error) {
      throw error;

      // if (e is PlatformException) {
      //   if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
      //     emailExist = true;
      //   }
      //   emailExist = true;
      // }
      // print("error code is " + e.code.toString());
    }
    // return emailExist ? null : _userFromFirebaseUser(firebaseUser);
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
    FirebaseUser googleUser = result.user;

    if (googleUser == null) {
    } else {
      await UserDatabaseService(userID: googleUser.uid)
          .updateUserData(googleUser.email, googleUser.email, 'University');
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
