import 'package:get/get.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';

class AnalyticsController extends GetxController {
  final transactions = <TransactionModel>[].obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final categoryExpenses = <String, double>{}.obs;
  final categoryIncome = <String, double>{}.obs;

  double get netBalance => totalIncome.value - totalExpense.value;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final all = await DatabaseHelper.instance.getAllTransactions();
    final income = await DatabaseHelper.instance.getTotalIncome();
    final expense = await DatabaseHelper.instance.getTotalExpense();

    final expenseMap = <String, double>{};
    final incomeMap = <String, double>{};
    for (final t in all) {
      if (t.type == 'expense') {
        expenseMap[t.category] = (expenseMap[t.category] ?? 0) + t.amount;
      } else {
        incomeMap[t.category] = (incomeMap[t.category] ?? 0) + t.amount;
      }
    }

    transactions.assignAll(all);
    totalIncome.value = income;
    totalExpense.value = expense;
    categoryExpenses.assignAll(expenseMap);
    categoryIncome.assignAll(incomeMap);
  }
}
