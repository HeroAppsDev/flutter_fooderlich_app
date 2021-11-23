import 'package:flutter/material.dart';

class AppLink {
  //URL paths
  static const String kHomePath = '/home';
  static const String kOnboardingPath = '/onboarding';
  static const String kLoginPath = '/login';
  static const String kProfilePath = '/profile';
  static const String kItemPath = '/item';

//query parameter
  static const String kTabParam = 'tab';
  static const String kIdParam = 'id';

  String? location;

  int? currentTab;

  String? itemId;

  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

  //converts a URL string to an AppLink
  static AppLink fromLocation(String? location) {
    // URLs often include special characters in their paths, so you need to percent-encode the URL path.
    //For example, you’d encode hello!world to hello%21world.
    location = Uri.decodeFull(location ?? '');

    //Parse the URI for query parameter keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    //Extract the currentTab from the URL path if it exists.
    final currentTab = int.tryParse(params[AppLink.kTabParam] ?? '');

    //Extract the itemId from the URL path if it exists.
    final itemId = params[AppLink.kIdParam];

    //Create the AppLink by passing in the query parameters you extract from the URL string.
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );

    //Return the instance of AppLink.

    debugPrint('## ${link.toString()}');
    return link;
  }

  String toLocation() {
    //Create an internal function that formats the query parameter key-value pair into a string format.
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '$key=$value&';

    debugPrint('## $location');
    //Go through each defined path.
    switch (location) {
      case kLoginPath: //If the path is kLoginPath, return the right string path: /login.
        return kLoginPath;
      case kOnboardingPath: //If the path is kOnboardingPath, return the right string path: /onboarding.
        return kOnboardingPath;
      case kProfilePath: //If the path is kProfilePath, return the right string path: /profile.
        return kProfilePath;
      case kItemPath: //If the path is kItemPath, return the right string path: /item
        var loc = '$kItemPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        ); //and if there are any parameters, append ?id=${id}.
        return Uri.encodeFull(loc);
      default: //If the path is invalid,
        var loc = '$kHomePath?'; // default to the path /home.
        loc += addKeyValPair(
          key: kTabParam,
          value: currentTab.toString(),
        ); //If the user selected a tab, append ?tab=${tabIndex}
        return Uri.encodeFull(loc);
    }
  }
}
