import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/widgets/expense_card.dart';

void main() {
  testWidgets('ExpenseCard displays content', (WidgetTester tester) async {
    final expense = Expense(
      id: 1,
      description: 'Bus to Rome',
      category: 'Transport',
      cost: 25.0,
      date: DateTime.fromMillisecondsSinceEpoch(1738972640905785),
    );

    // Create a mock function for the onDelete callback
    void onDelete(Expense expense) {}

    // Build the widget tree with ExpenseCard
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpenseCard(
            expense: expense,
            onDelete: onDelete,
          ),
        ),
      ),
    );

    // Check that the expense description is displayed
    expect(find.text('Bus to Rome'), findsOneWidget);

    // Check that the category title is displayed
    expect(find.text('Transport'), findsOneWidget);

    // Check that the cost is displayed
    expect(find.text('25.00 €'), findsOneWidget);

    // Swipe the card from right to left to trigger dismiss
    final dismissibleFinder = find.byType(Dismissible);
    await tester.drag(dismissibleFinder, const Offset(-300, 0)); // Swipe left
    await tester.pumpAndSettle(); // Wait for the swipe animation to complete
  });
}
