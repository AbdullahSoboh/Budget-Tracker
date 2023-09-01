//Abdullah Soboh 2023
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
  final String category;

  Expense({required this.name, required this.amount, required this.category});
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<Expense> expenses = [
    Expense(name: 'Groceries', amount: 50.0, category: 'Food'),
    Expense(name: 'Transport', amount: 20.0, category: 'Transport'),
    Expense(name: 'Entertainment', amount: 30.0, category: 'Entertainment'),
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
          // Navigate to the add expense screen (I'll need to create this screen)
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen()));
        },
      ),
    );
  }
}
 
class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}  //Add expense
    
class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // Your state properties
  String? expenseName;
  double? expenseAmount;
  String? selectedCategory;
  final List<String> categories = ['Food', 'Transport', 'Entertainment', 'Others']; // Example categories

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
            // Expense Name Text Field
            TextFormField(
              decoration: InputDecoration(labelText: 'Expense Name'),
              onChanged: (value) {
                setState(() {
                  expenseName = value;
                });
              },
            ),
            // Expense Amount Text Field
            TextFormField(
              decoration: InputDecoration(labelText: 'Expense Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  expenseAmount = double.tryParse(value);
                });
              },
            ),
            // Category Dropdown
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
            // Submit Button
            ElevatedButton(
              onPressed: () {
                //
                if (expenseAmount != null && expenseName != null && selectedCategory != null) {
                  Expense newExpense = Expense(name: expenseName!, amount: expenseAmount!, category: selectedCategory!);

                  //expenses.add(newExpense);
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



