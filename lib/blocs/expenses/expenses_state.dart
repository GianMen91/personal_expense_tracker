import '../../models/expense.dart';

class ExpensesState {
  final List<Expense> expense;
  final bool isLoading;
  final String? errorMessage;

  ExpensesState({
    required this.expense,
    this.isLoading = false,
    this.errorMessage,
  });

  ExpensesState copyWith({
    List<Expense>? expense,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExpensesState(
      expense: expense ?? this.expense,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
