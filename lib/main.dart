import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/fooferlich_theme.dart';
import 'package:flutter_fooderlich_app/home.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FooderLichApp());
}

class FooderLichApp extends StatelessWidget {
  const FooderLichApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.light();
    return MaterialApp(
      title: 'FooderLich',
      theme: theme,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TabManager(),
          ),
          ChangeNotifierProvider(
            create: (contex) => GroceryManager(),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}
