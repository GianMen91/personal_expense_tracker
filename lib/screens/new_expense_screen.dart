import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/expenses/expenses_bloc.dart';
import '../blocs/expenses/expenses_event.dart';
import '../constants.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';

class NewExpenseScreen extends StatelessWidget {
  final ExpenseCategory category;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier(DateTime.now());
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);

  NewExpenseScreen({super.key, required this.category}) {
    // Add listeners to update form validity
    _descriptionController.addListener(_updateFormValidity);
    _costController.addListener(_updateFormValidity);
  }

  void _updateFormValidity() {
    final isValid = _checkFormValidity();
    _isFormValidNotifier.value = isValid;
  }

  bool _checkFormValidity() {
    if (_costController.text.trim().isEmpty) return false;
    final number = double.tryParse(_costController.text.replaceAll(',', '.'));
    if (number == null || number <= 0) return false;
    if (_descriptionController.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      _selectedDateNotifier.value = picked;
    }
  }

  bool get _isFormValid {
    if (_costController.text.trim().isEmpty) return false;
    final number = double.tryParse(_costController.text.replaceAll(',', '.'));
    if (number == null || number <= 0) return false;
    if (_descriptionController.text.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text('New Expense'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        children: [
          _buildAmountInput(),
          const SizedBox(height: 15),
          _buildDescriptionInput(),
          const SizedBox(height: 15),
          _buildDatePicker(context),
          const SizedBox(height: 15),
          _buildCategoryCard(),
          const SizedBox(height: 35),
          const Spacer(),
          _buildSaveButton(context),
          const SizedBox(height: 20),
        ],
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
            child: TextField(
              controller: _costController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*'))
              ],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "0",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 10),
            ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDateNotifier,
              builder: (context, selectedDate, child) {
                return Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
          ],
        ),
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
            backgroundColor: category.color,
            child: Icon(category.icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(category.title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isFormValidNotifier,
        builder: (context, isValid, child) {
          return ElevatedButton(
            onPressed: isValid ? () => _saveExpense(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid ? kButtonColor : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void _saveExpense(BuildContext context) {
    if (_isFormValid) {
      final expense = Expense(
        category: category.title,
        description: _descriptionController.text,
        cost: double.tryParse(_costController.text.replaceAll(',', '.')) ?? 0.0,
        date: _selectedDateNotifier.value,
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
