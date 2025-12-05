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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'salary':
        return Icons.work;
      case 'business':
        return Icons.business_center;
      case 'investment':
        return Icons.trending_up;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'bills':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.type == 'income' ? incomeCategories : expenseCategories;
    final isIncome = widget.type == 'income';
    final headerColor = isIncome ? Colors.green : Colors.red;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colored Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isIncome
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.red.shade400, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isIncome ? Icons.add_circle : Icons.remove_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add ${isIncome ? 'Income' : 'Expense'}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Field
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        hintText: 'e.g., ${isIncome ? 'Monthly Salary' : 'Groceries'}',
                        prefixIcon: Icon(Icons.title, color: headerColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount Field
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount *',
                        hintText: '0.00',
                        prefixIcon: Icon(Icons.currency_rupee, color: headerColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(
                          _getCategoryIcon(selectedCategory),
                          color: headerColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerColor, width: 2),
                        ),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Icon(_getCategoryIcon(category), size: 20),
                              const SizedBox(width: 8),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Add notes...',
                        prefixIcon: Icon(Icons.notes, color: headerColor),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: headerColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _addTransaction,
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
