import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/screens/expenses_list_screen.dart';
import 'package:personal_expense_tracker/screens/statistic_screen.dart';

import '../constants.dart';
import 'category_selection_screen.dart';

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CategorySelectionScreen()),
          );
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
}
