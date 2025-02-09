import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart';

class MockExpensesListBloc
    extends MockBloc<ExpensesListEvent, ExpensesListState>
    implements ExpensesListBloc {}

void main() {
  group('ExpensesListScreen Integration Tests', () {
    late MockExpensesListBloc mockBloc;

    setUp(() {
      mockBloc = MockExpensesListBloc();
    });

    testWidgets('displays loading indicator when state is loading',
        (tester) async {
      // Arrange: Set up mock bloc to emit loading state
      whenListen(
        mockBloc,
        Stream.value(ExpensesListState(isLoading: true, expenses: [])),
        initialState: ExpensesListState(isLoading: true, expenses: []),
      );

      // Act: Build and render the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExpensesListBloc>.value(
            value: mockBloc,
            child: const ExpensesListScreen(),
          ),
        ),
      );

      // Assert: Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays total amount and expense list when data is loaded',
        (tester) async {
      // Arrange: Create test data
      final testExpenses = [
        Expense(
            category: 'Groceries',
            cost: 15.0,
            description: 'Edeka',
            date: DateTime.now()),
        Expense(
            category: 'Lunches & Dinners',
            cost: 20.0,
            description: 'McDonald\'s',
            date: DateTime.now()),
      ];

      // Set up mock bloc to emit loaded state
      whenListen(
        mockBloc,
        Stream.value(ExpensesListState(
          monthlyTotal: 35.0,
          expenses: testExpenses,
        )),
        initialState: ExpensesListState(expenses: []),
      );

      // Act: Build and render the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExpensesListBloc>.value(
            value: mockBloc,
            child: const ExpensesListScreen(),
          ),
        ),
      );

      // Wait for initial render
      await tester.pumpAndSettle();

      // Assert: Verify total amount is displayed
      expect(find.byKey(const Key('total_expense_card')), findsOneWidget);
      expect(find.text('35.00 €'), findsOneWidget);

      // Verify expense list is displayed
      expect(find.byKey(const Key('expense_list')), findsOneWidget);
    });
  });
}
