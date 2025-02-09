import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/constants.dart';
import 'package:personal_expense_tracker/widgets/monthly_chart.dart';

//todo to fix
void main() {
  group('MonthlyChart Widget Tests', () {
    testWidgets('Displays bars with correct colors for selected and unselected months', (WidgetTester tester) async {
      // Example monthly data (MapEntry(month, amount))
      final monthlyData = [
        MapEntry('January', 100.0),
        MapEntry('February', 150.0),
        MapEntry('March', 200.0),
      ];

      // Build the MonthlyChart widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ExpensesStatBloc>(
              create: (_) => ExpensesStatBloc(),
              child: MonthlyChart(
                monthlyData: monthlyData,
                selectedMonth: 'February', // Make February the selected month
              ),
            ),
          ),
        ),
      );

      // Verify that bars for all three months are displayed
      expect(find.byKey(const Key('monthly_data')), findsNWidgets(3)); // Should find 3 bars

      // Verify the color of the February bar (selected month) is orange
      final februaryBar = tester.widget<Container>(
        find.descendant(of: find.text('February'), matching: find.byType(Container)).first,
      );
      final februaryBoxDecoration = februaryBar.decoration as BoxDecoration;
      expect(februaryBoxDecoration.color, Colors.orange);

      // Verify the color of the January and March bars (unselected months) are grey
      final januaryBar = tester.widget<Container>(
        find.descendant(of: find.text('January'), matching: find.byType(Container)).first,
      );
      final januaryBarBoxDecoration = januaryBar.decoration as BoxDecoration;
      expect(januaryBarBoxDecoration.color, kThemeColor.withOpacity(0.2)); // Greyish color

      final marchBar = tester.widget<Container>(
        find.descendant(of: find.text('March'), matching: find.byType(Container)).first,
      );
      final marchBarBoxDecoration = marchBar.decoration as BoxDecoration;
      expect(marchBarBoxDecoration.color, kThemeColor.withOpacity(0.2)); // Greyish color
    });

    testWidgets('Tapping on a bar changes the selected month color', (WidgetTester tester) async {
      // Example monthly data
      final monthlyData = [
        MapEntry('January', 100.0),
        MapEntry('February', 150.0),
        MapEntry('March', 200.0),
      ];

      // Build the MonthlyChart widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ExpensesStatBloc>(
              create: (_) => ExpensesStatBloc(),
              child: MonthlyChart(
                monthlyData: monthlyData,
                selectedMonth: 'February', // Initially selected month is February
              ),
            ),
          ),
        ),
      );

      // Tap on the January bar
      final januaryBar = find.descendant(of: find.text('January'), matching: find.byType(GestureDetector)).first;
      await tester.tap(januaryBar);
      await tester.pump();

      // After tapping, check if the January bar is now orange
      final updatedJanuaryBar = tester.widget<Container>(
        find.descendant(of: find.text('January'), matching: find.byType(Container)).first,
      );
      final updatedJanuaryBarBoxDecoration = updatedJanuaryBar.decoration as BoxDecoration;
      expect(updatedJanuaryBarBoxDecoration.color, Colors.orange);

      // Also, check if the February bar is now grey
      tester.widget<Container>(
        find.descendant(of: find.text('February'), matching: find.byType(Container)).first,
      );
      final updatedFebruaryBarBoxDecoration = updatedJanuaryBar.decoration as BoxDecoration;
      expect(updatedFebruaryBarBoxDecoration.color, kThemeColor.withOpacity(0.2)); // Greyish color
    });
  });
}
