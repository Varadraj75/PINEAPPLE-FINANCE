import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<TransactionModel> transactions = [];
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  Map<String, double> categoryExpenses = {};
  Map<String, double> categoryIncome = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allTransactions = await DatabaseHelper.instance.getAllTransactions();
    final income = await DatabaseHelper.instance.getTotalIncome();
    final expense = await DatabaseHelper.instance.getTotalExpense();

    Map<String, double> expenseMap = {};
    Map<String, double> incomeMap = {};

    for (var transaction in allTransactions) {
      if (transaction.type == 'expense') {
        expenseMap[transaction.category] =
            (expenseMap[transaction.category] ?? 0) + transaction.amount;
      } else {
        incomeMap[transaction.category] =
            (incomeMap[transaction.category] ?? 0) + transaction.amount;
      }
    }

    setState(() {
      transactions = allTransactions;
      totalIncome = income;
      totalExpense = expense;
      categoryExpenses = expenseMap;
      categoryIncome = incomeMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Income',
                    '₹${totalIncome.toStringAsFixed(2)}',
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Expense',
                    '₹${totalExpense.toStringAsFixed(2)}',
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSummaryCard(
              'Net Balance',
              '₹${(totalIncome - totalExpense).toStringAsFixed(2)}',
              totalIncome > totalExpense ? Colors.green : Colors.red,
              Icons.account_balance_wallet,
            ),

            const SizedBox(height: 24),

            // Income vs Expense Chart
            const Text(
              'Income vs Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: totalIncome == 0 && totalExpense == 0
                  ? const Center(child: Text('No data available'))
                  : PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: totalIncome,
                            title: 'Income\n₹${totalIncome.toStringAsFixed(0)}',
                            color: Colors.green,
                            radius: 70,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: totalExpense,
                            title: 'Expense\n₹${totalExpense.toStringAsFixed(0)}',
                            color: Colors.red,
                            radius: 70,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 35,
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Expense by Category
            if (categoryExpenses.isNotEmpty) ...[
              const Text(
                'Expenses by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...categoryExpenses.entries.map((entry) {
                final percentage = (entry.value / totalExpense * 100);
                return _buildCategoryBar(
                  entry.key,
                  entry.value,
                  percentage,
                  Colors.red,
                );
              }),
            ],

            const SizedBox(height: 24),

            // Income by Category
            if (categoryIncome.isNotEmpty) ...[
              const Text(
                'Income by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...categoryIncome.entries.map((entry) {
                final percentage = (entry.value / totalIncome * 100);
                return _buildCategoryBar(
                  entry.key,
                  entry.value,
                  percentage,
                  Colors.green,
                );
              }),
            ],

            const SizedBox(height: 24),

            // Transaction Count
            _buildInfoCard(
              'Total Transactions',
              transactions.length.toString(),
              Icons.receipt_long,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(
      String category, double amount, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '₹${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.orange, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
