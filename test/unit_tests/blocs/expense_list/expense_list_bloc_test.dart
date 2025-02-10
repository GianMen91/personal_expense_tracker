import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/repositories/database_helper.dart';

// Mock class for DatabaseHelper
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

// Fake class for Expense (used for mocking data)
class FakeExpense extends Fake implements Expense {}

void main() {
  late ExpensesListBloc bloc;
  late MockDatabaseHelper mockDbHelper;

  // Test expenses used for the tests
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));
  final lastMonth = today.subtract(const Duration(days: 32));

  final testExpenses = [
    Expense(
      id: 1,
      category: 'Food',
      description: 'Lunch',
      cost: 10.0,
      date: today,
    ),
    Expense(
      id: 2,
      category: 'Transport',
      description: 'Bus',
      cost: 5.0,
      date: yesterday,
    ),
    Expense(
      id: 3,
      category: 'Shopping',
      description: 'Clothes',
      cost: 50.0,
      date: lastMonth,
    ),
  ];

  // Setup function that runs once before any tests run
  setUpAll(() {
    // Register a fallback value for FakeExpense
    registerFallbackValue(FakeExpense());
  });

  // Setup function that runs before each test
  setUp(() {
    // Initialize mock database helper and the bloc
    mockDbHelper = MockDatabaseHelper();
    bloc = ExpensesListBloc(mockDbHelper);
  });

  // Teardown function that runs after each test
  tearDown(() {
    bloc.close(); // Close the bloc to avoid memory leaks
  });

  // Group of tests related to ExpensesListBloc
  group('ExpensesListBloc', () {
    test('initial state is correct', () {
      // Assert that the initial state of the bloc is as expected
      expect(bloc.state.expenses, isEmpty); // No expenses in the beginning
      expect(bloc.state.isLoading, isTrue); // Bloc starts in loading state
      expect(bloc.state.errorMessage, isNull); // No error message initially
    });

    // Test for successful expense loading
    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits loaded state when LoadExpense is added',
      build: () {
        // Mock the database helper to return test expenses
        when(() => mockDbHelper.getExpenses())
            .thenAnswer((_) async => testExpenses);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExpense()), // Add LoadExpense event
      expect: () => [
        // State while loading
        predicate<ExpensesListState>((state) => state.isLoading == true),
        // State after loading finishes
        predicate<ExpensesListState>((state) {
          return state.isLoading == false &&
              state.expenses.length == 3 && // 3 expenses loaded
              state.groupedExpenses
                  .containsKey('Today') && // Today's expenses grouped
              state.monthlyTotal > 0; // There should be a monthly total
        }),
      ],
      verify: (_) {
        // Verify that the database helper's getExpenses method is called once
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );

    // Test for error while loading expenses
    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits error state when LoadExpense fails',
      build: () {
        // Mock the database helper to throw an exception
        when(() => mockDbHelper.getExpenses())
            .thenThrow(Exception('Database error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExpense()), // Add LoadExpense event
      expect: () => [
        // State while loading
        predicate<ExpensesListState>((state) => state.isLoading == true),
        // State when error occurs
        predicate<ExpensesListState>((state) =>
            state.isLoading == false &&
            state.errorMessage == 'Exception: Database error'), // Error message
      ],
    );

    // Test for adding a new expense
    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits new state when AddExpense is added',
      build: () {
        // Mock the database helper methods for adding and fetching expenses
        when(() => mockDbHelper.addExpense(any())).thenAnswer((_) async => 1);
        when(() => mockDbHelper.getExpenses())
            .thenAnswer((_) async => testExpenses);
        return bloc;
      },
      act: (bloc) => bloc.add(AddExpense(testExpenses[0])),
      // Add the first test expense
      expect: () => [
        // State after adding the new expense
        predicate<ExpensesListState>((state) =>
            state.expenses.length == 3 && // New expense added
            state.groupedExpenses.containsKey('Today')),
        // Today's expenses grouped
      ],
      verify: (_) {
        // Verify that both addExpense and getExpenses were called
        verify(() => mockDbHelper.addExpense(any())).called(1);
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );

    // Test for deleting an expense
    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits new state when DeleteExpense is added',
      build: () {
        // Mock the database helper methods for deleting and fetching expenses
        when(() => mockDbHelper.deleteExpense(any()))
            .thenAnswer((_) async => 1);
        when(() => mockDbHelper.getExpenses()).thenAnswer(
            (_) async => testExpenses.sublist(1)); // Remove the first expense
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteExpense(testExpenses[0])),
      // Delete the first test expense
      expect: () => [
        // State after deleting the expense
        predicate<ExpensesListState>((state) =>
            state.expenses.length == 2 && // One expense removed
            !state.groupedExpenses.containsKey('Today')),
        // Today's expense should be removed
      ],
      verify: (_) {
        // Verify that both deleteExpense and getExpenses were called
        verify(() => mockDbHelper.deleteExpense(any())).called(1);
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );
  });
}
