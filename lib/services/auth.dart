import 'package:app_test/models/user.dart' as u;
import "package:firebase_auth/firebase_auth.dart" as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_test/services/userDatabase.dart';
import 'dart:async';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer timer;

  u.User _userFromFirebaseUser(
    auth.User user,
  ) {
    // return user != null ? auth.User(userID: user.uid) : null;
    return (user != null)
        ? u.User(
            userID: user.uid,
            isVerified: user.emailVerified,
            email: user.email,
            photoURL: user.photoURL,
          )
        : null;
  }

  Future<bool> isUserLogged() async {
    auth.User firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      String tokenResult = await firebaseUser.getIdToken(true);
      return tokenResult != null;
    } else {
      return false;
    }
  }

  // Future<User> getLoggedFirebaseUser() {
  //   return _auth.currentUser;
  // }

  // auth change user stream
  Stream<u.User> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // Future reloadTheUser() async {
  //   FirebaseUser currUser = await _auth.currentUser.reload().then((_) => _auth.currentUser());

  //     try {
  //       return await _auth.currentUser().then((u) => u.reload().then((_) => _auth.currentUser()));
  //     } catch (error) {
  //       throw error;
  //     }

  // }


  void sendVerifyEmail() {
    User user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  void dispose() {
    timer.cancel();
  }

  Future<void> checkEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
    }
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    auth.User firebaseUser;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = userCredential.user;
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
    auth.User firebaseUser;

    try {
      print('user created finished');
      print(email);
      print(password);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(email);
      print(password);
      firebaseUser = userCredential.user;
      await UserDatabaseService(userID: firebaseUser.uid)
          .updateUserData(firebaseUser.uid, email, email, university);
      print('update finished');
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (error) {
      print('error: is 1111111' + error.code);
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
      throw e;
    }
  }

  // Future<auth.User> signInWithGoogle(BuildContext context) async {
  //   final GoogleSignIn _googleSignIn = new GoogleSignIn();

  //   final GoogleSignInAccount googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);

  //   UserCredential userCredential =
  //       await _auth.signInWithCredential(credential);
  //   auth.User googleUser = userCredential.user;

  //   if (googleUser == null) {
  //   } else {
  //     await UserDatabaseService(userID: googleUser.uid).updateUserData(
  //         googleUser.uid, googleUser.email, googleUser.email, 'University');
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => MainScreen()));
  //   }
  // }

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
