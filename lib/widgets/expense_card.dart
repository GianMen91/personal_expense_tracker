import 'package:flutter/material.dart';
import '../constants.dart'; // Import constants for theme colors
import '../models/expense.dart'; // Import Expense model
import '../models/expense_categories.dart'; // Import ExpenseCategories for category lookup
import 'category_avatar.dart'; // Import CategoryAvatar widget for category icons

// A card widget that displays expense details and allows deletion via swipe.
class ExpenseCard extends StatelessWidget {
  final Expense expense; // The expense data to display
  final void Function(Expense)
      onDelete; // Callback function when an expense is deleted

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Get the category details based on the expense's category title
    final category = ExpenseCategories.getCategoryByTitle(expense.category);

    return Dismissible(
      key: Key(expense.id.toString()),
      // Unique key to identify the dismissible widget
      direction: DismissDirection.endToStart,
      // Swipe left to delete
      onDismissed: (direction) => onDelete(expense),
      // Trigger deletion when dismissed
      confirmDismiss: (direction) async => await _showDeleteDialog(context),
      // Show confirmation dialog before deleting
      background: _buildDismissBackground(),
      // Background when swiping left

      // The expense card UI
      child: Card(
        elevation: 0,
        // No shadow effect
        color: Colors.white,
        // Card background color
        margin: const EdgeInsets.only(bottom: 12),
        // Add spacing between cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar representing the category
              CategoryAvatar(
                  category: category, key: const Key('category_avatar')),
              const SizedBox(width: 16),

              // Expense description and category title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Expense description
                    Text(
                      key: const Key('expense_description_text'),
                      expense.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Expense category title
                    Text(
                      key: const Key('expense_title_text'),
                      category.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Expense amount displayed in euros
              Text(
                key: const Key('expense_cost_text'),
                '${expense.cost.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kThemeColor, // Themed text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a confirmation dialog before deleting an expense
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              // Dialog title
              content: const Text('Do you want to delete this expense?'),
              // Dialog content
              actions: [
                // Cancel button, dismisses the dialog without deleting
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                // Delete button, confirms deletion
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

  // Builds the red background shown when swiping left
  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      // Aligns the delete icon to the right
      padding: const EdgeInsets.only(right: 16.0),
      // Adds padding for the delete icon
      decoration: BoxDecoration(
        color: Colors.red, // Background color for deletion
        borderRadius:
            BorderRadius.circular(12), // Matches the card's border radius
      ),
      child: const Icon(
        Icons.delete, // Trash icon
        color: Colors.white, // Icon color
      ),
    );
  }
}
