import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_event.dart';
import 'package:personal_expense_tracker/blocs/expense_form/expense_form_state.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_bloc.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_event.dart';
import 'package:personal_expense_tracker/blocs/expense_list/expense_list_state.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_event.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_state.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_bloc.dart';
import 'package:personal_expense_tracker/blocs/navigation/navigation_state.dart';

import '../widgets_tests/bottom_menu_test.dart';

class MockExpensesListBloc extends MockBloc<ExpensesListEvent, ExpensesListState>
    implements ExpensesListBloc {}

class MockExpensesStatBloc extends MockBloc<ExpensesStatEvent, ExpensesStatState>
    implements ExpensesStatBloc {}

class MockExpenseFormBloc extends MockBloc<ExpenseFormEvent, ExpenseFormState>
    implements ExpenseFormBloc {}

void main() {
  group('HomeScreen Integration Tests', () {
    late MockNavigationBloc mockNavigationBloc;
    late MockExpensesListBloc mockExpensesListBloc;
    late MockExpensesStatBloc mockExpensesStatBloc;
    late MockExpenseFormBloc mockExpenseFormBloc;

    setUp(() {
      mockNavigationBloc = MockNavigationBloc();
      mockExpensesListBloc = MockExpensesListBloc();
      mockExpensesStatBloc = MockExpensesStatBloc();
      mockExpenseFormBloc = MockExpenseFormBloc();

      // Stub initial states
      whenListen(mockNavigationBloc,
        Stream.value(NavigationState(0)),
        initialState: NavigationState(0),
      );

      whenListen(mockExpensesListBloc,
        Stream.value(ExpensesListState(expenses: [])),
        initialState: ExpensesListState(expenses: []),
      );

      whenListen(mockExpensesStatBloc,
        Stream.value(ExpensesStatState(selectedDate: DateTime(2024))),
        initialState: ExpensesStatState(selectedDate: DateTime(2024)),
      );

    });

    Widget createTestWidget() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>.value(value: mockNavigationBloc),
          BlocProvider<ExpensesListBloc>.value(value: mockExpensesListBloc),
          BlocProvider<ExpensesStatBloc>.value(value: mockExpensesStatBloc),
          BlocProvider<ExpenseFormBloc>.value(value: mockExpenseFormBloc),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('should display initial expenses screen with all elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_title_app_bar')), findsOneWidget);
      expect(find.byKey(const Key('total_expense_card')), findsOneWidget);
      expect(find.text('0.00 €'), findsOneWidget);
      expect(find.byKey(const Key('expenses_list_screen')), findsOneWidget);
    });

    testWidgets('should open category dialog when tapping FAB', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byKey(const Key('add_expense_button')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('select_category_dialog')), findsOneWidget);
    });
  });


}