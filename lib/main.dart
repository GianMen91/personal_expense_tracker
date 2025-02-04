import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/expenses_event.dart';
import 'package:personal_expense_tracker/personal_expense_tracker_app.dart';

import 'databse_helper.dart';
import 'expenses_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) =>
          ExpensesBloc(DatabaseHelper.instance)..add(LoadExpense()),
      child: const PersonalExpenseTrackerApp(),
    ),
  );
}
