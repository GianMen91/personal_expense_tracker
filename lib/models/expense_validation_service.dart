// ExpenseValidationService is responsible for validating expenses.
class ExpenseValidationService {
  // isValidExpense checks whether an expense is valid based on its description and cost.
  // Returns true if the description is not empty and the cost is greater than 0.
  bool isValidExpense(String description, double cost) {
    return description.isNotEmpty &&
        cost > 0; // Valid if description is not empty and cost is positive
  }
}
