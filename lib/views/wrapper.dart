import 'package:app_test/models/user.dart';
import 'package:app_test/views/MainMenu.dart';
import 'package:app_test/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return SignIn();
    } else {
      return MainMenu();
    }
    
  }
}