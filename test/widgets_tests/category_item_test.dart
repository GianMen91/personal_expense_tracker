import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/category_item.dart';

void main() {
  testWidgets('CategoryItem renders correctly', (WidgetTester tester) async {
    // Create a test ExpenseCategory
    var testCategory = ExpenseCategories.categories[0];

    // Build the widget inside a testable environment
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryItem(category: testCategory),
        ),
      ),
    );

    // Verify that the category avatar is displayed
    expect(find.byKey(const Key('category_avatar')), findsOneWidget);

    // Verify that the category title is displayed correctly
    expect(find.byKey(const Key('category_title_text')), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
  });
}
