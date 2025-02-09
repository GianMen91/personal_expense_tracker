import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';

import 'package:personal_expense_tracker/widgets/year_selector.dart';

void main() {
  testWidgets('YearSelector widget test', (WidgetTester tester) async {
    final selectedDate = DateTime(2025);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExpensesStatBloc>(
          create: (_) => ExpensesStatBloc(),
          child: Scaffold(
            body: YearSelector(selectedDate: selectedDate),
          ),
        ),
      ),
    );

    // Verify the initial year is displayed correctly
    expect(find.byKey(Key('current_year_text')), findsOneWidget);
    expect(
        find.text('2025'), findsOneWidget); // Ensure the displayed year is 2025

    // Verify the previous and next year buttons exist
    expect(find.byKey(Key('previous_year_icon')), findsOneWidget);
    expect(find.byKey(Key('next_year_icon')), findsOneWidget);
  });
}
