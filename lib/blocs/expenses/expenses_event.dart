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

class ChangeCategoryEvent extends ExpensesEvent {
  final String category;

  ChangeCategoryEvent(this.category);
}

class ChangeYearEvent extends ExpensesEvent {
  final int offset; // To increase or decrease the year

  ChangeYearEvent(this.offset);
}

class ChangeMonthEvent extends ExpensesEvent {
  final String month; // The name of the month (e.g., "Jan", "Feb", etc.)

  ChangeMonthEvent(this.month);
}
