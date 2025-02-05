import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';

class PersonalExpenseTrackerApp extends StatelessWidget {
  const PersonalExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expense Tracker',
        theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false);
  }
}
