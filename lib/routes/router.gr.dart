// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// // **************************************************************************
// // AutoRouteGenerator
// // **************************************************************************
//
// // ignore_for_file: public_member_api_docs
//
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:nested/nested.dart';
// import 'package:provider/provider.dart';
//
// import '../services/wrapper.dart';
// import '../web_initial_pages/web_whole.dart';
// import 'AuthGuard.dart';
//
// class Routes {
//   static const String navPage = '/';
//   static const String wrapper = '/start';
//   static const String _multiProvider = '/class/:id';
//   static String multiProvider({@required dynamic id}) => '/class/$id';
//   static const all = <String>{
//     navPage,
//     wrapper,
//     _multiProvider,
//   };
// }
//
// class ModularRouter extends RouterBase {
//   @override
//   List<RouteDef> get routes => _routes;
//   final _routes = <RouteDef>[
//     RouteDef(Routes.navPage, page: NavPage),
//     RouteDef(Routes.wrapper, page: Wrapper, guards: [AuthGuard]),
//     RouteDef(Routes._multiProvider, page: MultiProvider, guards: [AuthGuard]),
//   ];
//   @override
//   Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
//   final _pagesMap = <Type, AutoRouteFactory>{
//     NavPage: (data) {
//       return MaterialPageRoute<dynamic>(
//         builder: (context) => NavPage(),
//         settings: data,
//       );
//     },
//     Wrapper: (data) {
//       final args = data.getArgs<WrapperArguments>(nullOk: false);
//       return MaterialPageRoute<dynamic>(
//         builder: (context) => Wrapper(args.reset),
//         settings: data,
//       );
//     },
//     MultiProvider: (data) {
//       final args = data.getArgs<MultiProviderArguments>(nullOk: false);
//       return MaterialPageRoute<dynamic>(
//         builder: (context) => MultiProvider(
//           key: args.key,
//           providers: args.providers,
//           child: args.child,
//           builder: args.builder,
//         ),
//         settings: data,
//       );
//     },
//   };
// }
//
// /// ************************************************************************
// /// Navigation helper methods extension
// /// *************************************************************************
//
// extension ModularRouterExtendedNavigatorStateX on ExtendedNavigatorState {
//   Future<dynamic> pushNavPage() => push<dynamic>(Routes.navPage);
//
//   Future<dynamic> pushWrapper(
//           {@required bool reset, OnNavigationRejected onReject}) =>
//       push<dynamic>(
//         Routes.wrapper,
//         arguments: WrapperArguments(reset: reset),
//         onReject: onReject,
//       );
// }
//
// /// ************************************************************************
// /// Arguments holder classes
// /// *************************************************************************
//
// /// Wrapper arguments holder class
// class WrapperArguments {
//   final bool reset;
//   WrapperArguments({@required this.reset});
// }
//
// /// MultiProvider arguments holder class
// class MultiProviderArguments {
//   final Key key;
//   final List<SingleChildWidget> providers;
//   final Widget child;
//   final Widget Function(BuildContext, Widget) builder;
//   MultiProviderArguments(
//       {this.key, @required this.providers, this.child, this.builder});
// }
