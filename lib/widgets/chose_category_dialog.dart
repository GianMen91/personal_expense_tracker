import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import '../widgets/category_item.dart';

class ChoseCategoryDialog extends StatelessWidget {
  const ChoseCategoryDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a category'),
      content: SizedBox(
        height: 300.0,
        width: 300.0,
        child: ListView.builder(
          itemCount: ExpenseCategories.categories.length,
          itemBuilder: (context, index) {
            final category = ExpenseCategories.categories[index];
            return CategoryItem(category: category);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
