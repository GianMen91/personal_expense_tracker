import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/blocs/expenses_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_state.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/widgets/expense_card.dart';
import '../blocs/expenses_event.dart';
import '../constants.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String selectedCategory = "ALL";
  DateTime selectedDate = DateTime.now();


  void _changeYear(int offset) {
    setState(() {
      selectedDate = DateTime(selectedDate.year + offset, selectedDate.month);
    });
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
        final filteredExpenses = _getFilteredExpenses(state.expense);

        return Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalExpenseCard(totalAmount),
              _buildMonthSelector(),
              _buildMonthlyChart(monthlyData),
              _buildCategorySelector(),
              _buildExpensesList(filteredExpenses),
            ],
          ),
        );
      },
    );
  }


  Widget _buildTotalExpenseCard(double totalAmount) {
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
          Text(
            '${totalAmount.toStringAsFixed(2)} €',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            selectedCategory == "ALL" ? 'Total Expenses' : 'Total for $selectedCategory',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMMM, yyyy').format(selectedDate),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }


  List<MapEntry<String, double>> _getMonthlyData(List<Expense> expenses) {
    final Map<String, double> monthlyData = {
      for (var i = 1; i <= 12; i++) DateFormat('MMM').format(DateTime(0, i)): 0.0
    };

    for (var expense in expenses) {
      if (expense.date.year == selectedDate.year) {
        final month = DateFormat('MMM').format(expense.date);
        monthlyData[month] = monthlyData[month]! + expense.cost;
      }
    }

    return monthlyData.entries.toList();
  }


  double _getCategoryTotal(List<Expense> expenses) {
    if (selectedCategory == "ALL") {
      return expenses.fold(0, (sum, expense) => sum + expense.cost);
    }
    return expenses
        .where((expense) => expense.category == selectedCategory)
        .fold(0, (sum, expense) => sum + expense.cost);
  }


  List<Expense> _getFilteredExpenses(List<Expense> expenses) {
    return expenses.where((expense) {
      final isSameMonth = expense.date.year == selectedDate.year && expense.date.month == selectedDate.month;
      final isSameCategory = selectedCategory == "ALL" || expense.category == selectedCategory;
      return isSameMonth && isSameCategory;
    }).toList();
  }


  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.arrow_left, size: 30), onPressed: () => _changeYear(-1)),
         Text(
            DateFormat('yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

        IconButton(icon: const Icon(Icons.arrow_right, size: 30), onPressed: () => _changeYear(1)),
      ],
    );
  }


  Widget _buildMonthlyChart(List<MapEntry<String, double>> monthlyData) {
    final maxAmount = monthlyData.fold(0.0, (max, entry) => entry.value > max ? entry.value : max);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: monthlyData.map((entry) {
            final isCurrentMonth = entry.key == DateFormat('MMM').format(selectedDate);
            final heightPercent = maxAmount > 0 ? entry.value / maxAmount : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year, DateFormat('MMM').parse(entry.key).month);
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: 120 * heightPercent.toDouble(),
                      decoration: BoxDecoration(
                        color: isCurrentMonth ? Colors.orange : kThemeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.key, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Widget _buildCategorySelector() {
    final categories = ["ALL", ...ExpenseCategories.categories.map((c) => c.title)];

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
              setState(() {
                selectedCategory = category;
              });
            },
            child: _buildCategoryPill(category, category == selectedCategory),
          );
        },
      ),
    );
  }


  Widget _buildExpensesList(List<Expense> expenses) {
    return Expanded(
      child: ListView.builder(
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
      ),
    );
  }

  Widget _buildCategoryPill(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: isSelected ? kThemeColor : Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold)),
      ),
    );
  }
}
