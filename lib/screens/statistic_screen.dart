import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/expense_card.dart';
import '../blocs/expenses/expenses_event.dart';
import '../constants.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final monthlyData = _getMonthlyData(state.expenses, state.selectedDate);
        final totalAmount = _getTotalAmount(state.expenses,
            state.selectedCategory, state.selectedDate, state.selectedMonth);
        final filteredExpenses = _getFilteredExpenses(state.expenses,
            state.selectedCategory, state.selectedDate, state.selectedMonth);

        return Container(
          color: const Color(0xFFF5F5F5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalExpenseCard(totalAmount, state.selectedDate,
                    state.selectedCategory, state.selectedMonth,state.expenses),
                _buildYearSelector(context, state.selectedDate),
                _buildMonthlyChart(monthlyData, context, state.selectedMonth),
                _buildCategorySelector(context, state.selectedCategory),
                _buildExpensesList(filteredExpenses, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalExpenseCard(double totalAmount, DateTime selectedDate,
      String selectedCategory, String? selectedMonth, List<Expense> expenses) {
    final highestSpendingCategory = _getHighestSpendingCategory(
        expenses,
        selectedDate,
        selectedMonth); // Get highest spending category

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
          Text(selectedMonth != null ? 'Total Expenses $selectedMonth ${DateFormat('yyyy').format(selectedDate)}' :'Total Expenses ${DateFormat('yyyy').format(selectedDate)}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (selectedCategory != "ALL" )
            Text(
              selectedCategory,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          const SizedBox(height: 8), // Add some spacing
          if (highestSpendingCategory !=
              null && selectedCategory == "ALL" ) // Show only if there are highest spending categories
            Text(
              'Categories where you spent the most: $highestSpendingCategory',
              // Display the categories
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }

  String? _getHighestSpendingCategory(
      List<Expense> expenses, DateTime selectedDate, String? selectedMonth) {
    final filteredExpenses = expenses.where((expense) {
      final isSameYear = expense.date.year == selectedDate.year;
      final isSameMonth = selectedMonth == null ||
          DateFormat('MMM').format(expense.date) == selectedMonth;
      return isSameYear && isSameMonth;
    }).toList();

    if (filteredExpenses.isEmpty) return null;

    final categoryTotals = <String, double>{};
    for (final expense in filteredExpenses) {
      categoryTotals.update(
        expense.category,
        (existingTotal) => existingTotal + expense.cost,
        ifAbsent: () => expense.cost,
      );
    }

    double highestTotal = 0;
    List<String> highestCategories =
        []; // Use a list to store multiple categories

    categoryTotals.forEach((category, total) {
      if (total > highestTotal) {
        highestTotal = total;
        highestCategories = [category]; // Start a new list
      } else if (total == highestTotal) {
        highestCategories.add(category); // Add to the existing list
      }
    });

    return highestCategories.isNotEmpty
        ? highestCategories.join(', ')
        : null; // Return a comma-separated string or null
  }

  double _getTotalAmount(List<Expense> expenses, String selectedCategory,
      DateTime selectedDate, String? selectedMonth) {
    return expenses.where((expense) {
      final isSameYear = expense.date.year == selectedDate.year;
      final isSameMonth = selectedMonth == null ||
          DateFormat('MMM').format(expense.date) == selectedMonth;
      final isSameCategory =
          selectedCategory == "ALL" || expense.category == selectedCategory;
      return isSameYear && isSameMonth && isSameCategory;
    }).fold(0, (sum, expense) => sum + expense.cost);
  }

  List<MapEntry<String, double>> _getMonthlyData(
      List<Expense> expenses, DateTime selectedDate) {
    final Map<String, double> monthlyData = {
      for (var i = 1; i <= 12; i++)
        DateFormat('MMM').format(DateTime(selectedDate.year, i)): 0.0
    };

    for (var expense in expenses) {
      if (expense.date.year == selectedDate.year) {
        final month = DateFormat('MMM').format(expense.date);
        monthlyData[month] = monthlyData[month]! + expense.cost;
      }
    }

    return monthlyData.entries.toList();
  }

  List<Expense> _getFilteredExpenses(List<Expense> expenses,
      String selectedCategory, DateTime selectedDate, String? selectedMonth) {
    return expenses.where((expense) {
      final isSameYear = expense.date.year == selectedDate.year;
      final isSameMonth = selectedMonth == null ||
          DateFormat('MMM').format(expense.date) == selectedMonth;
      final isSameCategory =
          selectedCategory == "ALL" || expense.category == selectedCategory;
      return isSameYear && isSameMonth && isSameCategory;
    }).toList();
  }

  Widget _buildYearSelector(BuildContext context, DateTime selectedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 30),
          onPressed: () {
            context.read<ExpensesBloc>().add(ChangeYearEvent(-1));
          },
        ),
        Text(
          DateFormat('yyyy').format(selectedDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 30),
          onPressed: () {
            context.read<ExpensesBloc>().add(ChangeYearEvent(1));
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
                  context.read<ExpensesBloc>().add(
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
              context.read<ExpensesBloc>().add(ChangeCategoryEvent(category));
            },
            child: _buildCategoryPill(category, category == selectedCategory),
          );
        },
      ),
    );
  }

  Widget _buildExpensesList(List<Expense> expenses, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseCard(
          expense: expense,
          onDelete: (expense) {
            context.read<ExpensesBloc>().add(DeleteExpense(expense));
          },
        );
      },
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
