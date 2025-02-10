import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_event.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_state.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/models/expense_validation_service.dart';
import 'package:mockito/annotations.dart';

import 'expense_form_bloc_test.mocks.dart';

// Generate mocks for dependencies (ExpenseValidationService and ExpensesListBloc)
@GenerateMocks([ExpenseValidationService, ExpensesListBloc])
void main() {
  // Declare the necessary mock objects and ExpenseFormBloc
  late ExpenseFormBloc expenseFormBloc;
  late MockExpenseValidationService mockValidationService;
  late MockExpensesListBloc mockExpensesListBloc;

  // Setup before each test
  setUp(() {
    // Initialize the mocks
    mockValidationService = MockExpenseValidationService();
    mockExpensesListBloc = MockExpensesListBloc();
    // Create the ExpenseFormBloc with mocked dependencies
    expenseFormBloc = ExpenseFormBloc(
      validationService: mockValidationService,
      expensesBloc: mockExpensesListBloc,
    );
  });

  // Clean up after each test
  tearDown(() {
    expenseFormBloc.close();
  });

  // Group of tests related to ExpenseFormBloc
  group('ExpenseFormBloc Tests', () {
    test('should not submit form when invalid', () {
      // Arrange
      final expenseCategory = ExpenseCategories.categories[0]; // Use a sample category

      // Mock the validation service to return false for invalid data
      when(mockValidationService.isValidExpense('', null)).thenReturn(false);

      // Set up the ExpenseFormBloc's state to simulate an invalid form (no cost, invalid category)
      expenseFormBloc.emit(
        ExpenseFormState(
          date: DateTime(2025, 2, 10),
        ),
      );

      // Act: Trigger the form submission event
      expenseFormBloc.add(FormSubmitted(expenseCategory));

      // Assert: Verify that the ExpensesListBloc's add method is never called (form should not be submitted)
      verifyNever(mockExpensesListBloc.add(any)); // No expense should be added due to invalid form
    });
  });
}
