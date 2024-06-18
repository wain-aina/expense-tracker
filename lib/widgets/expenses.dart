import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});

  @override
  State<Expenses> createState(){
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  final List<Expense>  _registeredExpenses = [];

  void _openAddOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: "Undo", 
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }
        ),
      ),
    );
  }
  

  @override
  Widget build(context){

    var width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No Expenses Found'),
    );

    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemove: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddOverlay, 
            icon: const Icon(
              Icons.add, 
              color: Colors.white,
            )
          )
        ]
      ),
      body: width < 600
      ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
            Expanded(
              child: mainContent
            ),
         ]
       ) 
      : Row(
          children: [
           Expanded(
            child: Chart(expenses: _registeredExpenses)
           ),
            Expanded(
              child: mainContent
            ),
            ],
          ),
    );
  }
}