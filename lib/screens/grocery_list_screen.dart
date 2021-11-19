import 'package:flutter/material.dart';
import 'package:flutter_fooderlich_app/components/components.dart';
import 'package:flutter_fooderlich_app/models/grocery_manager.dart';
import 'package:flutter_fooderlich_app/screens/grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager groceryManager;
  const GroceryListScreen({Key? key, required this.groceryManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryItems = groceryManager.groceryItems;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
          itemBuilder: (context, index) {
            final item = groceryItems[index];
            return Dismissible(
              key: Key(item.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              onDismissed: (direction) {
                groceryManager.deleteItem(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} dissmissed'),
                  ),
                );
              },
              child: InkWell(
                child: GroceryTile(
                  key: Key(item.id),
                  item: item,
                  onComplete: (change) {
                    if (change != null) {
                      groceryManager.completeItem(index, change);
                    }
                  },
                ),
                onTap: () {
                  groceryManager.groceryItemTapped(index);
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
          itemCount: groceryItems.length),
    );
  }
}
