import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/models/stock_model.dart';
import 'package:pineapple_finance/modules/stock/controllers/stock_controller.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StockController());

    return Scaffold(
      body: Obx(() => c.stocks.isEmpty
          ? const Center(child: Text('No stock items yet'))
          : RefreshIndicator(
              onRefresh: c.load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: c.stocks.length,
                itemBuilder: (_, index) => _stockCard(c, c.stocks[index]),
              ),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(c),
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _stockCard(StockController c, StockModel stock) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.yellow,
          child: Icon(Icons.inventory_2, color: Colors.white),
        ),
        title: Text(stock.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Added: ${DateFormat('MMM dd, yyyy').format(stock.addedDate)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Qty: ${stock.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditDialog(c, stock);
                } else {
                  _confirmDelete(c, stock);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(StockController c) {
    final nameField = TextEditingController();
    final qtyField = TextEditingController();

    Get.defaultDialog(
      title: 'Add Stock Item',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameField,
            decoration: const InputDecoration(labelText: 'Item Name *', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: qtyField,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity *', border: OutlineInputBorder()),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Add',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.orange,
      onConfirm: () {
        if (nameField.text.isEmpty || qtyField.text.isEmpty) {
          Get.snackbar('Error', 'Please fill all fields');
          return;
        }
        Get.back();
        c.add(nameField.text, int.parse(qtyField.text));
      },
    );
  }

  void _showEditDialog(StockController c, StockModel stock) {
    final nameField = TextEditingController(text: stock.name);
    final qtyField = TextEditingController(text: stock.quantity.toString());

    Get.defaultDialog(
      title: 'Edit Stock Item',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameField,
            decoration: const InputDecoration(labelText: 'Item Name *', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: qtyField,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity *', border: OutlineInputBorder()),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Update',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.orange,
      onConfirm: () {
        if (nameField.text.isEmpty || qtyField.text.isEmpty) {
          Get.snackbar('Error', 'Please fill all fields');
          return;
        }
        Get.back();
        c.edit(stock, nameField.text, int.parse(qtyField.text));
      },
    );
  }

  void _confirmDelete(StockController c, StockModel stock) {
    Get.defaultDialog(
      title: 'Delete Stock Item',
      middleText: 'Are you sure you want to delete "${stock.name}"?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        c.delete(stock.id!);
      },
    );
  }
}
