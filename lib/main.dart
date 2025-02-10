import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/personal_expense_tracker_app.dart';
import 'package:personal_expense_tracker/repositories/database_helper.dart';

import 'blocs/expense_form/expense_form_bloc.dart';
import 'blocs/expense_list/expense_list_bloc.dart';
import 'blocs/expense_list/expense_list_event.dart';
import 'blocs/expenses_stat/expenses_stat_bloc.dart';
import 'blocs/navigation/navigation_bloc.dart';
import 'models/expense_validation_service.dart';

void main() {
  runApp(
    // Using MultiBlocProvider to provide multiple BLoCs throughout the app
    MultiBlocProvider(
      providers: [
        // Bloc for managing the list of expenses
        BlocProvider(
          create: (context) =>
              ExpensesListBloc(DatabaseHelper.instance)..add(LoadExpense()),
          // Immediately dispatches LoadExpense event to fetch initial expenses
        ),

        // Bloc for handling statistical calculations and filtering for expenses
        BlocProvider(
          create: (context) => ExpensesStatBloc(),
        ),

        // Bloc for handling bottom navigation state management
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),

        // Bloc for managing expense form validation and submission
        BlocProvider(
          create: (context) => ExpenseFormBloc(
            validationService: ExpenseValidationService(),
            // Injects validation service
            expensesBloc: context
                .read<ExpensesListBloc>(), // Connects with ExpensesListBloc
          ),
        ),
      ],
      child: const PersonalExpenseTrackerApp(), // Main application widget
    ),
  );
}
