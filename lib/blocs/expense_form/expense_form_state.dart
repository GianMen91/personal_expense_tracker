class ExpenseFormState {
  final String description;
  final String cost;
  final DateTime date;
  final bool isValid;

  ExpenseFormState({
    this.description = '',
    this.cost = '',
    DateTime? date,
    this.isValid = false,
  }) : date = date ?? DateTime.now();

  ExpenseFormState copyWith({
    String? description,
    String? cost,
    DateTime? date,
    bool? isValid,
  }) {
    return ExpenseFormState(
      description: description ?? this.description,
      cost: cost ?? this.cost,
      date: date ?? this.date,
      isValid: isValid ?? this.isValid,
    );
  }
}