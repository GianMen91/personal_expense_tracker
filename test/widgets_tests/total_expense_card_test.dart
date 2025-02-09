import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/widgets/total_expense_card.dart';

void main() {
  testWidgets('TotalExpenseCard displays correctly: Card with all fields populated', (WidgetTester tester) async {
    // Test 1: Card with all fields populated
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TotalExpenseCard(
            totalAmount: 120.50,
            title: 'Total Expenses Feb 2025',
            category: 'ALL',
            highestSpendingCategory: 'Groceries',
          ),
        ),
      ),
    );

    // Verify if the total amount is displayed correctly
    expect(find.byKey(Key('total_amount_text')), findsOneWidget);

    // Verify title text
    expect(find.byKey(Key('title_text')), findsOneWidget);

    // Verify subtitle text
    expect(find.byKey(Key('subtitle_text')), findsNothing);

    // Verify category text
    expect(find.byKey(Key('category_text')), findsNothing);

    // Verify highest spending category text
    expect(find.byKey(Key('highest_spending_category_text')), findsOneWidget);
  });

  testWidgets('TotalExpenseCard displays correctly: Card without subtitle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TotalExpenseCard(
            totalAmount: 150.75,
            title: 'Total Spending',
            category: 'Entertainment',
          ),
        ),
      ),
    );

    // Verify subtitle is not shown
    expect(find.byKey(Key('subtitle_text')), findsNothing);

    // Verify category text
    expect(find.byKey(Key('category_text')), findsOneWidget);
  });


  testWidgets('TotalExpenseCard displays correctly: Card with category "ALL" and highestSpendingCategory', (WidgetTester tester) async {

    // Test 3:
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TotalExpenseCard(
            totalAmount: 200.00,
            title: 'Total Expenses',
            category: 'ALL',
            highestSpendingCategory: 'Shopping',
          ),
        ),
      ),
    );

    // Verify the highest spending category is shown when category is "ALL"
    expect(find.byKey(Key('highest_spending_category_text')), findsOneWidget);

    // Verify that category text "ALL" is not shown when highestSpendingCategory is shown
    expect(find.byKey(Key('category_text')), findsNothing);

    // Test 4: Card with only title and totalAmount
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TotalExpenseCard(
            totalAmount: 50.25,
            title: 'Total',
          ),
        ),
      ),
    );

    // Verify that only title and total amount are shown
    expect(find.byKey(Key('total_amount_text')), findsOneWidget);
    expect(find.byKey(Key('title_text')), findsOneWidget);
    expect(find.byKey(Key('subtitle_text')), findsNothing);
    expect(find.byKey(Key('category_text')), findsNothing);
    expect(find.byKey(Key('highest_spending_category_text')), findsNothing);
  });
}
