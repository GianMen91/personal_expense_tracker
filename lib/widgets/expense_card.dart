import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/expense.dart';
import '../models/expense_categories.dart';
import 'category_avatar.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Function onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = ExpenseCategories.getCategoryByTitle(expense.category);

    return Dismissible(
      key: Key(expense.id.toString()),
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) => onDelete(), // Call onDelete function when dismissed
      confirmDismiss: (direction) async => await _showDeleteDialog(context),
      background: _buildDismissBackground(),
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CategoryAvatar(category: category, key: const Key('categoryAvatar'),),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      key: const Key('expenseDescription'),
                      expense.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      key: const Key('expenseTitle'),
                      category.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                key: const Key('expenseCost'),
                '${expense.cost.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kThemeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ??
        false; // If the user cancels, return false
  }


  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12), // Match the card's border radius
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}

