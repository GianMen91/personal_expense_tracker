import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/expense_data.dart'; // Importing the expense data model
import '../../repositories/database_helper.dart'; // Importing the database helper to interact with the database

import '../../models/expense.dart'; // Importing the Expense model
import 'package:intl/intl.dart'; // Importing package for date formatting

import 'expense_list_event.dart'; // Importing the events related to the expense list
import 'expense_list_state.dart'; // Importing the state of the expense list

// ExpensesListBloc handles the loading, adding, and deleting of expenses in the expense list.
class ExpensesListBloc extends Bloc<ExpensesListEvent, ExpensesListState> {
  final DatabaseHelper
      dbHelper; // Database helper for performing operations on the database

  // Constructor initializes the BLoC and sets up event handlers.
  ExpensesListBloc(this.dbHelper)
      : super(ExpensesListState(expenses: [], isLoading: true)) {
    // Mapping events to their corresponding handlers.
    on<LoadExpense>(_onLoadExpense);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  // Handler for loading expenses from the database.
  Future<void> _onLoadExpense(
      LoadExpense event, Emitter<ExpensesListState> emit) async {
    emit(state.copyWith(
        isLoading: true)); // Set loading state to true before fetching data
    try {
      final expenses =
          await dbHelper.getExpenses(); // Fetch expenses from the database
      // Update state with expenses and set loading to false.
      emit(_updateStateWithDerivedData(
          state.copyWith(expenses: expenses, isLoading: false)));
    } on Exception catch (e) {
      // If an error occurs, update the state with the error message.
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // Handler for adding a new expense to the database.
  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpensesListState> emit) async {
    try {
      await dbHelper
          .addExpense(event.expense); // Add the expense to the database
      final expenses =
          await dbHelper.getExpenses(); // Fetch updated list of expenses
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } on Exception catch (e) {
      // If an error occurs, update the state with the error message.
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // Handler for deleting an expense from the database.
  Future<void> _onDeleteExpense(
      DeleteExpense event, Emitter<ExpensesListState> emit) async {
    try {
      await dbHelper.deleteExpense(
          event.expense.id!); // Delete the expense from the database
      final expenses =
          await dbHelper.getExpenses(); // Fetch updated list of expenses
      emit(_updateStateWithDerivedData(state.copyWith(expenses: expenses)));
    } on Exception catch (e) {
      // If an error occurs, update the state with the error message.
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // Updates the state with additional derived data like grouped expenses and monthly total.
  ExpensesListState _updateStateWithDerivedData(
      ExpensesListState currentState) {
    final expenseData = _calculateExpenseData(currentState.expenses);
    return currentState.copyWith(
      groupedExpenses: expenseData.groupedExpenses,
      monthlyTotal: expenseData.monthlyTotal,
    );
  }

  // Calculates grouped expenses and monthly total from the list of expenses.
  ExpenseData _calculateExpenseData(List<Expense> expenses) {
    final groupedExpenses =
        _groupExpensesByDate(expenses); // Group expenses by date
    final monthlyTotal = _calculateMonthlyTotal(
        expenses); // Calculate total cost for the current month
    return ExpenseData(
        groupedExpenses: groupedExpenses,
        monthlyTotal: monthlyTotal,
        expenses: expenses);
  }

  // Groups expenses by date, with the format 'Today', 'dd MMM yyyy', etc.
  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final groupedExpenses = <String, List<Expense>>{};

    for (var expense in expenses) {
      final dateStr = _formatDate(expense.date); // Format the date as a string
      groupedExpenses.putIfAbsent(dateStr, () => []).add(expense);
    }

    // Sort each group (same-day expenses) from most recent to oldest
    groupedExpenses.forEach((key, list) {
      list.sort((a, b) =>
          b.date.compareTo(a.date)); // Sort expenses within the same day
    });

    // Sort grouped expenses by date, from most recent to oldest.
    return Map.fromEntries(groupedExpenses.entries.toList()
      ..sort((a, b) => _parseDate(b.key).compareTo(_parseDate(a.key))));
  }

  // Parses a date string to a DateTime object for sorting and comparison.
  DateTime _parseDate(String dateStr) {
    if (dateStr == 'Today') {
      return DateTime.now(); // If the date is 'Today', return current date.
    }
    return DateFormat('dd MMM yyyy')
        .parse(dateStr); // Parse the date string into a DateTime object.
  }

  // Formats a DateTime object into a string with the format 'Today' or 'dd MMM yyyy'.
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today'; // Return 'Today' if the date is today's date
    }
    return DateFormat('dd MMM yyyy')
        .format(date); // Otherwise, return the formatted date.
  }

  // Calculates the total expenses for the current month.
  double _calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((expense) =>
            expense.date.year == now.year &&
            expense.date.month == now.month) // Filter by current month and year
        .fold(
            0,
            (sum, expense) =>
                sum + expense.cost); // Calculate the sum of the expenses.
  }
}
