import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/models/models.dart';
import 'package:flutter_fooderlich_app/screens/explore_screen.dart';
import 'package:flutter_fooderlich_app/screens/grocery_screen.dart';
import 'package:flutter_fooderlich_app/screens/recipes_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static List<Widget> pages = [
    ExploreScreen(),
    RecipesScreen(),
    const GroceryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(builder: (context, tabManager, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'FooderLich',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: IndexedStack( //preserves state of the scrollbar and screens
          index: tabManager.selectedTab,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabManager.selectedTab,
          onTap: (index) {
            tabManager.goToTab(index);
          },
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'To Buy',
            ),
          ],
        ),
      );
    });
  }
}
