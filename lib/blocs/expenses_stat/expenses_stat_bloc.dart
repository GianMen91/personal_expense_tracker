import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';
import 'expenses_stat_event.dart';
import 'expenses_stat_state.dart';

class ExpensesStatBloc extends Bloc<ExpensesStatEvent, ExpensesStatState> {
  ExpensesStatBloc()
      : super(ExpensesStatState(
            selectedDate: DateTime.now(), selectedCategory: "ALL")) {
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeYearEvent>(_onChangeYear);
    on<ChangeMonthSelectionEvent>(_onChangeMonthSelection);
  }

  void _onChangeCategory(
      ChangeCategoryEvent event, Emitter<ExpensesStatState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onChangeYear(ChangeYearEvent event, Emitter<ExpensesStatState> emit) {
    final newDate = DateTime(
        state.selectedDate.year + event.offset, state.selectedDate.month);
    emit(state.copyWith(selectedDate: newDate));
  }

  void _onChangeMonthSelection(
      ChangeMonthSelectionEvent event, Emitter<ExpensesStatState> emit) {
    emit(state.copyWith(selectedMonth: event.month));
  }

  List<Expense> getFilteredExpenses(
      List<Expense> expenses, ExpensesStatState state) {
    return expenses.where((expense) {
      final isSameYear = expense.date.year == state.selectedDate.year;
      final isSameMonth = state.selectedMonth == null ||
          DateFormat('MMM').format(expense.date) == state.selectedMonth;
      final isSameCategory = state.selectedCategory == "ALL" ||
          expense.category == state.selectedCategory;
      return isSameYear && isSameMonth && isSameCategory;
    }).toList();
  }

  double calculateTotalAmount(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.cost);
  }

  String? getHighestSpendingCategory(
      List<Expense> expenses, DateTime selectedDate, String? selectedMonth) {
    final filteredExpenses = expenses.where((expense) {
      final isSameYear = expense.date.year == selectedDate.year;
      final isSameMonth = selectedMonth == null ||
          DateFormat('MMM').format(expense.date) == selectedMonth;
      return isSameYear && isSameMonth;
    }).toList();

    if (filteredExpenses.isEmpty) return null;

    final categoryTotals = <String, double>{};
    for (final expense in filteredExpenses) {
      categoryTotals.update(
        expense.category,
        (existingTotal) => existingTotal + expense.cost,
        ifAbsent: () => expense.cost,
      );
    }

    double highestTotal = 0;
    List<String> highestCategories = [];

    categoryTotals.forEach((category, total) {
      if (total > highestTotal) {
        highestTotal = total;
        highestCategories = [category];
      } else if (total == highestTotal) {
        highestCategories.add(category);
      }
    });

    return highestCategories.isNotEmpty ? highestCategories.join(', ') : null;
  }

  List<MapEntry<String, double>> getMonthlyData(
      List<Expense> expenses, DateTime selectedDate) {
    final Map<String, double> monthlyData = {
      for (var i = 1; i <= 12; i++)
        DateFormat('MMM').format(DateTime(selectedDate.year, i)): 0.0
    };

    for (var expense in expenses) {
      if (expense.date.year == selectedDate.year) {
        final month = DateFormat('MMM').format(expense.date);
        monthlyData[month] = monthlyData[month]! + expense.cost;
      }
    }

    return monthlyData.entries.toList();
  }
}
