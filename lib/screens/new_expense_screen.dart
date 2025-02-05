import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/expenses_bloc.dart';
import '../blocs/expenses_event.dart';
import '../constants.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';

class NewExpenseScreen extends StatefulWidget {
  final ExpenseCategory category;

  const NewExpenseScreen({super.key, required this.category});

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          children: [
            // Expense Amount Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: _boxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("€",
                      style: TextStyle(fontSize: 26, color: kButtonColor)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _costController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: "0",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: _boxDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: widget.category.color,
                    child: Icon(widget.category.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.category.title,
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Note Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: _boxDecoration(),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Date Picker
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("SAVE",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? true) {
      final expense = Expense(
        category: widget.category.title,
        description: _descriptionController.text,
        cost: double.tryParse(_costController.text) ?? 0.0,
        date: _selectedDate,
      );
      context.read<ExpensesBloc>().add(AddExpense(expense));
      Navigator.pop(context);
    }
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
