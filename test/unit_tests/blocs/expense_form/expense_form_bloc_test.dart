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

// Generate mocks for dependencies
@GenerateMocks([ExpenseValidationService, ExpensesListBloc])
void main() {
  late ExpenseFormBloc expenseFormBloc;
  late MockExpenseValidationService mockValidationService;
  late MockExpensesListBloc mockExpensesListBloc;

  setUp(() {
    mockValidationService = MockExpenseValidationService();
    mockExpensesListBloc = MockExpensesListBloc();
    expenseFormBloc = ExpenseFormBloc(
      validationService: mockValidationService,
      expensesBloc: mockExpensesListBloc,
    );
  });

  tearDown(() {
    expenseFormBloc.close();
  });

  group('ExpenseFormBloc Tests', () {
    test('should not submit form when invalid', () {
      // Arrange

      final expenseCategory = ExpenseCategories.categories[0];

      when(mockValidationService.isValidExpense('', null)).thenReturn(false);

      // Setting up invalid state
      expenseFormBloc.emit(
        ExpenseFormState(
          date: DateTime(2025, 2, 10),
        ),
      );

      // Act
      expenseFormBloc.add(FormSubmitted(expenseCategory));

      // Assert
      verifyNever(mockExpensesListBloc.add(any)); // Should not add expense
    });
  });
}
