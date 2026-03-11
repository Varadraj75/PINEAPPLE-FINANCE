import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';
import 'package:pineapple_finance/modules/transactions/controllers/transactions_controller.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TransactionsController());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _filterChip(c, 'All', 'all'),
              const SizedBox(width: 8),
              _filterChip(c, 'Income', 'income'),
              const SizedBox(width: 8),
              _filterChip(c, 'Expense', 'expense'),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final items = c.filtered;
            if (items.isEmpty) {
              return const Center(child: Text('No transactions found'));
            }
            return RefreshIndicator(
              onRefresh: c.load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) => _transactionCard(c, items[index]),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _filterChip(TransactionsController c, String label, String value) {
    return Obx(() {
      final selected = c.filterType.value == value;
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => c.setFilter(value),
        selectedColor: AppColors.orange,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      );
    });
  }

  Widget _transactionCard(TransactionsController c, TransactionModel transaction) {
    final isIncome = transaction.type == 'income';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isIncome ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.category),
            Text(
              DateFormat('MMM dd, yyyy - hh:mm a').format(transaction.date),
              style: const TextStyle(fontSize: 12),
            ),
            if (transaction.description != null)
              Text(
                transaction.description!,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _confirmDelete(c, transaction),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _confirmDelete(TransactionsController c, TransactionModel transaction) {
    Get.defaultDialog(
      title: 'Delete Transaction',
      middleText: 'Are you sure you want to delete this transaction?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        c.delete(transaction.id!);
      },
    );
  }
}
