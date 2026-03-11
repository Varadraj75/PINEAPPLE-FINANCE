import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/modules/analytics/controllers/analytics_controller.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AnalyticsController());

    return Obx(() => RefreshIndicator(
          onRefresh: c.load,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        'Total Income',
                        '₹${c.totalIncome.value.toStringAsFixed(2)}',
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Total Expense',
                        '₹${c.totalExpense.value.toStringAsFixed(2)}',
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _summaryCard(
                  'Net Balance',
                  '₹${c.netBalance.toStringAsFixed(2)}',
                  c.netBalance >= 0 ? Colors.green : Colors.red,
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 24),
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
                  child: c.totalIncome.value == 0 && c.totalExpense.value == 0
                      ? const Center(child: Text('No data available'))
                      : PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: c.totalIncome.value,
                                title: 'Income\n₹${c.totalIncome.value.toStringAsFixed(0)}',
                                color: Colors.green,
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: c.totalExpense.value,
                                title: 'Expense\n₹${c.totalExpense.value.toStringAsFixed(0)}',
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
                if (c.categoryExpenses.isNotEmpty) ...[
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...c.categoryExpenses.entries.map((e) => _categoryBar(
                        e.key,
                        e.value,
                        e.value / c.totalExpense.value * 100,
                        Colors.red,
                      )),
                ],
                const SizedBox(height: 24),
                if (c.categoryIncome.isNotEmpty) ...[
                  const Text(
                    'Income by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...c.categoryIncome.entries.map((e) => _categoryBar(
                        e.key,
                        e.value,
                        e.value / c.totalIncome.value * 100,
                        Colors.green,
                      )),
                ],
                const SizedBox(height: 24),
                _infoCard(
                  'Total Transactions',
                  c.transactions.length.toString(),
                  Icons.receipt_long,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _summaryCard(String title, String amount, Color color, IconData icon) {
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
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(amount,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _categoryBar(String category, double amount, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '₹${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

  Widget _infoCard(String title, String value, IconData icon) {
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
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}
