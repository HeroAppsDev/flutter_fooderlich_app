import 'package:flutter/material.dart';
import 'app_link.dart';

//AppRouteParser extends RouteInformationParser. Notice it takes a generic type.
//In this case, your type is AppLink, which holds all the route and navigation information.
class AppRouteParser extends RouteInformationParser<AppLink> {
  //The first method you need to override is parseRouteInformation().
  //The route information contains the URL string.
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    //Take the route information and build an instance of AppLink from it.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  //This function passes in an AppLink object. You ask AppLink to give you back the URL string.
  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    final location = appLink.toLocation();
    //You wrap it in RouteInformation to pass it along.
    return RouteInformation(location: location);
  }
}
