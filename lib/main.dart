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
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ExpensesListBloc(DatabaseHelper.instance)..add(LoadExpense()),
        ),
        BlocProvider(
          create: (context) =>
              ExpensesStatBloc(),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => ExpenseFormBloc(
            validationService: ExpenseValidationService(),
            expensesBloc: context.read<ExpensesListBloc>(),
          ),
        ),
      ],
      child: const PersonalExpenseTrackerApp(),
    ),
  );
}
