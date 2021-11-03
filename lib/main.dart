import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/fooferlich_theme.dart';
import 'package:flutter_fooderlich_app/home.dart';

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
      home: const Home(),
    );
  }
}
