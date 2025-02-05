import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/blocs/expenses_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/expense_card.dart';
import '../constants.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String selectedCategory = "ALL"; // Default to show all expenses
  DateTime selectedDate = DateTime.now();

  // Generates the last 5 months' data for the bar chart.
  List<MapEntry<String, double>> _getMonthlyData(List<Expense> expenses) {
    final monthlyData = <String, double>{};
    final now = DateTime.now();

    for (int i = 4; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthStr = DateFormat('MMM').format(month);
      monthlyData[monthStr] = 0;
    }

    for (var expense in expenses) {
      final expenseMonthStr = DateFormat('MMM').format(expense.date);
      if (monthlyData.containsKey(expenseMonthStr)) {
        monthlyData[expenseMonthStr] = (monthlyData[expenseMonthStr] ?? 0) + expense.cost;
      }
    }

    return monthlyData.entries.toList();
  }

  // Computes the total amount for the selected category and month.
  double _getCategoryTotal(List<Expense> expenses) {
    return expenses
        .where((expense) =>
    (selectedCategory == "ALL" || expense.category == selectedCategory) &&
        expense.date.month == selectedDate.month &&
        expense.date.year == selectedDate.year)
        .fold(0.0, (sum, expense) => sum + expense.cost);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final monthlyData = _getMonthlyData(state.expense);
        final totalAmount = _getCategoryTotal(state.expense);

        final selectedCategoryExpenses = state.expense
            .where((expense) =>
        (selectedCategory == "ALL" || expense.category == selectedCategory) &&
            expense.date.month == selectedDate.month &&
            expense.date.year == selectedDate.year)
            .toList();

        final maxAmount = monthlyData.fold(
          0.0,
              (max, entry) => entry.value > max ? entry.value : max,
        );

        final categories = ["ALL", ...ExpenseCategories.categories.map((c) => c.title)];

        return Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Expense Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kThemeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${totalAmount.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      selectedCategory == "ALL"
                          ? 'Total Expenses'
                          : 'Total Expense for $selectedCategory',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMMM, yyyy').format(selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Monthly Expenses Bar Chart
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: monthlyData.map((entry) {
                    final isCurrentMonth =
                        entry.key == DateFormat('MMM').format(selectedDate);
                    final heightPercent = maxAmount > 0 ? entry.value / maxAmount : 0;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          final monthIndex = DateFormat('MMM').parse(entry.key).month;
                          selectedDate = DateTime(selectedDate.year, monthIndex);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 30,
                            height: 120 * heightPercent.toDouble(),
                            decoration: BoxDecoration(
                              color: isCurrentMonth
                                  ? Colors.orange
                                  : kThemeColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.key,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Category Selection Pills
              Container(
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
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: _buildCategoryPill(category, category == selectedCategory),
                    );
                  },
                ),
              ),

              // Expenses List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: selectedCategoryExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = selectedCategoryExpenses[index];
                    return ExpenseCard(expense: expense);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Category Pill Widget
  Widget _buildCategoryPill(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? kThemeColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
