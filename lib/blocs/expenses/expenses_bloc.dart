import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/database_helper.dart'; // Import your database helper
import 'expenses_event.dart';
import 'expenses_state.dart';
import '../../models/expense.dart';
import 'package:intl/intl.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final DatabaseHelper dbHelper;

  ExpensesBloc(this.dbHelper)
      : super(ExpensesState(
    expenses: [],
    selectedDate: DateTime.now(),
    groupedExpenses: {},
    monthlyTotal: 0.0,
  )) {
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
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses, isLoading: false)));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.addExpense(event.expense);
      final expenses = await dbHelper.getExpenses();
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteExpense(DeleteExpense event, Emitter<ExpensesState> emit) async {
    try {
      await dbHelper.deleteExpense(event.expense.id!);
      final expenses = await dbHelper.getExpenses();
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onChangeCategory(ChangeCategoryEvent event, Emitter<ExpensesState> emit) {
    emit(_updateStateWithDerivedData(state.copyWith(selectedCategory: event.category)));
  }

  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesState> emit) {
    final newDate = DateTime(state.selectedDate.year + event.offset, state.selectedDate.month);
    emit(_updateStateWithDerivedData(state.copyWith(selectedDate: newDate)));
  }

  void _onChangeMonthSelection(ChangeMonthSelectionEvent event, Emitter<ExpensesState> emit) {
    emit(_updateStateWithDerivedData(state.copyWith(selectedMonth: event.month)));
  }

  /// Helper to compute derived data
  ExpensesState _updateStateWithDerivedData(ExpensesState currentState) {
    final groupedExpenses = _groupExpensesByDate(currentState.expenses);
    final monthlyTotal = _calculateMonthlyTotal(currentState.expenses);
    return currentState.copyWith(groupedExpenses: groupedExpenses, monthlyTotal: monthlyTotal);
  }

  /// Groups expenses by date
  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final groupedExpenses = <String, List<Expense>>{};

    for (var expense in expenses) {
      final dateStr = _formatDate(expense.date);
      if (!groupedExpenses.containsKey(dateStr)) {
        groupedExpenses[dateStr] = [];
      }
      groupedExpenses[dateStr]!.add(expense);
    }

    return Map.fromEntries(groupedExpenses.entries.toList()
      ..sort((a, b) => _parseDate(b.key).compareTo(_parseDate(a.key))));
  }

  /// Parses a formatted date string
  DateTime _parseDate(String dateStr) {
    if (dateStr == 'Today') {
      return DateTime.now();
    }
    return DateFormat('dd MMM yyyy').parse(dateStr);
  }

  /// Formats a date as a readable string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Calculates total expenses for the current month
  double _calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((expense) => expense.date.year == now.year && expense.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.cost);
  }
}
