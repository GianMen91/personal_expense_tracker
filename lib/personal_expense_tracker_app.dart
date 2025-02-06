import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';

class PersonalExpenseTrackerApp extends StatelessWidget {
  const PersonalExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expense Tracker',
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false);
  }
}
