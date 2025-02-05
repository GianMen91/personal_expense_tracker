import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expenses_event.dart';
import '../models/expense.dart';
import '../blocs/expenses_bloc.dart';

import 'package:intl/intl.dart';

import '../models/expense_category.dart';

class NewExpenseScreen extends StatefulWidget {
  final ExpenseCategory category;

  const NewExpenseScreen({
    super.key,
    required this.category,
  });

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context,
      {bool isReminder = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isReminder ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      // Show time picker after date is selected
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInputRow(
              icon: Icons.euro,
              child: TextField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Add Expense',
                  hintText: '0,00 €',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.category.color,
                child: Icon(widget.category.icon, color: Colors.white),
              ),
              title: Text(widget.category.title),
            ),
            const SizedBox(height: 24),
            _buildInputRow(
              icon: Icons.description,
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              icon: Icons.calendar_today,
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final expense = Expense(
                          category: widget.category.title,
                          description: _descriptionController.text,
                          cost: double.tryParse(_costController.text) ?? 0.0,
                          date: _selectedDate,
                        );
                        context.read<ExpensesBloc>().add(AddExpense(expense));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 16),
        Expanded(child: child),
      ],
    );
  }
}
