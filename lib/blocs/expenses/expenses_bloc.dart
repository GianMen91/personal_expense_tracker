import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../../repositories/database_helper.dart'; // Import your database helper
import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final DatabaseHelper dbHelper; // Add your database helper

  ExpensesBloc(this.dbHelper) : super(ExpensesState(expenses: [], selectedDate: DateTime.now())) {
    on<LoadExpense>(_onLoadExpense);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeYearEvent>(_onChangeYear);
    on<ChangeMonthSelectionEvent>(_onChangeMonthSelection);
  }

  Future<void> _onLoadExpense(LoadExpense event, Emitter<ExpensesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.addExpense(event.expense);
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteExpense(DeleteExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.deleteExpense(event.expense.id!);
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onChangeCategory(ChangeCategoryEvent event, Emitter<ExpensesState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesState> emit) {
    final newDate = DateTime(state.selectedDate.year + event.offset, state.selectedDate.month);
    emit(state.copyWith(selectedDate: newDate));
  }

  void _onChangeMonthSelection(ChangeMonthSelectionEvent event, Emitter<ExpensesState> emit) {
    emit(state.copyWith(selectedMonth: event.month));
  }
}