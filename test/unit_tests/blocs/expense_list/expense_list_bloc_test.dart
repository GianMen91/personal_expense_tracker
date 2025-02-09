import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/repositories/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

// Create a fake Expense for fallback registration
class FakeExpense extends Fake implements Expense {}

void main() {
  late ExpensesListBloc bloc;
  late MockDatabaseHelper mockDbHelper;

  // Test data
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

  setUpAll(() {
    // Register fallback value for Expense
    registerFallbackValue(FakeExpense());
  });

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    bloc = ExpensesListBloc(mockDbHelper);
  });

  tearDown(() {
    bloc.close();
  });

  group('ExpensesListBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.expenses, isEmpty);
      expect(bloc.state.isLoading, isTrue);
      expect(bloc.state.errorMessage, isNull);
    });

    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits loaded state when LoadExpense is added',
      build: () {
        when(() => mockDbHelper.getExpenses())
            .thenAnswer((_) async => testExpenses);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExpense()),
      expect: () => [
        predicate<ExpensesListState>((state) => state.isLoading == true),
        predicate<ExpensesListState>((state) {
          return state.isLoading == false &&
              state.expenses.length == 3 &&
              state.groupedExpenses.containsKey('Today') &&
              state.monthlyTotal > 0;
        }),
      ],
      verify: (_) {
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );

    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits error state when LoadExpense fails',
      build: () {
        when(() => mockDbHelper.getExpenses())
            .thenThrow(Exception('Database error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadExpense()),
      expect: () => [
        predicate<ExpensesListState>((state) => state.isLoading == true),
        predicate<ExpensesListState>((state) =>
            state.isLoading == false &&
            state.errorMessage == 'Exception: Database error'),
      ],
    );

    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits new state when AddExpense is added',
      build: () {
        when(() => mockDbHelper.addExpense(any())).thenAnswer((_) async => 1);
        when(() => mockDbHelper.getExpenses())
            .thenAnswer((_) async => testExpenses);
        return bloc;
      },
      act: (bloc) => bloc.add(AddExpense(testExpenses[0])),
      expect: () => [
        predicate<ExpensesListState>((state) =>
            state.expenses.length == 3 &&
            state.groupedExpenses.containsKey('Today')),
      ],
      verify: (_) {
        verify(() => mockDbHelper.addExpense(any())).called(1);
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );

    blocTest<ExpensesListBloc, ExpensesListState>(
      'emits new state when DeleteExpense is added',
      build: () {
        when(() => mockDbHelper.deleteExpense(any()))
            .thenAnswer((_) async => 1);
        when(() => mockDbHelper.getExpenses())
            .thenAnswer((_) async => testExpenses.sublist(1));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteExpense(testExpenses[0])),
      expect: () => [
        predicate<ExpensesListState>((state) =>
            state.expenses.length == 2 &&
            !state.groupedExpenses.containsKey('Today')),
      ],
      verify: (_) {
        verify(() => mockDbHelper.deleteExpense(any())).called(1);
        verify(() => mockDbHelper.getExpenses()).called(1);
      },
    );
  });
}
