class ExpenseValidationService {
  bool isValidExpense(String description, double cost) {
    return description.isNotEmpty && cost > 0;
  }
}
