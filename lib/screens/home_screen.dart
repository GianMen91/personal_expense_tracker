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
              key: Key('home_title_app_bar'),
              'Personal Expense Tracker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            key: const Key('add_expense_button'),
            backgroundColor: kButtonColor,
            shape: const CircleBorder(),
            onPressed: () async {
              await _showMyDialog(context);
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          bottomNavigationBar:
              BottomMenu(myPage: _myPage, currentIndex: state.currentPage,key: const Key('bottom_menu'),),
          body: PageView(
            controller: _myPage,
            onPageChanged: (int index) {
              context.read<NavigationBloc>().add(ChangePage(index));
            },
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              ExpensesListScreen(key: const Key('expenses_list_screen')),
              StatisticScreen(key: const Key('statistic_screen')),
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
        return SelectCategoryDialog(key: const Key('select_category_dialog'));
      },
    );
  }
}

