import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses_event.dart';
import 'package:personal_expense_tracker/blocs/expenses_state.dart';

import '../repositories/database_helper.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final DatabaseHelper dbHelper;

  ExpensesBloc(this.dbHelper) : super(ExpensesState(expense: [])) {
    on<LoadExpense>((event, emit) async {
      emit(ExpensesState(expense: state.expense, isLoading: true));
      final expense = await dbHelper.getExpenses();
      emit(ExpensesState(expense: expense));
    });

    on<AddExpense>((event, emit) async {
      await dbHelper.addExpense(event.expense);
      final expense = await dbHelper.getExpenses();
      emit(ExpensesState(expense: expense));
    });

    on<DeleteExpense>((event, emit) async {
      await dbHelper.deleteExpense(event.expense.id!);
      final expense = await dbHelper.getExpenses();
      emit(ExpensesState(expense: expense));
    });

  }
}
