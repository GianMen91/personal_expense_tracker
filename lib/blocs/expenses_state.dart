import '../models/expense.dart';

class ExpensesState {
  final List<Expense> expense;
  final bool isLoading;

  ExpensesState({
    required this.expense,
    this.isLoading = false,
  });
}
