import '../../models/expense.dart';

class ExpensesState {
  final List<Expense> expense;
  final bool isLoading;
  final String? errorMessage;
  final DateTime selectedDate;

  ExpensesState({
    required this.expense,
    this.isLoading = false,
    this.errorMessage,DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  ExpensesState copyWith({
    List<Expense>? expense,
    bool? isLoading,
    String? errorMessage
  , DateTime? selectedDate}) {

    return ExpensesState(
      expense: expense ?? this.expense,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
