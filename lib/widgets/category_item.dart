import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/expense_category.dart';
import '../screens/new_expense_screen.dart';
import 'category_avatar.dart';

class CategoryItem extends StatelessWidget {
  final ExpenseCategory category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: kBoxDecoration,
      child: ListTile(
        leading: CategoryAvatar(category: category, key: const Key('category_avatar'),),
        title: Text(category.title, key: const Key('category_title_text')),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewExpenseScreen(category: category),
            ),
          );
        },
      ),
    );
  }
}
