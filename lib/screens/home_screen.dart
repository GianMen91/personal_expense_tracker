import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/constants.dart';
import 'package:personal_expense_tracker/models/expense_category.dart';
import 'package:personal_expense_tracker/models/expense_categories.dart';
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart';
import 'package:personal_expense_tracker/screens/statistic_screen.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';
import 'new_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController _myPage = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Personal Expense Tracker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: kButtonColor,
            shape: const CircleBorder(),
            onPressed: () async {
              await _showMyDialog(context);
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          bottomNavigationBar: BottomAppBar(
            color: kBottomNavigationBarColor,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home,
                        color: state.currentIndex == 0 ? kThemeColor : Colors.grey),
                    onPressed: () {
                      context.read<NavigationBloc>().add(ChangePage(0));
                      _myPage.jumpToPage(0);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.bar_chart,
                        color: state.currentIndex == 1 ? kThemeColor : Colors.grey),
                    onPressed: () {
                      context.read<NavigationBloc>().add(ChangePage(1));
                      _myPage.jumpToPage(1);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            controller: _myPage,
            onPageChanged: (int index) {
              context.read<NavigationBloc>().add(ChangePage(index));
            },
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              ExpensesListScreen(),
              StatisticScreen(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Category'),
          content: SizedBox(
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              itemCount: ExpenseCategories.categories.length,
              itemBuilder: (context, index) {
                final category = ExpenseCategories.categories[index];
                return _buildCategoryItem(context, category);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewExpenseScreen(category: category),
          ),
        );
      },
    );
  }
}
