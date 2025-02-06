import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/personal_expense_tracker_app.dart';
import 'package:personal_expense_tracker/repositories/database_helper.dart';

import 'blocs/expenses/expenses_bloc.dart';
import 'blocs/expenses/expenses_event.dart';
import 'blocs/navigation/navigation_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          ExpensesBloc(DatabaseHelper.instance)..add(LoadExpense()),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: const PersonalExpenseTrackerApp(),
    ),
  );
}
