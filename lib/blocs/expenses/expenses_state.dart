import '../../models/expense.dart';

class ExpensesState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;
  final DateTime selectedDate;
  final String? selectedMonth;

  ExpensesState({
    required this.expenses,
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = "ALL",
    required this.selectedDate,
    this.selectedMonth,
  });

  ExpensesState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
    DateTime? selectedDate,
    String? selectedMonth,
  }) {
    return ExpensesState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMonth: selectedMonth,
    );
  }
}