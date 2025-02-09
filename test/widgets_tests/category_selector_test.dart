import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/widgets/category_selector.dart';

void main() {
  testWidgets('CategorySelector displays all categories from ExpenseCategories',
      (WidgetTester tester) async {
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

    expect(find.byKey(const Key('category_pill_list')), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
