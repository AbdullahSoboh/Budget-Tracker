import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

typedef UpdateExpensesCallback = void Function(Expense newExpense);

void main() => runApp(MyApp()); // Beginning of App

class MyApp extends StatelessWidget { //Creating home screen
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
  final String name; //Name of Expense
  final double amount; //Amount Spent
  final String category;

  Expense({required this.name, required this.amount, required this.category});
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();//Homescreen
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [
    Expense(name: 'Groceries', amount: 50.0, category: 'Food'),
    Expense(name: 'Transport', amount: 20.0, category: 'Transport'),
    Expense(name: 'Entertainment', amount: 30.0, category: 'Entertainment'),
  ]; // Expenses Categories Summarized.

  void _updateExpenses(Expense newExpense) {
    setState(() {
      expenses.add(newExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartScreen(expenses: expenses),
                ),
              );
            },
          )
        ],
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(updateExpensesCallback: _updateExpenses),
            ),
          );
        },
      ),
    );
  }
}

class ChartScreen extends StatelessWidget {
  final List<Expense> expenses;

  ChartScreen({required this.expenses});

  Map<String, double> getExpenseData() {
    Map<String, double> expenseData = {};
    for (Expense expense in expenses) {
      expenseData[expense.category] = (expenseData[expense.category] ?? 0.0) + expense.amount;
    }
    return expenseData;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> expenseData = getExpenseData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Chart'),
      ),
      body: PieChart(
        PieChartData(
          sections: expenseData.entries.map(
            (entry) => PieChartSectionData(
              title: entry.key,
              value: entry.value,
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
          ).toList(),
        ),
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  final UpdateExpensesCallback updateExpensesCallback;

  AddExpenseScreen({required this.updateExpensesCallback});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? expenseName;
  double? expenseAmount;
  String? selectedCategory;
  final List<String> categories = ['Food', 'Transport', 'Entertainment', 'Others'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Expense Name'),
              onChanged: (value) {
                setState(() {
                  expenseName = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Expense Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  expenseAmount = double.tryParse(value);
                });
              },
            ),
            DropdownButton<String>(
              hint: Text('Select Category'),
              value: selectedCategory,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), //The dropdown item
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (expenseAmount != null && expenseName != null && selectedCategory != null) {
                  Expense newExpense = Expense(
                      name: expenseName!,
                      amount: expenseAmount!,
                      category: selectedCategory!);
                  widget.updateExpensesCallback(newExpense);
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Input'),
                        content: Text('All fields must be filled out appropriately to add an expense.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Submit'), //Submit button
            ),
          ],
        ),
      ),
    );
  }
} //Need to add the ability to input history of additions 
//Elaborate on location history of expenses.
