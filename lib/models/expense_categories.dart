import 'package:flutter/material.dart';

import 'expense_category.dart';

class ExpenseCategories {
  static const List<ExpenseCategory> categories = [
    ExpenseCategory(
      id: 'food',
      title: 'Food & Groceries',
      icon: Icons.fastfood,
      color: Color(0xFFE53935), // Red 600
    ),
    ExpenseCategory(
      id: 'transport',
      title: 'Transportation',
      icon: Icons.directions_bus,
      color: Color(0xFF1E88E5), // Blue 600
    ),
    ExpenseCategory(
      id: 'entertainment',
      title: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF8E24AA), // Purple 600
    ),
    ExpenseCategory(
      id: 'shopping',
      title: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFFA726), // Orange 400
    ),
    ExpenseCategory(
      id: 'healthcare',
      title: 'Healthcare',
      icon: Icons.local_hospital,
      color: Color(0xFFD81B60), // Pink 600
    ),
    ExpenseCategory(
      id: 'bills',
      title: 'Bills & Utilities',
      icon: Icons.receipt_long,
      color: Color(0xFF43A047), // Green 600
    ),
    ExpenseCategory(
      id: 'travel',
      title: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF00897B), // Teal 600
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
