import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/new_expense_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.red,
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
            child: ListView(
              children: [
                _buildCategoryItem(
                  context,
                  icon: Icons.fastfood,
                  title: 'Food & Groceries',
                  color: Colors.red.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.directions_bus,
                  title: 'Transportation',
                  color: Colors.blue.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.movie,
                  title: 'Entertainment',
                  color: Colors.teal.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.shopping_bag,
                  title: 'Shopping',
                  color: Colors.blue.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.local_hospital,
                  title: 'Healthcare',
                  color: Colors.red.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Bills & Utilities',
                  color: Colors.green.shade200,
                ),
                _buildCategoryItem(
                  context,
                  icon: Icons.flight,
                  title: 'Travel',
                  color: Colors.teal.shade200,
                ),
              ],
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
                      backgroundColor: Colors.red,
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

  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewExpenseScreen(category: title),
          ),
        );
      },
    );
  }
}
