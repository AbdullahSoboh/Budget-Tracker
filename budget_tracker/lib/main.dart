// Import the required Flutter packages.
import 'package:flutter/material.dart';

// Define a function that runs the main application.
void main() => runApp(MyApp());

// Define the MyApp widget as a StatelessWidget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp widget to set up the app's visual design.
    return MaterialApp(
      title: 'Budget Tracker',  // Set the title that appears above the app.
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Set the primary color scheme.
      ),
      home: HomeScreen(),  // Set the initial screen that will be displayed.
    );
  }
}

// Define a class to model an Expense.
class Expense {
  final String name;  // The name of the expense.
  final double amount;  // The amount of the expense.
  final String category;  // The category of the expense.

  // Constructor to initialize an Expense object.
  Expense({required this.name, required this.amount, required this.category});
}

// Define HomeScreen as a StatefulWidget to allow it to hold mutable state.
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Define _HomeScreenState as the mutable state for HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  // Initialize a list of Expense objects to hold expenses.
  List<Expense> expenses = [
    Expense(name: 'Groceries', amount: 50.0, category: 'Food'),
    Expense(name: 'Transport', amount: 20.0, category: 'Transport'),
    Expense(name: 'Entertainment', amount: 30.0, category: 'Entertainment'),
  ];

  // Define a function to update the expenses list.
  void _updateExpenses(Expense newExpense) {
    // Use setState to rebuild the widget with the updated expenses list.
    setState(() {
      expenses.add(newExpense);
    });
  }

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
                  child: Text(value),
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
                  Expense newExpense = Expense(name: expenseName!, amount: expenseAmount!, category: selectedCategory!);
                  widget.updateExpensesCallback(newExpense);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
