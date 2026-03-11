import 'package:get/get.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/transaction_model.dart';
import 'package:pineapple_finance/modules/analytics/controllers/analytics_controller.dart';

class TransactionsController extends GetxController {
  final transactions = <TransactionModel>[].obs;
  final filterType = 'all'.obs;

  List<TransactionModel> get filtered {
    if (filterType.value == 'all') return transactions;
    return transactions.where((t) => t.type == filterType.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final all = await DatabaseHelper.instance.getAllTransactions();
    transactions.assignAll(all);
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await load();
    if (Get.isRegistered<AnalyticsController>()) {
      Get.find<AnalyticsController>().load();
    }
    Get.snackbar('Deleted', 'Transaction deleted');
  }

  void setFilter(String type) => filterType.value = type;
}
