import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';
import 'package:pineapple_finance/modules/analytics/controllers/analytics_controller.dart';

class AddTransactionDialog extends StatelessWidget {
  final String type;
  final VoidCallback onTransactionAdded;

  const AddTransactionDialog({
    super.key,
    required this.type,
    required this.onTransactionAdded,
  });

  static const _incomeCategories = ['Salary', 'Business', 'Investment', 'Other'];
  static const _expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Other'];

  @override
  Widget build(BuildContext context) {
    final titleField = TextEditingController();
    final amountField = TextEditingController();
    final descriptionField = TextEditingController();
    final categories = type == 'income' ? _incomeCategories : _expenseCategories;
    final selectedCategory = categories.first.obs;
    final isIncome = type == 'income';
    final headerColor = isIncome ? Colors.green : Colors.red;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isIncome, headerColor),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildField(
                      titleField,
                      'Title *',
                      'e.g., ${isIncome ? 'Monthly Salary' : 'Groceries'}',
                      Icons.title,
                      headerColor,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      amountField,
                      'Amount *',
                      '0.00',
                      Icons.currency_rupee,
                      headerColor,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<String>(
                          initialValue: selectedCategory.value,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(_categoryIcon(selectedCategory.value), color: headerColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: headerColor, width: 2),
                            ),
                          ),
                          items: categories
                              .map((cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Row(
                                      children: [
                                        Icon(_categoryIcon(cat), size: 20),
                                        const SizedBox(width: 8),
                                        Text(cat),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) => selectedCategory.value = v!,
                        )),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionField,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Add notes...',
                        prefixIcon: Icon(Icons.notes, color: headerColor),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: headerColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: () => _submit(
                      titleField,
                      amountField,
                      descriptionField,
                      selectedCategory.value,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Add',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildHeader(bool isIncome, Color color) {
    return Container(
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
          Icon(isIncome ? Icons.add_circle : Icons.remove_circle, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Text(
            'Add ${isIncome ? 'Income' : 'Expense'}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    Color color, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }

  void _submit(
    TextEditingController titleField,
    TextEditingController amountField,
    TextEditingController descriptionField,
    String category,
  ) async {
    if (titleField.text.isEmpty || amountField.text.isEmpty) {
      Get.snackbar('Error', 'Please fill required fields');
      return;
    }

    final transaction = TransactionModel(
      title: titleField.text,
      amount: double.parse(amountField.text),
      type: type,
      category: category,
      date: DateTime.now(),
      description: descriptionField.text.isEmpty ? null : descriptionField.text,
    );

    await DatabaseHelper.instance.createTransaction(transaction);
    onTransactionAdded();
    if (Get.isRegistered<AnalyticsController>()) {
      Get.find<AnalyticsController>().load();
    }
    Get.back();
    Get.snackbar('Success', '${type == 'income' ? 'Income' : 'Expense'} added successfully');
  }

  IconData _categoryIcon(String category) {
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
}
