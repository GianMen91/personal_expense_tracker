import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';

void main() {
  group('ExpenseCategories Tests', () {
    test('should return the correct category by title', () {
      // Arrange
      const title = 'Groceries';

      // Act
      final category = ExpenseCategories.getCategoryByTitle(title);

      // Assert
      expect(category.title, equals(title));
      expect(category.id, equals('groceries'));
      expect(category.icon, equals(Icons.shopping_cart));
      expect(category.color, equals(const Color(0xFF4CAF50)));
    });

    test('should return the correct category by ID', () {
      // Arrange
      const id = 'fuel';

      // Act
      final category = ExpenseCategories.getCategoryById(id);

      // Assert
      expect(category.id, equals(id));
      expect(category.title, equals('Fuel'));
      expect(category.icon, equals(Icons.local_gas_station));
      expect(category.color, equals(const Color(0xFFFF7043)));
    });

    test('should return the first category when title is not found', () {
      // Arrange
      const title = 'NonExistentCategory';

      // Act
      final category = ExpenseCategories.getCategoryByTitle(title);

      // Assert
      expect(category, equals(ExpenseCategories.categories.first));
    });

    test('should return the first category when ID is not found', () {
      // Arrange
      const id = 'invalid_id';

      // Act
      final category = ExpenseCategories.getCategoryById(id);

      // Assert
      expect(category, equals(ExpenseCategories.categories.first));
    });

    test('should have the correct number of categories', () {
      // Assert
      expect(ExpenseCategories.categories.length, equals(17));
    });
  });
}
