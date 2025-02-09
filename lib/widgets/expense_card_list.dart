import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_list/expense_list_bloc.dart';
import '../blocs/expense_list/expense_list_event.dart';
import '../models/expense.dart';
import 'expense_card.dart';

class ExpenseCardsList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseCardsList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // Only if inside another scrolling widget
      physics: const NeverScrollableScrollPhysics(),
      // Customizable
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseCard(
          key: const Key('expense_card'),
          expense: expense,
          onDelete: (expense) {
            context.read<ExpensesListBloc>().add(DeleteExpense(expense));
          },
        );
      },
    );
  }
}
