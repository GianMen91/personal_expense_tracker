import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'expense_card_list.dart';

class ExpenseList extends StatelessWidget {
  final Map<String, List<Expense>> groupedExpenses;

  const ExpenseList({super.key, required this.groupedExpenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final date = groupedExpenses.keys.elementAt(index);
        final expenses = groupedExpenses[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(date, key: const Key('expenseDate'),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600])),
            ),
            ExpenseCardsList(expenses: expenses, key: const Key('expenseCardList'),), // Use the common function
          ],
        );
      },
    );
  }
}

