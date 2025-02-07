import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/expense_data.dart';
import '../../repositories/database_helper.dart'; // Import your database helper

import '../../models/expense.dart';
import 'package:intl/intl.dart';

import 'expense_list_event.dart';
import 'expense_list_state.dart';

class ExpensesListBloc extends Bloc<ExpensesListEvent, ExpensesListState> {
  final DatabaseHelper dbHelper;

  ExpensesListBloc(this.dbHelper)
      : super(ExpensesListState(expenses: [], isLoading: true)) {
    on<LoadExpense>(_onLoadExpense);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpense(
      LoadExpense event, Emitter<ExpensesListState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final expenses = await dbHelper.getExpenses();
      emit(_updateStateWithDerivedData(
          state.copyWith(expenses: expenses, isLoading: false)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpensesListState> emit) async {
    try {
      await dbHelper.addExpense(event.expense);
      final expenses = await dbHelper.getExpenses();
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpense event, Emitter<ExpensesListState> emit) async {
    try {
      await dbHelper.deleteExpense(event.expense.id!);
      final expenses = await dbHelper.getExpenses();
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  ExpensesListState _updateStateWithDerivedData(
      ExpensesListState currentState) {
    final expenseData = _calculateExpenseData(currentState.expenses);
    return currentState.copyWith(
      groupedExpenses: expenseData.groupedExpenses,
      monthlyTotal: expenseData.monthlyTotal,
    );
  }

  ExpenseData _calculateExpenseData(List<Expense> expenses) {
    final groupedExpenses = _groupExpensesByDate(expenses);
    final monthlyTotal = _calculateMonthlyTotal(expenses);
    return ExpenseData(
        groupedExpenses: groupedExpenses,
        monthlyTotal: monthlyTotal,
        expenses: expenses);
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final groupedExpenses = <String, List<Expense>>{};
    for (var expense in expenses) {
      final dateStr = _formatDate(expense.date);
      groupedExpenses.putIfAbsent(dateStr, () => []).add(expense);
    }
    return Map.fromEntries(groupedExpenses.entries.toList()
      ..sort((a, b) => _parseDate(b.key).compareTo(_parseDate(a.key))));
  }

  DateTime _parseDate(String dateStr) {
    if (dateStr == 'Today') {
      return DateTime.now();
    }
    return DateFormat('dd MMM yyyy').parse(dateStr);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  double _calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((expense) =>
            expense.date.year == now.year && expense.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.cost);
  }
}
