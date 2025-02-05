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

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onFormFieldChanged);
    _costController.addListener(_onFormFieldChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onFormFieldChanged);
    _costController.removeListener(_onFormFieldChanged);
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _onFormFieldChanged() {
    setState(() {});
  }

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

  bool get _isFormValid {
    if (_costController.text == null || _costController.text.trim().isEmpty) {
      return false;
    }
    if (double.tryParse(_costController.text) == null) {
      return false;
    }
    if (_descriptionController.text == null ||
        _descriptionController.text.trim().isEmpty) {
      return false;
    }
    return true;
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
            _buildAmountInput(),
            const SizedBox(height: 15),

            // Description Input
            _buildDescriptionInput(),
            const SizedBox(height: 15),

            // Date Picker
            _buildDatePicker(),
            const SizedBox(height: 15),

            // Category Card
            _buildCategoryCard(),
            const SizedBox(height: 35),

            const Spacer(),

            // Save Button
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("€", style: TextStyle(fontSize: 26, color: kButtonColor)),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _costController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "0",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a cost';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: widget.category.color,
            child: Icon(widget.category.icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(widget.category.title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid ? _saveExpense : null,
        // Disable button if form is not valid
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? kButtonColor : Colors.grey,
          // Active or grey color
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "SAVE",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_isFormValid) {
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
