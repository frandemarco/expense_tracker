import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expenses.dart';
import 'package:expense_tracker/models/chart.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});
  
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx)=> NewExpense(onAddExpense: _addExpense),
      );
  }
   void _addExpense(Expense expense){
    setState(() {
      _resgisteredExpenses.add(expense);
    });
  }
  void _removeExpense(Expense expense){
    final expenseIndex=_resgisteredExpenses.indexOf(expense);
    setState(() {
      _resgisteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: (){
          setState(() {
            _resgisteredExpenses.insert(expenseIndex, expense);
          });
        }),
      )
      );
  }
  final List<Expense> _resgisteredExpenses =[
    Expense(
      title: 'cheeseburger', 
      amount: 12.99, 
      date: DateTime.now(), 
      category: Category.food),];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent= const Center(
      child: Text('No Expenses yet. Press + to add an Expense'),
    );
    if(_resgisteredExpenses.isNotEmpty){
      mainContent=Expanded(
          child: ExpensesList(expenses: _resgisteredExpenses, onRemoveExpense: _removeExpense,),
          );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add) )],
      ),
      body: width < 600 
      ? Column(
        children: [
          Chart(expenses: _resgisteredExpenses ),
          Expanded(
            child: mainContent,
          ),
        ],
      ) : Row(children: [
        Chart(expenses: _resgisteredExpenses ),
        Expanded(
            child: mainContent,
        )
      ]),

    );
  }
}