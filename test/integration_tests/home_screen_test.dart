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

// Mock implementation of ExpensesListBloc for testing
class MockExpensesListBloc extends MockBloc<ExpensesListEvent, ExpensesListState>
    implements ExpensesListBloc {}

// Mock implementation of ExpensesStatBloc for testing
class MockExpensesStatBloc extends MockBloc<ExpensesStatEvent, ExpensesStatState>
    implements ExpensesStatBloc {}

// Mock implementation of ExpenseFormBloc for testing
class MockExpenseFormBloc extends MockBloc<ExpenseFormEvent, ExpenseFormState>
    implements ExpenseFormBloc {}

void main() {
  group('HomeScreen Integration Tests', () {
    late MockNavigationBloc mockNavigationBloc;
    late MockExpensesListBloc mockExpensesListBloc;
    late MockExpensesStatBloc mockExpensesStatBloc;
    late MockExpenseFormBloc mockExpenseFormBloc;

    setUp(() {
      // Initialize mock blocs before each test
      mockNavigationBloc = MockNavigationBloc();
      mockExpensesListBloc = MockExpensesListBloc();
      mockExpensesStatBloc = MockExpensesStatBloc();
      mockExpenseFormBloc = MockExpenseFormBloc();

      // Stub initial states for the blocs
      whenListen(
        mockNavigationBloc,
        Stream.value(NavigationState(0)),
        initialState: NavigationState(0),
      );

      whenListen(
        mockExpensesListBloc,
        Stream.value(ExpensesListState(expenses: [])),
        initialState: ExpensesListState(expenses: []),
      );

      whenListen(
        mockExpensesStatBloc,
        Stream.value(ExpensesStatState(selectedDate: DateTime(2024))),
        initialState: ExpensesStatState(selectedDate: DateTime(2024)),
      );
    });

    /// Creates a test widget wrapped with all necessary BlocProviders
    Widget createTestWidget() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>.value(value: mockNavigationBloc),
          BlocProvider<ExpensesListBloc>.value(value: mockExpensesListBloc),
          BlocProvider<ExpensesStatBloc>.value(value: mockExpensesStatBloc),
          BlocProvider<ExpenseFormBloc>.value(value: mockExpenseFormBloc),
        ],
        child:  MaterialApp(
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('should display initial expenses screen with all elements', (tester) async {
      // Act: Render the HomeScreen inside the test widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for animations to settle

      // Assert: Verify key UI elements are displayed
      expect(find.byKey(const Key('home_title_app_bar')), findsOneWidget);
      expect(find.byKey(const Key('total_expense_card')), findsOneWidget);
      expect(find.text('0.00 €'), findsOneWidget);
      expect(find.byKey(const Key('expenses_list_screen')), findsOneWidget);
    });

    testWidgets('should open category dialog when tapping FAB', (tester) async {
      // Act: Render the HomeScreen inside the test widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate tapping the Floating Action Button (FAB)
      await tester.tap(find.byKey(const Key('add_expense_button')));
      await tester.pumpAndSettle(); // Wait for animations/dialog to open

      // Assert: Verify that the category selection dialog is shown
      expect(find.byKey(const Key('select_category_dialog')), findsOneWidget);
    });
  });
}
