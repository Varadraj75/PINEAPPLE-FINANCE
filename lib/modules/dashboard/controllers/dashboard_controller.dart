import 'package:get/get.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final recentTransactions = <TransactionModel>[].obs;
  final userName = 'User'.obs;

  double get balance => totalIncome.value - totalExpense.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final income = await DatabaseHelper.instance.getTotalIncome();
    final expense = await DatabaseHelper.instance.getTotalExpense();
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    final name = await AuthService.instance.getUserName();

    totalIncome.value = income;
    totalExpense.value = expense;
    recentTransactions.assignAll(transactions.take(5));
    userName.value = name ?? 'User';
  }

  void selectTab(int index) => selectedIndex.value = index;

  String get currentTitle {
    switch (selectedIndex.value) {
      case 1:
        return 'Transactions';
      case 2:
        return 'Stock';
      case 3:
        return 'Analytics';
      case 4:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }
}
