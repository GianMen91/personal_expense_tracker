import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense_validation_service.dart';

void main() {
  late ExpenseValidationService validationService;

  setUp(() {
    validationService = ExpenseValidationService();
  });

  group('ExpenseValidationService Tests', () {
    test('should return true for a valid expense (non-empty description, positive cost)', () {
      // Arrange
      const description = 'Lunch';
      const cost = 10.0;

      // Act
      final isValid = validationService.isValidExpense(description, cost);

      // Assert
      expect(isValid, isTrue);
    });

    test('should return false for an empty description', () {
      // Arrange
      const description = '';
      const cost = 10.0;

      // Act
      final isValid = validationService.isValidExpense(description, cost);

      // Assert
      expect(isValid, isFalse);
    });

    test('should return false for a zero cost', () {
      // Arrange
      const description = 'Lunch';
      const cost = 0.0;

      // Act
      final isValid = validationService.isValidExpense(description, cost);

      // Assert
      expect(isValid, isFalse);
    });

    test('should return false for a negative cost', () {
      // Arrange
      const description = 'Lunch';
      const cost = -5.0;

      // Act
      final isValid = validationService.isValidExpense(description, cost);

      // Assert
      expect(isValid, isFalse);
    });

    test('should return false for both empty description and zero cost', () {
      // Arrange
      const description = '';
      const cost = 0.0;

      // Act
      final isValid = validationService.isValidExpense(description, cost);

      // Assert
      expect(isValid, isFalse);
    });
  });
}
