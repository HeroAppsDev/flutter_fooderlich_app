import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
import 'package:flutter_fooderlich_app/navigation/app_link.dart';
import 'package:flutter_fooderlich_app/screens/screens.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState>
      navigatorKey; //GlobalKey - a unique key across the entire app.

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

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
        if (!appStateManager.isInitialized) ...[
          SplashScreen.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginScreen.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingScreen.page(),
        ] else ...[
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
          if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
        ]
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
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    return true;
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  AppLink getCurrentPath() {
    if (!appStateManager.isLoggedIn) {
      //If the user hasn’t logged in, return the app link with the login path.
      return AppLink(location: AppLink.kLoginPath);
    } else if (!appStateManager.isOnboardingComplete) {
      //If the user hasn’t completed onboarding, return the app link with the onboarding path.
      return AppLink(location: AppLink.kOnboardingPath);
    } else if (profileManager.didSelectUser) {
      //If the user taps the profile, return the app link with the profile path.
      return AppLink(location: AppLink.kProfilePath);
    } else if (groceryManager.isCreatingNewItem) {
      //If the user taps the + button to create a new grocery item, return the app link with the item path.
      return AppLink(location: AppLink.kItemPath);
    } else if (groceryManager.selectedGroceryItem != null) {
      //If the user selected an existing item, return an app link with the item path and the item’s id.
      final id = groceryManager.selectedGroceryItem?.id;
      return AppLink(location: AppLink.kItemPath, itemId: id);
    } else {
      //If none of the conditions are met, default by returning to the home path with the selected tab.
      return AppLink(
          location: AppLink.kHomePath,
          currentTab: appStateManager.getSelectedTab);
    }
  }

  //You call setNewRoutePath() when a new route is pushed. It passes along an AppLink.
  //This is your navigation configuration.
  @override
  Future<void> setNewRoutePath(AppLink configuration) async {
    //Use a switch to check every location.
    switch (configuration.location) {
      case AppLink
          .kProfilePath: //If the new location is /profile, show the Profile screen.
        profileManager.tapOnProfile(true);
        break;
      case AppLink.kItemPath: //Check if the new location starts with /item.
        final itemId = configuration.itemId;
        if (itemId != null) {
          //If itemId is not null,
          groceryManager.setSelectedGroceryItem(
              itemId); //set the selected grocery item and show the Grocery Item screen.
        } else {
          groceryManager
              .createNewItem(); //If itemId is null, show an empty Grocery Item screen.
        }
        profileManager.tapOnProfile(false); //Hide the Profile screen.
        break;
      case AppLink.kHomePath: //If the new location is /home.
        appStateManager.goToTab(
            configuration.currentTab ?? 0); //Set the currently selected tab.

        //Make sure the Profile screen and Grocery Item screen are hidden.
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemTapped(-1);
        break;
      default: //If the location does not exist, do nothing.
        break;
    }
  }
}
