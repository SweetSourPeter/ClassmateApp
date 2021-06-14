import 'package:app_test/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app_test/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    // can navigate to the page?
    BuildContext context = navigator.context;
    return true;
  }
}
