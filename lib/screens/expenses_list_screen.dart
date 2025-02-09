import 'package:flutter/material.dart'; // Import Material Design components
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter BLoC for state management

// Importing the necessary BLoC components and widgets
import '../blocs/expense_list/expense_list_bloc.dart';
import '../blocs/expense_list/expense_list_state.dart';
import '../widgets/expense_list.dart';
import '../widgets/total_expense_card.dart';

// The ExpensesListScreen displays a list of expenses and the total monthly expenses.
class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Set the background color of the screen
        backgroundColor: const Color(0xFFF5F5F5),
        body: BlocBuilder<ExpensesListBloc, ExpensesListState>(
          // BlocBuilder listens to the ExpensesListBloc and rebuilds UI on state changes
          builder: (context, state) {
            // If the state is still loading, display a progress indicator
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Once data is loaded, display the total expense and the list of expenses
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // The TotalExpenseCard widget displays the total expense for the current month
                  TotalExpenseCard(
                    key: const Key('total_expense_card'),
                    totalAmount: state.monthlyTotal,
                    // Pass the total expense amount
                    title:
                        'Total expense this month', // Set the title of the card
                  ),
                  // The ExpenseList widget displays the grouped expenses
                  Expanded(
                    child: ExpenseList(
                        groupedExpenses: state.groupedExpenses,
                        // Pass the grouped expenses
                        key: const Key(
                            'expense_list')), // Key for widget testing
                  ),
                ],
              ),
            );
          },
        ));
  }
}
