import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/expense_form/expense_form_bloc.dart';
import '../blocs/expense_form/expense_form_event.dart';
import '../blocs/expense_form/expense_form_state.dart';
import '../constants.dart';
import '../models/expense_category.dart';
import '../widgets/category_item.dart';

class NewExpenseScreen extends StatelessWidget {
  final ExpenseCategory category;

  const NewExpenseScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          title: const Text('New Expense',
              style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          children: [
            _buildAmountInput(context),
            const SizedBox(height: 15),
            _buildDescriptionInput(context),
            const SizedBox(height: 15),
            _buildDatePicker(context),
            const SizedBox(height: 15),
            CategoryItem(category: category),
            const SizedBox(height: 35),
            _buildSaveButton(state, context),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildSaveButton(ExpenseFormState state, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: state.isValid ? kButtonColor : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: state.isValid
          ? () {
              context.read<ExpenseFormBloc>().add(FormSubmitted(category));
              Navigator.pop(context);
              context
                  .read<ExpenseFormBloc>()
                  .add(ResetForm()); // Reset the form
            }
          : null,
      child: const Text(
        "SAVE",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: kBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("€", style: TextStyle(fontSize: 26, color: kButtonColor)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
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
              onChanged: (value) =>
                  context.read<ExpenseFormBloc>().add(CostChanged(value)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: kBoxDecoration,
      child: TextField(
        onChanged: (value) =>
            context.read<ExpenseFormBloc>().add(DescriptionChanged(value)),
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: state.date,
              firstDate: DateTime(2024),
              lastDate: DateTime(2026),
            );

            if (pickedDate != null) {
              context.read<ExpenseFormBloc>().add(DateChanged(pickedDate));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: kBoxDecoration,
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  DateFormat('dd/MM/yyyy').format(state.date),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
