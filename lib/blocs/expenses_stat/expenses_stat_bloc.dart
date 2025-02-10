import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../models/expense.dart'; // Importing the Expense model
import 'expenses_stat_event.dart'; // Importing the events related to expenses statistics
import 'expenses_stat_state.dart'; // Importing the state for expenses statistics

// ExpensesStatBloc handles the logic for filtering and calculating expense statistics.
class ExpensesStatBloc extends Bloc<ExpensesStatEvent, ExpensesStatState> {
  // Constructor initializes the BLoC with the current date as the default selected date.
  ExpensesStatBloc() : super(ExpensesStatState(selectedDate: DateTime.now())) {
    // Mapping events to their corresponding handlers.
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeYearEvent>(_onChangeYear);
    on<ChangeMonthSelectionEvent>(_onChangeMonthSelection);
  }

  // Handler for when the category is changed in the statistics view.
  void _onChangeCategory(
      ChangeCategoryEvent event, Emitter<ExpensesStatState> emit) {
    // Update the state with the selected category and keep the selected month as is.
    emit(state.copyWith(
        selectedCategory: event.category, selectedMonth: state.selectedMonth));
  }

  // Handler for when the year is changed (by offset) in the statistics view.
  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesStatState> emit) {
    // Calculate the new date based on the offset, changing only the year.
    final newDate = DateTime(
        state.selectedDate.year + event.offset, state.selectedDate.month);
    // Update the state with the new year and the same month.
    emit(state.copyWith(selectedDate: newDate));
  }

  // Handler for when the month selection is changed.
  void _onChangeMonthSelection(
      ChangeMonthSelectionEvent event, Emitter<ExpensesStatState> emit) {
    // Update the state with the newly selected month.
    emit(state.copyWith(selectedMonth: event.month));
  }

  // Filters the expenses based on the selected year, month, and category.
  List<Expense> getFilteredExpenses(
      List<Expense> expenses, ExpensesStatState state) {
    final filteredExpenses = expenses.where((expense) {
      final isSameYear =
          expense.date.year == state.selectedDate.year; // Match year
      final isSameMonth = state.selectedMonth == null ||
          DateFormat('MMM').format(expense.date) ==
              state.selectedMonth; // Match month
      final isSameCategory = state.selectedCategory == "ALL" ||
          expense.category == state.selectedCategory; // Match category
      return isSameYear && isSameMonth && isSameCategory;
    }).toList();

    // Sort the filtered expenses by date in descending order (most recent first).
    final sortedExpenses = List<Expense>.from(filteredExpenses);
    sortedExpenses.sort((a, b) => b.date.compareTo(a.date));

    return sortedExpenses;
  }

  // Calculates the total cost of the expenses.
  double calculateTotalAmount(List<Expense> expenses) {
    // Sum all expenses using fold.
    return expenses.fold(0, (sum, expense) => sum + expense.cost);
  }

  // Retrieves the category with the highest spending for the selected month and year.
  String? getHighestSpendingCategory(
      List<Expense> expenses, DateTime selectedDate, String? selectedMonth) {
    final filteredExpenses = expenses.where((expense) {
      final isSameYear = expense.date.year == selectedDate.year; // Match year
      final isSameMonth = selectedMonth == null ||
          DateFormat('MMM').format(expense.date) ==
              selectedMonth; // Match month
      return isSameYear && isSameMonth;
    }).toList();

    // If no expenses match, return null.
    if (filteredExpenses.isEmpty) return null;

    final categoryTotals = <String, double>{};
    // Calculate the total spending for each category.
    for (final expense in filteredExpenses) {
      categoryTotals.update(
        expense.category,
        (existingTotal) => existingTotal + expense.cost,
        ifAbsent: () => expense.cost,
      );
    }

    double highestTotal = 0;
    List<String> highestCategories = [];

    // Find the category with the highest spending.
    categoryTotals.forEach((category, total) {
      if (total > highestTotal) {
        highestTotal = total;
        highestCategories = [category];
      } else if (total == highestTotal) {
        highestCategories
            .add(category); // In case of a tie, add all matching categories
      }
    });

    // Return the category or categories with the highest total.
    return highestCategories.isNotEmpty ? highestCategories.join(', ') : null;
  }

  // Calculates the total amount spent per month for the selected year.
  List<MapEntry<String, double>> getMonthlyData(
      List<Expense> expenses, DateTime selectedDate) {
    // Initialize a map with months as keys and 0 as the initial value.
    final Map<String, double> monthlyData = {
      for (var i = 1; i <= 12; i++)
        DateFormat('MMM').format(DateTime(selectedDate.year, i)): 0.0
    };

    // Calculate the total spending per month.
    for (var expense in expenses) {
      if (expense.date.year == selectedDate.year) {
        // Match the selected year
        final month = DateFormat('MMM').format(expense.date);
        monthlyData[month] = monthlyData[month]! + expense.cost;
      }
    }

    // Return the monthly data sorted by month.
    return monthlyData.entries.toList();
  }
}
