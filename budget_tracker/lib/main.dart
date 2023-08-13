import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class Expense {
  final String name;
  final double amount;

  Expense({required this.name, required this.amount});
}

class HomeScreen extends StatelessWidget {
  final List<Expense> expenses = [
    Expense(name: 'Groceries', amount: 50.0),
    Expense(name: 'Transport', amount: 20.0),
    Expense(name: 'Entertainment', amount: 30.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(expenses[index].name),
            trailing: Text('\$${expenses[index].amount.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to the add expense screen (you'll need to create this screen)
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen()));
        },
      ),
    );
  }
}
