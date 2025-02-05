import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
        child: ListTile(
          title: Text(expense.description),
          subtitle: Text(expense.category),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.flight, color: Colors.white),
          ),
          trailing: Text('${expense.cost.toString()} €'),
        ));
  }
}
