import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import '../blocs/expense_list/expense_list_bloc.dart';
import '../blocs/expense_list/expense_list_state.dart';
import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_event.dart';
import '../blocs/expenses_stat/expenses_stat_state.dart';
import '../constants.dart';
import '../widgets/category_selector.dart';
import '../widgets/expense_card_list.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/year_selector.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesListBloc, ExpensesListState>(
        builder: (context, listState) {
      return BlocBuilder<ExpensesStatBloc, ExpensesStatState>(
        builder: (context, statState) {
          if (listState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (listState.errorMessage != null) {
            return Center(child: Text(listState.errorMessage!));
          }

          final expensesStatBloc =
              context.read<ExpensesStatBloc>(); // Get the bloc instance

          final filteredExpenses = expensesStatBloc.getFilteredExpenses(
              listState.expenses, statState); // Use the bloc's function
          final totalAmount =
              expensesStatBloc.calculateTotalAmount(filteredExpenses);
          final highestSpendingCategory =
              expensesStatBloc.getHighestSpendingCategory(filteredExpenses,
                  statState.selectedDate, statState.selectedMonth);
          final monthlyData = expensesStatBloc.getMonthlyData(
              listState.expenses, statState.selectedDate);

          return Container(
            color: const Color(0xFFF5F5F5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalExpenseCard(
                      totalAmount,
                      statState.selectedDate,
                      statState.selectedCategory,
                      statState.selectedMonth,
                      listState.expenses,
                      highestSpendingCategory),
                  YearSelector(selectedDate: statState.selectedDate),
                  MonthlyChart(
                      monthlyData: monthlyData,
                      selectedMonth: statState.selectedMonth),
                  CategorySelector(selectedCategory: statState.selectedCategory),
                  ExpenseCardsList(expenses: filteredExpenses),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTotalExpenseCard(
      double totalAmount,
      DateTime selectedDate,
      String selectedCategory,
      String? selectedMonth,
      List<Expense> expenses,
      String? highestSpendingCategory) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kThemeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '${totalAmount.toStringAsFixed(2)} €',
            style: const TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            selectedMonth != null
                ? 'Total Expenses $selectedMonth ${DateFormat('yyyy').format(selectedDate)}'
                : 'Total Expenses ${DateFormat('yyyy').format(selectedDate)}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (selectedCategory != "ALL")
            Text(
              selectedCategory,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          const SizedBox(height: 8), // Add some spacing
          if (highestSpendingCategory != null &&
              selectedCategory ==
                  "ALL") // Show only if there are highest spending categories
            Text(
              'Categories where you spent the most: $highestSpendingCategory',
              // Display the categories
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }
}
