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
import '../widgets/expense_card_list.dart';

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
                  _buildYearSelector(context, statState.selectedDate),
                  _buildMonthlyChart(
                      monthlyData, context, statState.selectedMonth),
                  _buildCategorySelector(context, statState.selectedCategory),
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

  Widget _buildYearSelector(BuildContext context, DateTime selectedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 30),
          onPressed: () {
            context.read<ExpensesStatBloc>().add(ChangeYearEvent(-1));
          },
        ),
        Text(
          DateFormat('yyyy').format(selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 30),
          onPressed: () {
            context.read<ExpensesStatBloc>().add(ChangeYearEvent(1));
          },
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(List<MapEntry<String, double>> monthlyData,
      BuildContext context, String? selectedMonth) {
    final maxAmount = monthlyData.fold(
        0.0, (max, entry) => entry.value > max ? entry.value : max);

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: monthlyData.map((entry) {
            final heightPercent = maxAmount > 0 ? entry.value / maxAmount : 0;
            final isSelected = entry.key == selectedMonth;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  context.read<ExpensesStatBloc>().add(
                      ChangeMonthSelectionEvent(isSelected ? null : entry.key));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Container(
                        width: 30,
                        height: 120 * heightPercent.toDouble(),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : kThemeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.key,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, String selectedCategory) {
    final categories = [
      "ALL",
      ...ExpenseCategories.categories.map((c) => c.title)
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              context
                  .read<ExpensesStatBloc>()
                  .add(ChangeCategoryEvent(category));
            },
            child: _buildCategoryPill(category, category == selectedCategory),
          );
        },
      ),
    );
  }

  Widget _buildCategoryPill(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: isSelected ? kThemeColor : Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(title,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
