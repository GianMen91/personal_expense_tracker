import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_event.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_state.dart';
import '../../repositories/database_helper.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final DatabaseHelper dbHelper;

  ExpensesBloc(this.dbHelper) : super(ExpensesState(expense: [])) {
    on<LoadExpense>(_onLoadExpense);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpense(
      LoadExpense event, Emitter<ExpensesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final expense = await dbHelper.getExpenses();
      emit(state.copyWith(expense: expense, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.addExpense(event.expense);
      final expense = await dbHelper.getExpenses();
      emit(state.copyWith(expense: expense));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.deleteExpense(event.expense.id!);
      final expense = await dbHelper.getExpenses();
      emit(state.copyWith(expense: expense));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }


}
