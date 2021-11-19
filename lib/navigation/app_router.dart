import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
import 'package:flutter_fooderlich_app/screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState>
      navigatorKey; //GlobalKey - a unique key across the entire app.

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
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
              onCreate: (item) {
                groceryManager.addItem(item);
              },
              onUpdate: (item, index) {}),
        if (groceryManager.selectedIndex != -1)
          GroceryItemScreen.page(
            item: groceryManager.selectedGroceryItem,
            index: groceryManager.selectedIndex,
            onCreate: (_) {},
            onUpdate: (item, index) {
              groceryManager.updateItem(item, index);
            },
          ),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }

    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    return true;
  }

  //Sets setNewRoutePath to null since you aren’t supporting Flutter web apps yet.
  @override
  Future<void> setNewRoutePath(configuration) async {
    return;
  }
}
