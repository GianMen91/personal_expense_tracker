import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_event.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/screens/statistic_screen.dart';


class MockExpensesListBloc extends MockBloc<ExpensesListEvent, ExpensesListState>
    implements ExpensesListBloc {}

class MockExpensesStatBloc extends MockBloc<ExpensesStatEvent, ExpensesStatState>
    implements ExpensesStatBloc {}



void main() {
  late MockExpensesListBloc mockExpensesListBloc;
  late MockExpensesStatBloc mockExpensesStatBloc;

  // Add to setUp() after mock initialization
  registerFallbackValue(ExpensesStatState(
    selectedDate: DateTime.now(),
  ));

  final testExpenses = [
    Expense(
      category: 'Groceries',
      cost: 50.0,
      description: 'Food',
      date: DateTime(2024, 1, 15),
    ),
    Expense(
      category: 'Transport',
      cost: 30.0,
      description: 'Fuel',
      date: DateTime(2024, 1, 20),
    ),
  ];

  setUp(() {
    mockExpensesListBloc = MockExpensesListBloc();
    mockExpensesStatBloc = MockExpensesStatBloc();

    // Stub list bloc
    whenListen(
      mockExpensesListBloc,
      Stream.value(ExpensesListState(
        expenses: testExpenses,
        groupedExpenses: {},
      )),
      initialState: ExpensesListState(
        expenses: testExpenses,
        groupedExpenses: {},
      ),
    );

    // Stub stat bloc
    whenListen(
      mockExpensesStatBloc,
      Stream.value(ExpensesStatState(
        selectedDate: DateTime(2024),
        selectedMonth: 'Jan',
        selectedCategory: 'Food',
      )),
      initialState: ExpensesStatState(
        selectedDate: DateTime(2024),
        selectedMonth: 'Jan',
        selectedCategory: 'Food',
      ),
    );

    // Stub stat bloc methods
    when(() => mockExpensesStatBloc.getFilteredExpenses(any(), any()))
        .thenReturn(testExpenses);
    when(() => mockExpensesStatBloc.calculateTotalAmount(any()))
        .thenReturn(80.0);
    when(() => mockExpensesStatBloc.getHighestSpendingCategory(any(), any(), any()))
        .thenReturn('Food');
    when(() => mockExpensesStatBloc.getMonthlyData(any(), any()))
        .thenReturn([MapEntry('Jan', 80.0)]);
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpensesListBloc>.value(value: mockExpensesListBloc),
        BlocProvider<ExpensesStatBloc>.value(value: mockExpensesStatBloc),
      ],
      child: const MaterialApp(home: StatisticScreen()),
    );
  }

  testWidgets('should display loading indicator when list is loading', (tester) async {
    whenListen(
      mockExpensesListBloc,
      Stream.value(ExpensesListState(isLoading: true, expenses: [])),
      initialState: ExpensesListState(isLoading: true, expenses: []),
    );

    await tester.pumpWidget(createTestWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display error message when list has error', (tester) async {
    whenListen(
      mockExpensesListBloc,
      Stream.value(ExpensesListState(errorMessage: 'Loading failed', expenses: [])),
      initialState: ExpensesListState(errorMessage: 'Loading failed', expenses: []),
    );

    await tester.pumpWidget(createTestWidget());
    expect(find.text('Loading failed'), findsOneWidget);
  });

  testWidgets('should display all statistics components when loaded', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify main components
    expect(find.byKey(const Key('total_expense_card')), findsOneWidget);
    expect(find.byKey(const Key('year_selector')), findsOneWidget);
    expect(find.byKey(const Key('monthly_chart')), findsOneWidget);
    expect(find.byKey(const Key('category_selector')), findsOneWidget);
    expect(find.byKey(const Key('expense_cards_list')), findsOneWidget);
  });

}