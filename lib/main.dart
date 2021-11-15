import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/fooferlich_theme.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
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
    final _appStateManager = AppStateManager();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (contex) => GroceryManager(),
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
            home: Router(routerDelegate: _appRouter),
          );
        },
      ),
    );
  }
}
