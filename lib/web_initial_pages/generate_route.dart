import 'package:flutter/material.dart';
import 'web_wrapper.dart';
import 'web_whole.dart';
import 'route_name.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.INITIAL_PAGE:
        return MaterialPageRoute(builder: (_) => NavPage());
      case RoutesName.SECOND_PAGE:
        return MaterialPageRoute(builder: (_) => NavPage());
      default:
        return MaterialPageRoute(builder: (_) => WebWrapper());
    }
  }
}
