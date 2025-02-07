abstract class ExpensesStatEvent {}

class ChangeCategoryEvent extends ExpensesStatEvent {
  final String category;

  ChangeCategoryEvent(this.category);
}

class ChangeYearEvent extends ExpensesStatEvent {
  final int offset;

  ChangeYearEvent(this.offset);
}

class ChangeMonthSelectionEvent extends ExpensesStatEvent {
  final String? month;

  ChangeMonthSelectionEvent(this.month);
}
