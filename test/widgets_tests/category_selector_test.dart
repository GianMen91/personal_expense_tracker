import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/category_selector.dart';



//todo fix it
void main() {
  testWidgets('CategorySelector displays all categories from ExpenseCategories',
          (WidgetTester tester) async {
        final testCategories = ["ALL", ...ExpenseCategories.categories.map((c) => c.title)];

        // Build the widget tree with the CategorySelector widget
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExpensesStatBloc>(
              create: (context) => ExpensesStatBloc(),
              child: const Scaffold(
                body: CategorySelector(selectedCategory: "ALL"),
              ),
            ),
          ),
        );

        // Wait for the widget to build
        await tester.pump();

        // Scroll the ListView horizontally to make sure all categories are visible
        final scrollableFinder = find.byType(ListView);

        for (final category in testCategories) {
          // Scroll the ListView horizontally to make sure the category is visible

          await tester.pumpAndSettle(); // Wait for the scroll animation to complete

          // Check if the category text is visible in the widget tree
          expect(find.text(category), findsOneWidget);
          await tester.drag(scrollableFinder, const Offset(-1000, 0)); // Scroll left
        }
      });
}

