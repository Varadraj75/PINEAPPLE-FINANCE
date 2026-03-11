import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';
import 'package:pineapple_finance/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:pineapple_finance/modules/dashboard/widgets/add_transaction_dialog.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../stock/screens/stock_screen.dart';
import '../../transactions/screens/transactions_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DashboardController());

    return Obx(() => Scaffold(
          appBar: c.selectedIndex.value == 0
              ? null
              : AppBar(
                  title: Text(c.currentTitle),
                  backgroundColor: AppColors.yellow,
                  automaticallyImplyLeading: false,
                ),
          body: _buildBody(c),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: c.selectedIndex.value,
            onTap: c.selectTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.orange,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
              BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
              BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ));
  }

  Widget _buildBody(DashboardController c) {
    switch (c.selectedIndex.value) {
      case 1:
        return const TransactionsScreen();
      case 2:
        return const StockScreen();
      case 3:
        return const AnalyticsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHome(c);
    }
  }

  Widget _buildHome(DashboardController c) {
    return RefreshIndicator(
      onRefresh: c.loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Hello, ${c.userName.value}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            _buildBalanceCard(c),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Income',
                    Icons.add_circle,
                    Colors.green,
                    () => _showAddTransactionDialog('income', c),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Add Expense',
                    Icons.remove_circle,
                    Colors.red,
                    () => _showAddTransactionDialog('expense', c),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => c.selectTab(1),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => c.recentTransactions.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.recentTransactions.length,
                    itemBuilder: (_, index) =>
                        _buildTransactionTile(c.recentTransactions[index]),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(DashboardController c) {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.orange, AppColors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${c.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Income', style: TextStyle(color: Colors.white70)),
                      Text(
                        '₹${c.totalIncome.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expense', style: TextStyle(color: Colors.white70)),
                      Text(
                        '₹${c.totalExpense.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel transaction) {
    final isIncome = transaction.type == 'income';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isIncome ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
        trailing: Text(
          '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(String type, DashboardController c) {
    Get.dialog(
      AddTransactionDialog(
        type: type,
        onTransactionAdded: c.loadData,
      ),
    );
  }
}
