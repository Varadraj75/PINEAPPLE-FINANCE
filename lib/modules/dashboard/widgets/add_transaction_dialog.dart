import 'package:flutter/material.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';

class AddTransactionDialog extends StatefulWidget {
  final String type;
  final VoidCallback onTransactionAdded;

  const AddTransactionDialog({
    super.key,
    required this.type,
    required this.onTransactionAdded,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Other';

  final List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Other'
  ];
  final List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.type == 'income'
        ? incomeCategories.first
        : expenseCategories.first;
  }

  void _addTransaction() async {
    if (titleController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    final transaction = TransactionModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      type: widget.type,
      category: selectedCategory,
      date: DateTime.now(),
      description: descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
    );

    await DatabaseHelper.instance.createTransaction(transaction);
    widget.onTransactionAdded();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${widget.type == 'income' ? 'Income' : 'Expense'} added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.type == 'income' ? incomeCategories : expenseCategories;

    return AlertDialog(
      title: Text('Add ${widget.type == 'income' ? 'Income' : 'Expense'}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount *',
                border: OutlineInputBorder(),
                prefixText: '₹',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
          ),
          onPressed: _addTransaction,
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
