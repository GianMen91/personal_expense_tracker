import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class CategoryAvatar extends StatelessWidget {
  final ExpenseCategory category;

  const CategoryAvatar({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        category.icon,
        color: category.color,
        size: 24,
      ),
    );
  }
}