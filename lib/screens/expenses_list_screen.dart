import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_state.dart';

import '../blocs/expenses_event.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';

import 'package:intl/intl.dart';
import '../constants.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final groupedExpenses = <String, List<Expense>>{};

    for (var expense in expenses) {
      final dateStr = _formatDate(expense.date);
      if (!groupedExpenses.containsKey(dateStr)) {
        groupedExpenses[dateStr] = [];
      }
      groupedExpenses[dateStr]!.add(expense);
    }

    return Map.fromEntries(groupedExpenses.entries.toList()
      ..sort((a, b) {
        DateTime dateA = _parseDate(a.key);
        DateTime dateB = _parseDate(b.key);
        return dateB.compareTo(dateA);
      }));
  }

  DateTime _parseDate(String dateStr) {
    if (dateStr == 'Today') {
      return DateTime.now();
    }
    return DateFormat('dd MMM').parse(dateStr);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return DateFormat('dd MMM').format(date);
  }

  double _calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((expense) =>
            expense.date.year == now.year && expense.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.cost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final monthlyTotal = _calculateMonthlyTotal(state.expense);
          final groupedExpenses = _groupExpensesByDate(state.expense);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: kThemeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '${monthlyTotal.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Total expense this month',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedExpenses.length,
                    itemBuilder: (context, index) {
                      final date = groupedExpenses.keys.elementAt(index);
                      final expenses = groupedExpenses[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          ...expenses.map((expense) => ExpenseCard(
                                expense: expense,
                                onDelete: (expense) {
                                  // Dispatch DeleteExpense event to remove item
                                  context
                                      .read<ExpensesBloc>()
                                      .add(DeleteExpense(expense));
                                },
                              )),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
