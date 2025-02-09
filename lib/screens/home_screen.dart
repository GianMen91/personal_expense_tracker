import 'package:flutter/material.dart'; // Import Material Design components
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter BLoC for state management
import 'package:personal_expense_tracker/constants.dart'; // Import constants like colors
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart'; // Import the expenses list screen
import 'package:personal_expense_tracker/screens/statistic_screen.dart'; // Import the statistics screen
import 'package:personal_expense_tracker/widgets/select_category_dialog.dart'; // Import the category selection dialog

// Importing BLoC components for navigation
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';
import '../widgets/bottom_menu.dart'; // Import bottom navigation menu widget

// HomeScreen is the main screen of the app with navigation and expense adding functionality.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController _myPage = PageController(); // Controller for handling page navigation

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      // BlocBuilder listens to NavigationBloc state changes and rebuilds UI accordingly
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              key: Key('home_title_app_bar'),
              'Personal Expense Tracker', // App title
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF5F5F5), // Set background color
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            key: const Key('add_expense_button'),
            backgroundColor: kButtonColor, // Set button color
            shape: const CircleBorder(), // Circular shape
            onPressed: () async {
              await _showMyDialog(context); // Show the category selection dialog when clicked
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28), // Add icon
          ),
          bottomNavigationBar: BottomMenu(
            myPage: _myPage,
            currentIndex: state.currentPage,
            key: const Key('bottom_menu'),
          ),
          body: PageView(
            controller: _myPage, // Control navigation between pages
            onPageChanged: (int index) {
              context.read<NavigationBloc>().add(ChangePage(index)); // Change page via BLoC
            },
            physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
            children: <Widget>[
              ExpensesListScreen(key: const Key('expenses_list_screen')), // First tab: Expenses list
              StatisticScreen(key: const Key('statistic_screen')), // Second tab: Statistics
            ],
          ),
        );
      },
    );
  }

  // Displays the category selection dialog when adding a new expense
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectCategoryDialog(key: const Key('select_category_dialog'));
      },
    );
  }
}
