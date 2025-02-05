import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_category.dart';
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart';
import 'package:personal_expense_tracker/screens/statistic_screen.dart';

import '../constants.dart';
import '../models/expense_categories.dart';
import 'new_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PageController _myPage = PageController();
  int _currentIndex = 0;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expense Tracker'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kButtonColor,
        shape: const CircleBorder(),
        onPressed: () async {
          await _showMyDialog();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      //floatingActionButton: buildSpeedDial(context),
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
                    color: _currentIndex == 0 ? kThemeColor : Colors.grey),
                onPressed: () {
                  setState(() {
                    _myPage.jumpToPage(0);
                    _currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart,
                    color: _currentIndex == 1 ? kThemeColor : Colors.grey),
                onPressed: () {
                  setState(() {
                    _myPage.jumpToPage(1);
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ExpensesListScreen(),
          StatisticScreen(),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Category'),
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
            builder: (context) => NewExpenseScreen(category: category.title),
          ),
        );
      },
    );
  }
}
