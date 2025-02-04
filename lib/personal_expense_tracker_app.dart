import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_Screen.dart';

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
    );
  }
}
