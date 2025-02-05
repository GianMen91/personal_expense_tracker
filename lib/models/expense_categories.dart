import 'package:flutter/material.dart';

import 'expense_category.dart';

class ExpenseCategories {
  static const List<ExpenseCategory> categories = [
    ExpenseCategory(
      id: 'food',
      title: 'Food & Groceries',
      icon: Icons.fastfood,
      color: Color(0xFFFFCDD2), // Colors.red.shade200
    ),
    ExpenseCategory(
      id: 'transport',
      title: 'Transportation',
      icon: Icons.directions_bus,
      color: Color(0xFFBBDEFB), // Colors.blue.shade200
    ),
    ExpenseCategory(
      id: 'entertainment',
      title: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFB2DFDB), // Colors.teal.shade200
    ),
    ExpenseCategory(
      id: 'shopping',
      title: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFBBDEFB), // Colors.blue.shade200
    ),
    ExpenseCategory(
      id: 'healthcare',
      title: 'Healthcare',
      icon: Icons.local_hospital,
      color: Color(0xFFFFCDD2), // Colors.red.shade200
    ),
    ExpenseCategory(
      id: 'bills',
      title: 'Bills & Utilities',
      icon: Icons.receipt_long,
      color: Color(0xFFC8E6C9), // Colors.green.shade200
    ),
    ExpenseCategory(
      id: 'travel',
      title: 'Travel',
      icon: Icons.flight,
      color: Color(0xFFB2DFDB), // Colors.teal.shade200
    ),
  ];

  static ExpenseCategory getCategoryByTitle(String title) {
    return categories.firstWhere(
      (category) => category.title == title,
      orElse: () => categories[0], // Default to first category if not found
    );
  }

  static ExpenseCategory getCategoryById(String id) {
    return categories.firstWhere(
      (category) => category.id == id,
      orElse: () => categories[0], // Default to first category if not found
    );
  }
}
