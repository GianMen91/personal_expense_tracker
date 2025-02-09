import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';

import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/widgets/expense_card.dart';
import 'package:personal_expense_tracker/widgets/expense_card_list.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';

class MockExpenseListBloc extends MockBloc<ExpensesListEvent, ExpensesListState>
    implements ExpensesListBloc {}

void main() {
  group('ExpenseCardsList', () {
    late ExpensesListBloc expenseListBloc;

    setUp(() {
      expenseListBloc = MockExpenseListBloc();
    });

    testWidgets('displays correct number of expense cards', (tester) async {
      // Create some sample expenses
      final expenses = [
        Expense(
          id: 1,
          description: 'Bus to Rome',
          category: 'Transport',
          cost: 25.0,
          date: DateTime.now(),
        ),
        Expense(
          id: 2,
          description: 'Edeka',
          category: 'Groceries',
          cost: 50.0,
          date: DateTime.now(),
        ),
      ];

      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: expenseListBloc,
            child: ExpenseCardsList(expenses: expenses),
          ),
        ),
      );

      // Verify that the correct number of ExpenseCards are displayed
      expect(find.byType(ExpenseCard), findsNWidgets(expenses.length));
    });

    testWidgets('displays the correct data in expense cards', (tester) async {
      final expenses = [
        Expense(
          id: 1,
          description: 'Bus to Rome',
          category: 'Transport',
          cost: 25.0,
          date: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: expenseListBloc,
            child: ExpenseCardsList(expenses: expenses),
          ),
        ),
      );

      // Verify that the expense description and cost are shown
      expect(find.text('Bus to Rome'), findsOneWidget);
      expect(find.text('25.00 €'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
    });
  });
}
