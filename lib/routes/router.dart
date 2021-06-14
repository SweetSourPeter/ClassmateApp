import 'package:auto_route/auto_route_annotations.dart';
import 'package:app_test/web_initial_pages/web_whole.dart';
import 'package:app_test/services/wrapper.dart';
import 'package:app_test/pages/initialPage/start_page.dart';
import 'package:app_test/pages/group_chat_pages/groupChat.dart';
import 'package:app_test/MainMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../course_route_path.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: NavPage, initial: true),
    MaterialRoute(path: "/start", page: Wrapper),
    MaterialRoute(path: "/class/:id", page: MultiProvider),
  ],
  generateNavigationHelperExtension: true,
)
class $ModularRouter {}

// flutter pub run build_runner watch --delete-conflicting-outputs
