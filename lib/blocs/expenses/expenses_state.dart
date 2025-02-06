import 'package:personal_expense_tracker/models/expense.dart';

class ExpensesState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;
  final DateTime selectedDate;

  ExpensesState({
    required this.expenses,
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = "ALL",
    required this.selectedDate,
  });

  ExpensesState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
    DateTime? selectedDate,
  }) {
    return ExpensesState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
