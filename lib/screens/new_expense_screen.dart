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
import '../widgets/input_field.dart';

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
          key: const Key('new_expense_app_bar'),
          backgroundColor: const Color(0xFFF5F5F5),
          title: const Text(
            'New Expense',
            key: Key('new_expense_title_text'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            key: const Key('back_button'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          key: const Key('new_expense_list_view'),
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
      key: const Key('save_button'),
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
        key: Key('save_button_text'),
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    return InputField(
      key: const Key('amount_input_field'),
      child: Row(
        children: [
          const Text(
            "€",
            key: Key('amount_currency_symbol'),
            style: TextStyle(fontSize: 26, color: kButtonColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: const Key('amount_text_field'),
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
    return InputField(
      key: const Key('description_input_field'),
      child: TextField(
        key: const Key('description_text_field'),
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
        return InputField(
          key: const Key('date_picker_input_field'),
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
          child: Row(
            key: const Key('date_picker_row'),
            children: [
              const Icon(
                Icons.calendar_today,
                key: Key('date_picker_icon'),
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('dd/MM/yyyy').format(state.date),
                key: const Key('selected_date_text'),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
