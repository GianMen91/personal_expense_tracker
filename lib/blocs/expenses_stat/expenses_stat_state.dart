import '../../models/expense.dart';

class ExpensesStatState {
  final String selectedCategory;
  final DateTime selectedDate;
  final String? selectedMonth;

  ExpensesStatState({
    this.selectedCategory = "ALL",
    required this.selectedDate,
    this.selectedMonth,
  });

  ExpensesStatState copyWith({
    String? selectedCategory,
    DateTime? selectedDate,
    String? selectedMonth,
  }) {
    return ExpensesStatState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMonth: selectedMonth,
    );
  }
}
