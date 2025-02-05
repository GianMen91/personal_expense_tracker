import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/screens/new_expense_screen.dart';
import '../constants.dart';
import '../models/expense_category.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
        backgroundColor: kThemeColor,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: kThemeColor,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'SELECT CATEGORY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ExpenseCategories.categories.length,
              itemBuilder: (context, index) {
                final category = ExpenseCategories.categories[index];
                return _buildCategoryItem(context, category);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kThemeColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('CANCEL'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, ExpenseCategory category) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: category.color,
        child: Icon(category.icon, color: Colors.white),
      ),
      title: Text(category.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewExpenseScreen(category: category.title),
          ),
        );
      },
    );
  }
}