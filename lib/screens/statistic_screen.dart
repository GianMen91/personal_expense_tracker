import 'package:flutter/material.dart'; // Import Material Design components
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter BLoC for state management
import 'package:intl/intl.dart'; // Import Intl for date formatting

// Import BLoC files for managing expenses list and statistics state
import '../blocs/expense_list/expense_list_bloc.dart';
import '../blocs/expense_list/expense_list_state.dart';
import '../blocs/expenses_stat/expenses_stat_bloc.dart';
import '../blocs/expenses_stat/expenses_stat_state.dart';

// Import widgets used in the statistics screen
import '../widgets/category_selector.dart';
import '../widgets/expense_card_list.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/total_expense_card.dart';
import '../widgets/year_selector.dart';

// StatisticScreen displays expense statistics, charts, and filters.
class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesListBloc, ExpensesListState>(
        // Listen to changes in the list of expenses
        builder: (context, listState) {
      return BlocBuilder<ExpensesStatBloc, ExpensesStatState>(
        // Listen to changes in the selected filters (year, month, category)
        builder: (context, statState) {
          // Show a loading indicator if expenses are still being fetched
          if (listState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show an error message if there was a problem fetching expenses
          if (listState.errorMessage != null) {
            return Center(child: Text(listState.errorMessage!));
          }

          final expensesStatBloc = context
              .read<ExpensesStatBloc>(); // Get the statistics BLoC instance

          // Filter expenses based on selected year, month, and category
          final filteredExpenses = expensesStatBloc.getFilteredExpenses(
              listState.expenses, statState);

          // Calculate the total amount of filtered expenses
          final totalAmount =
              expensesStatBloc.calculateTotalAmount(filteredExpenses);

          // Find the category with the highest spending
          final highestSpendingCategory =
              expensesStatBloc.getHighestSpendingCategory(filteredExpenses,
                  statState.selectedDate, statState.selectedMonth);

          // Get monthly expense data for the selected year
          final monthlyData = expensesStatBloc.getMonthlyData(
              listState.expenses, statState.selectedDate);

          return Container(
            color: const Color(0xFFF5F5F5), // Set background color
            child: SingleChildScrollView(
              // Allows vertical scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display total expenses card with selected filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TotalExpenseCard(
                      key: const Key('total_expense_card'),
                      totalAmount: totalAmount,
                      title: statState.selectedMonth != null
                          ? 'Total Expenses ${statState.selectedMonth} ${DateFormat('yyyy').format(statState.selectedDate)}'
                          : 'Total Expenses ${DateFormat('yyyy').format(statState.selectedDate)}',
                      category: statState.selectedCategory,
                      highestSpendingCategory: highestSpendingCategory,
                    ),
                  ),

                  // Widget to select the year
                  YearSelector(
                      selectedDate: statState.selectedDate,
                      key: const Key('year_selector')),

                  // Bar chart displaying expenses per month
                  MonthlyChart(
                      key: const Key('monthly_chart'),
                      monthlyData: monthlyData,
                      selectedMonth: statState.selectedMonth),

                  // Dropdown menu to filter expenses by category
                  CategorySelector(
                      key: const Key('category_selector'),
                      selectedCategory: statState.selectedCategory),

                  // List of filtered expenses displayed as cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ExpenseCardsList(
                        expenses: filteredExpenses,
                        key: const Key('expense_cards_list')),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
