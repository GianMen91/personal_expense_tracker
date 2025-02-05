import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

