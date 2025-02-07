import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_list/expense_list_bloc.dart';
import '../blocs/expense_list/expense_list_state.dart';

import '../widgets/expense_list.dart';
import '../widgets/monthly_total_expense_card.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: BlocBuilder<ExpensesListBloc, ExpensesListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  MonthlyTotalExpenseCard(monthlyTotal: state.monthlyTotal),
                  Expanded(
                    child: ExpenseList(groupedExpenses: state.groupedExpenses),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
