import 'package:flutter/material.dart';

import 'expense_category.dart';

class ExpenseCategories {
  static const List<ExpenseCategory> categories = [
    ExpenseCategory(
      id: 'groceries',
      title: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFF4CAF50),
    ),
    ExpenseCategory(
      id: 'transport',
      title: 'Transport',
      icon: Icons.directions_bus,
      color: Color(0xFF1565C0),
    ),
    ExpenseCategory(
      id: 'eating_out',
      title: 'Lunches & Dinners',
      icon: Icons.restaurant,
      color: Color(0xFFD81B60),
    ),
    ExpenseCategory(
      id: 'entertainment',
      title: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF43A047),
    ),
    ExpenseCategory(
      id: 'bars',
      title: 'Bars',
      icon: Icons.coffee,
      color: Color(0xFF1E88E5),
    ),
    ExpenseCategory(
      id: 'gifts',
      title: 'Gifts',
      icon: Icons.card_giftcard,
      color: Color(0xFFAB47BC),
    ),
    ExpenseCategory(
      id: 'clothes',
      title: 'Clothes',
      icon: Icons.shopping_bag,
      color: Color(0xFFFFA726),
    ),
    ExpenseCategory(
      id: 'health',
      title: 'Health',
      icon: Icons.local_hospital,
      color: Color(0xFF1E88E5),
    ),
    ExpenseCategory(
      id: 'hotel',
      title: 'Accommodations & Hotels',
      icon: Icons.hotel,
      color: Color(0xFF6D4C41),
    ),
    ExpenseCategory(
      id: 'withdrawals',
      title: 'Withdrawals',
      icon: Icons.money,
      color: Color(0xFF00897B),
    ),
    ExpenseCategory(
      id: 'books',
      title: 'Books & Newspapers',
      icon: Icons.menu_book,
      color: Color(0xFF8E24AA),
    ),
    ExpenseCategory(
      id: 'fuel',
      title: 'Fuel',
      icon: Icons.local_gas_station,
      color: Color(0xFFFF7043),
    ),
    ExpenseCategory(
      id: 'electronics',
      title: 'Electronics & Gadgets',
      icon: Icons.devices, // Covers multiple gadgets
      color: Color(0xFF546E7A), // Blue Grey 600
    ),
    ExpenseCategory(
      id: 'home',
      title: 'Home',
      icon: Icons.home,
      color: Color(0xFF8E24AA),
    ),
    ExpenseCategory(
      id: 'insurance',
      title: 'Insurance',
      icon: Icons.shield,
      color: Color(0xFF00ACC1),
    ),
    ExpenseCategory(
      id: 'rent',
      title: 'Rent',
      icon: Icons.apartment,
      color: Color(0xFFFB8C00),
    ),
    ExpenseCategory(
      id: 'taxes',
      title: 'Taxes',
      icon: Icons.request_quote,
      color: Color(0xFF8D6E63),
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
