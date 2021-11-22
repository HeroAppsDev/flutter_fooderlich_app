import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/fooferlich_theme.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
import 'package:flutter_fooderlich_app/navigation/app_route_parser.dart';
import 'package:flutter_fooderlich_app/navigation/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FooderLichApp());
}

class FooderLichApp extends StatefulWidget {
  const FooderLichApp({Key? key}) : super(key: key);

  @override
  State<FooderLichApp> createState() => _FooderLichAppState();
}

class _FooderLichAppState extends State<FooderLichApp> {
  final _groceryManager = GroceryManager();
  final _profileManager = ProfileManager();
  final _appStateManager = AppStateManager();
  late AppRouter _appRouter;

  final routeParser = AppRouteParser();

  @override
  void initState() {
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      groceryManager: _groceryManager,
      profileManager: _profileManager,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (contex) => _groceryManager,
        ),
        ChangeNotifierProvider(create: (context) => _appStateManager),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = FooderlichTheme.dark();
          } else {
            theme = FooderlichTheme.light();
          }
          return MaterialApp(
            theme: theme,
            title: 'Fooderlich',
            home: Router(
              routerDelegate: _appRouter,
              //listens to the platform pop route notifications. When the user taps the Android system Back button, it triggers the router delegate’s onPopPage callback.
              backButtonDispatcher: RootBackButtonDispatcher(),
              routeInformationParser: routeParser,
            ),
          );
        },
      ),
    );
  }
}
