import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/widgets/expense_card_list.dart';
import 'package:personal_expense_tracker/widgets/expense_list.dart';

void main() {
  testWidgets('ExpenseList displays grouped expenses correctly',
      (WidgetTester tester) async {
    // Sample grouped expenses data
    final groupedExpenses = {
      '2025-02-01': [
        Expense(
          id: 1,
          description: 'Bus to Rome',
          category: 'Transport',
          cost: 25.0,
          date: DateTime(2025, 2),
        ),
      ],
      '2025-02-02': [
        Expense(
          id: 2,
          description: 'Lunch at Cafe',
          category: 'Bars',
          cost: 15.0,
          date: DateTime(2025, 2, 2),
        ),
      ],
    };

    // Build the ExpenseList widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpenseList(groupedExpenses: groupedExpenses),
        ),
      ),
    );

    // Check if the dates are displayed correctly
    expect(find.text('2025-02-01'), findsOneWidget);
    expect(find.text('2025-02-02'), findsOneWidget);

    // Check if the expense descriptions are displayed correctly
    expect(find.text('Bus to Rome'), findsOneWidget);
    expect(find.text('Lunch at Cafe'), findsOneWidget);

    // Check if the ExpenseCardsList is present in the widget tree
    expect(
        find.byType(ExpenseCardsList), findsNWidgets(groupedExpenses.length));

    // Verify that the expense cards are shown for each date group
    for (var date in groupedExpenses.keys) {
      final expenses = groupedExpenses[date]!;
      for (var expense in expenses) {
        expect(find.text(expense.description), findsOneWidget);
      }
    }
  });
}
