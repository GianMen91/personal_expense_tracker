import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_event.dart';
import 'package:personal_expense_tracker/blocs/expenses/expenses_state.dart';
import '../../repositories/database_helper.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final DatabaseHelper dbHelper;

  ExpensesBloc(this.dbHelper) : super(ExpensesState(expenses: [], selectedDate: DateTime.now())) {
    on<LoadExpense>(_onLoadExpense);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeYearEvent>(_onChangeYear);
    on<ChangeMonthEvent>(_onChangeMonth);
  }

  Future<void> _onLoadExpense(LoadExpense event, Emitter<ExpensesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses, isLoading: false));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.addExpense(event.expense);
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteExpense(DeleteExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.deleteExpense(event.expense.id!);
      final expenses = await dbHelper.getExpenses();
      emit(state.copyWith(expenses: expenses));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // Event to change category
  void _onChangeCategory(ChangeCategoryEvent event, Emitter<ExpensesState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  // Event to change the year
  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesState> emit) {
    final newDate = DateTime(state.selectedDate.year + event.offset, state.selectedDate.month);
    emit(state.copyWith(selectedDate: newDate));
  }

  // Event to change the selected month
  void _onChangeMonth(ChangeMonthEvent event, Emitter<ExpensesState> emit) {
    final newDate = DateTime(state.selectedDate.year, DateFormat('MMM').parse(event.month).month);
    emit(state.copyWith(selectedDate: newDate));
  }
}
