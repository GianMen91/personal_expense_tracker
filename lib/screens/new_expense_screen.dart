import 'package:flutter/material.dart'; // Import Material Design components
import 'package:flutter/services.dart'; // Import for input formatting
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter BLoC for state management
import 'package:intl/intl.dart'; // Import for date formatting

// Importing BLoC components and other required files
import '../blocs/expense_form/expense_form_bloc.dart';
import '../blocs/expense_form/expense_form_event.dart';
import '../blocs/expense_form/expense_form_state.dart';
import '../constants.dart';
import '../models/expense_category.dart';
import '../widgets/category_item.dart';
import '../widgets/input_field.dart';

// NewExpenseScreen is a form for adding a new expense.
class NewExpenseScreen extends StatelessWidget {
  final ExpenseCategory category; // The category passed to this screen

  const NewExpenseScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
        // BlocBuilder listens to the state of ExpenseFormBloc and rebuilds the UI on state change
        builder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        // Set the background color of the screen
        appBar: AppBar(
          key: const Key('new_expense_app_bar'),
          backgroundColor: const Color(0xFFF5F5F5),
          title: const Text(
            'New Expense', // Title of the screen
            key: Key('new_expense_title_text'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            key: const Key('back_button'),
            icon: const Icon(Icons.arrow_back), // Back button
            onPressed: () =>
                Navigator.pop(context), // Navigate back to the previous screen
          ),
        ),
        body: ListView(
          key: const Key('new_expense_list_view'),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          children: [
            // Input fields for amount, description, date, category, and save button
            _buildAmountInput(context),
            const SizedBox(height: 15),
            _buildDescriptionInput(context),
            const SizedBox(height: 15),
            _buildDatePicker(context),
            const SizedBox(height: 15),
            CategoryItem(category: category),
            // Display the selected category
            const SizedBox(height: 35),
            _buildSaveButton(state, context),
            // The save button
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // Builds the Save button, enabled if the form is valid
  Widget _buildSaveButton(ExpenseFormState state, BuildContext context) {
    return ElevatedButton(
      key: const Key('save_button'),
      style: ElevatedButton.styleFrom(
        backgroundColor: state.isValid ? kButtonColor : Colors.grey,
        // Button color based on form validity
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for the button
        ),
      ),
      onPressed: state.isValid
          ? () {
              // If the form is valid, submit the form and reset it
              context.read<ExpenseFormBloc>().add(FormSubmitted(category));
              Navigator.pop(context); // Close the screen
              context
                  .read<ExpenseFormBloc>()
                  .add(ResetForm()); // Reset the form
            }
          : null, // Disable the button if the form is invalid
      child: const Text(
        "SAVE",
        key: Key('save_button_text'),
        style:
            TextStyle(fontSize: 18, color: Colors.white), // Button text style
      ),
    );
  }

  // Builds the amount input field with proper formatting
  Widget _buildAmountInput(BuildContext context) {
    return InputField(
      key: const Key('amount_input_field'),
      child: Row(
        children: [
          const Text(
            "€", // Currency symbol
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
              // Decimal input for amount
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*'))
                // Input formatter for numbers
              ],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "0", // Placeholder text
                border: InputBorder.none,
              ),
              onChanged: (value) => context.read<ExpenseFormBloc>().add(
                  CostChanged(value)), // Trigger BLoC event on value change
            ),
          ),
        ],
      ),
    );
  }

  // Builds the description input field
  Widget _buildDescriptionInput(BuildContext context) {
    return InputField(
      key: const Key('description_input_field'),
      child: TextField(
        key: const Key('description_text_field'),
        onChanged: (value) =>
            context.read<ExpenseFormBloc>().add(DescriptionChanged(value)),
        // Trigger BLoC event on value change
        decoration: const InputDecoration(
          hintText: "Description", // Placeholder text
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Builds the date picker input field
  Widget _buildDatePicker(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
      builder: (context, state) {
        return InputField(
          key: const Key('date_picker_input_field'),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: state.date, // Default to current selected date
              firstDate: DateTime(2024),
              lastDate: DateTime(2026),
            );

            if (pickedDate != null) {
              // If a date is selected, update the form state with the new date
              context.read<ExpenseFormBloc>().add(DateChanged(pickedDate));
            }
          },
          child: Row(
            key: const Key('date_picker_row'),
            children: [
              const Icon(
                Icons.calendar_today,
                key: Key('date_picker_icon'),
                color: Colors.grey, // Calendar icon for the date picker
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('dd/MM/yyyy').format(state.date),
                // Display selected date
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
