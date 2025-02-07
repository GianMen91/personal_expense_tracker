import '../../models/expense.dart';

abstract class ExpensesListEvent {}
class LoadExpense extends ExpensesListEvent {}
class AddExpense extends ExpensesListEvent {
  final Expense expense;
  AddExpense(this.expense);
}
class DeleteExpense extends ExpensesListEvent {
  final Expense expense;
  DeleteExpense(this.expense);
}