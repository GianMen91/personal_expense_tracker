import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_state.dart';

import '../widgets/expense_card.dart';
import 'category_selection_screen.dart';
import 'expense_detail_screen.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Total Expenses: 200 €"),
          Expanded(
            child: BlocBuilder<ExpensesBloc, ExpensesState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: state.expense.length,
                  itemBuilder: (context, index) {
                    final expense = state.expense[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ExpenseDetailScreen(expense: expense)),
                        );
                      },
                      child: ExpenseCard(expense: expense),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
