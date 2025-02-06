import '../../models/expense.dart';

abstract class ExpensesEvent {}

class LoadExpense extends ExpensesEvent {}

class AddExpense extends ExpensesEvent {
  final Expense expense;

  AddExpense(this.expense);
}

class DeleteExpense extends ExpensesEvent {
  final Expense expense;

  DeleteExpense(this.expense);
}

class SelectDate extends ExpensesEvent {
  final DateTime selectedDate;
  SelectDate(this.selectedDate);
}

