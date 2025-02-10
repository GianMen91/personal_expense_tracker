import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_event.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';

void main() {
  late ExpensesStatBloc bloc;

  // Test expenses for multiple test cases
  final testExpenses = [
    Expense(
      id: 1,
      category: 'Food',
      description: 'Lunch',
      cost: 10.0,
      date: DateTime(2024, 2, 9),
    ),
    Expense(
      id: 2,
      category: 'Food',
      description: 'Dinner',
      cost: 20.0,
      date: DateTime(2024, 2, 8),
    ),
    Expense(
      id: 3,
      category: 'Transport',
      description: 'Bus',
      cost: 5.0,
      date: DateTime(2024, 1, 15),
    ),
    Expense(
      id: 4,
      category: 'Shopping',
      description: 'Clothes',
      cost: 50.0,
      date: DateTime(2023, 12),
    ),
  ];

  // Setup: Initialize the bloc before each test
  setUp(() {
    bloc = ExpensesStatBloc();
  });

  // Teardown: Close the bloc after each test
  tearDown(() {
    bloc.close();
  });

  group('ExpensesStatBloc', () {
    // Test case for initial state
    test('initial state is correct', () {
      expect(bloc.state.selectedCategory, equals('ALL'));
      expect(bloc.state.selectedMonth, isNull);
      expect(bloc.state.selectedDate.year, equals(DateTime.now().year));
    });

    // Test for ChangeCategoryEvent
    blocTest<ExpensesStatBloc, ExpensesStatState>(
      'emits new state when ChangeCategoryEvent is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangeCategoryEvent('Food')),
      expect: () => [
        predicate<ExpensesStatState>((state) => state.selectedCategory == 'Food'),
      ],
    );

    // Test for ChangeYearEvent
    blocTest<ExpensesStatBloc, ExpensesStatState>(
      'emits new state when ChangeYearEvent is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangeYearEvent(1)),
      expect: () => [
        predicate<ExpensesStatState>((state) => state.selectedDate.year == DateTime.now().year + 1),
      ],
    );

    // Test for ChangeMonthSelectionEvent
    blocTest<ExpensesStatBloc, ExpensesStatState>(
      'emits new state when ChangeMonthSelectionEvent is added',
      build: () => bloc,
      act: (bloc) => bloc.add(ChangeMonthSelectionEvent('Feb')),
      expect: () => [
        predicate<ExpensesStatState>((state) => state.selectedMonth == 'Feb'),
      ],
    );

    group('getFilteredExpenses', () {
      // Test for filtering expenses by year
      test('filters by year correctly', () {
        final state = ExpensesStatState(selectedDate: DateTime(2024));
        final filtered = bloc.getFilteredExpenses(testExpenses, state);
        expect(filtered.length, equals(3)); // Expenses from 2024 should be filtered
        expect(filtered.every((e) => e.date.year == 2024), isTrue);
      });

      // Test for filtering expenses by category
      test('filters by category correctly', () {
        final state = ExpensesStatState(
          selectedDate: DateTime(2024),
          selectedCategory: 'Food',
        );
        final filtered = bloc.getFilteredExpenses(testExpenses, state);
        expect(filtered.length, equals(2)); // Only 'Food' expenses should be returned
        expect(filtered.every((e) => e.category == 'Food'), isTrue);
      });

      // Test for filtering expenses by month
      test('filters by month correctly', () {
        final state = ExpensesStatState(
          selectedDate: DateTime(2024),
          selectedMonth: 'Feb',
        );
        final filtered = bloc.getFilteredExpenses(testExpenses, state);
        expect(filtered.length, equals(2)); // Expenses in 'Feb' should be returned
        expect(filtered.every((e) =>
        DateFormat('MMM').format(e.date) == 'Feb' && e.date.year == 2024),
            isTrue);
      });

      // Test for sorting expenses by date
      test('sorts expenses by date in descending order', () {
        final state = ExpensesStatState(selectedDate: DateTime(2024));
        final filtered = bloc.getFilteredExpenses(testExpenses, state);
        expect(filtered.first.date.isAfter(filtered.last.date), isTrue); // Sorted by date
      });
    });

    // Test for calculating total amount
    test('calculateTotalAmount returns correct sum', () {
      final total = bloc.calculateTotalAmount(testExpenses);
      expect(total, equals(85.0)); // Total of all test expenses
    });

    group('getHighestSpendingCategory', () {
      // Test when there is a clear highest spending category
      test('returns correct category when there is a clear highest', () {
        final result = bloc.getHighestSpendingCategory(
          testExpenses,
          DateTime(2024, 2),
          'Feb',
        );
        expect(result, equals('Food')); // 'Food' should be the highest category
      });

      // Test for tie in the highest spending category
      test('returns multiple categories when there is a tie', () {
        final tieExpenses = [
          Expense(id: 1, category: 'Food', description: 'Lunch', cost: 10.0, date: DateTime(2024, 2)),
          Expense(id: 2, category: 'Transport', description: 'Bus', cost: 10.0, date: DateTime(2024, 2)),
        ];
        final result = bloc.getHighestSpendingCategory(
          tieExpenses,
          DateTime(2024, 2),
          'Feb',
        );
        expect(result, equals('Food, Transport')); // Both 'Food' and 'Transport' should be the highest
      });

      // Test when no expenses exist
      test('returns null when no expenses exist', () {
        final result = bloc.getHighestSpendingCategory(
          [],
          DateTime(2024, 2),
          'Feb',
        );
        expect(result, isNull); // No highest category as there are no expenses
      });
    });

    group('getMonthlyData', () {
      // Test for retrieving data for all months of the year
      test('returns data for all months of the year', () {
        final monthlyData = bloc.getMonthlyData(testExpenses, DateTime(2024));
        expect(monthlyData.length, equals(12)); // 12 months should be returned
      });

      // Test for calculating monthly totals correctly
      test('calculates monthly totals correctly', () {
        final monthlyData = bloc.getMonthlyData(testExpenses, DateTime(2024));
        final febTotal = monthlyData.firstWhere((entry) => entry.key == 'Feb').value;
        expect(febTotal, equals(30.0)); // Sum of 'Food' expenses in 'Feb'
      });

      // Test for handling months with no expenses
      test('returns zero for months with no expenses', () {
        final monthlyData = bloc.getMonthlyData(testExpenses, DateTime(2024));
        final marTotal = monthlyData.firstWhere((entry) => entry.key == 'Mar').value;
        expect(marTotal, equals(0.0)); // No expenses in March, should return zero
      });
    });
  });
}
