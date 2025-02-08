import 'package:flutter/material.dart';

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
        decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

      child: ListTile(
        leading: CategoryAvatar(category: category),
        title: Text(category.title),
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

