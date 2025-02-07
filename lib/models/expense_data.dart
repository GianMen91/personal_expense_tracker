import 'expense.dart';

class ExpenseData {
  final Map<String, List<Expense>> groupedExpenses;
  final double monthlyTotal;
  final List<Expense> expenses;

  ExpenseData({required this.groupedExpenses, required this.monthlyTotal, required this.expenses});
}