import '../../models/expense.dart';

class ExpensesListState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, List<Expense>> groupedExpenses;
  final double monthlyTotal;

  ExpensesListState({
    required this.expenses,
    this.isLoading = false,
    this.errorMessage,
    this.groupedExpenses = const {},
    this.monthlyTotal = 0.0,
  });

  ExpensesListState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? errorMessage,
    Map<String, List<Expense>>? groupedExpenses,
    double? monthlyTotal,
  }) {
    return ExpensesListState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      groupedExpenses: groupedExpenses ?? this.groupedExpenses,
      monthlyTotal: monthlyTotal ?? this.monthlyTotal,
    );
  }
}