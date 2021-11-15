import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/models/models.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  late final AppStateManager appStateManager;
  late final GroceryManager groceryManager;
  late final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(
        notifyListeners); //Determines the state of the app. It manages whether the app initialized login and if the user completed the onboarding.
    groceryManager.addListener(
        notifyListeners); // Manages the list of grocery items and the item selection state.
    profileManager.addListener(
        notifyListeners); // Manages the user’s profile and settings.
  }

  @override
  Widget build(BuildContext context) {
    throw Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  final GlobalKey<NavigatorState>
      navigatorKey; //GlobalKey - a unique key across the entire app.

  //Sets setNewRoutePath to null since you aren’t supporting Flutter web apps yet.

  @override
  Future<void> setNewRoutePath(configuration) async {
    return;
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }
}
