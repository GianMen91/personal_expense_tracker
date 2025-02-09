import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_tracker/constants.dart';
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart';
import 'package:personal_expense_tracker/screens/statistic_screen.dart';
import 'package:personal_expense_tracker/widgets/select_category_dialog.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';
import '../widgets/bottom_menu.dart';

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
              key: Key('appTitle'),
              'Personal Expense Tracker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            key: const Key('addExpenseButton'),
            backgroundColor: kButtonColor,
            shape: const CircleBorder(),
            onPressed: () async {
              await _showMyDialog(context);
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          bottomNavigationBar:
              BottomMenu(myPage: _myPage, currentIndex: state.currentIndex,key: const Key('bottomMenu'),),
          body: PageView(
            controller: _myPage,
            onPageChanged: (int index) {
              context.read<NavigationBloc>().add(ChangePage(index));
            },
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              ExpensesListScreen(key: const Key('expensesListScreen')),
              StatisticScreen(key: const Key('statisticScreen')),
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
        return SelectCategoryDialog(key: const Key('selectCategoryDialog'));
      },
    );
  }
}

