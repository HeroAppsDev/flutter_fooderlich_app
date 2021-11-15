import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/models/models.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  late final AppStateManager appStateManager;
  late final GroceryManager groceryManager;
  late final ProfileManager profileManager;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw Navigator(
      key: navigatorKey,
      pages: [],
    );
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  //GlobalKey - a unique key across the entire app.

  @override
  Future<void> setNewRoutePath(configuration) async {
    return;
  }
  //Sets setNewRoutePath to null since you aren’t supporting Flutter web apps yet.

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {}
}
