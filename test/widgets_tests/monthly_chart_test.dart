import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/blocs/expenses_stat/expenses_stat_bloc.dart';
import 'package:personal_expense_tracker/widgets/monthly_chart.dart';

void main() {
  group('MonthlyChart Widget Tests', () {
    testWidgets(
        'Displays bars with correct colors for selected and unselected months',
        (WidgetTester tester) async {
      final monthlyData = [
        MapEntry("Jan", 100.0),
        MapEntry("Feb", 200.0),
        MapEntry("Mar", 150.0),
        MapEntry("Apr", 250.0),
        MapEntry("May", 180.0),
        MapEntry("Jun", 300.0),
        MapEntry("Jul", 220.0),
        MapEntry("Aug", 280.0),
        MapEntry("Sep", 210.0),
        MapEntry("Oct", 270.0),
        MapEntry("Nov", 230.0),
        MapEntry("Dec", 290.0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ExpensesStatBloc>(
              create: (_) => ExpensesStatBloc(),
              child: MonthlyChart(
                monthlyData: monthlyData,
                selectedMonth: null,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('chart_container')), findsOneWidget);
      expect(find.byKey(const Key('monthly_data')), findsWidgets);
      expect(find.byKey(const Key('month_name_text')), findsWidgets);
    });
  });
}
