import 'package:get/get.dart';
import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:pineapple_finance/data/models/stock_model.dart';

class StockController extends GetxController {
  final stocks = <StockModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final all = await DatabaseHelper.instance.getAllStocks();
    stocks.assignAll(all);
  }

  Future<void> add(String name, int quantity) async {
    final stock = StockModel(
      name: name,
      quantity: quantity,
      addedDate: DateTime.now(),
    );
    await DatabaseHelper.instance.createStock(stock);
    await load();
    Get.snackbar('Added', 'Stock item added');
  }

  Future<void> edit(StockModel existing, String name, int quantity) async {
    final updated = StockModel(
      id: existing.id,
      name: name,
      quantity: quantity,
      addedDate: existing.addedDate,
    );
    await DatabaseHelper.instance.updateStock(updated);
    await load();
    Get.snackbar('Updated', 'Stock item updated');
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteStock(id);
    await load();
    Get.snackbar('Deleted', 'Stock item deleted');
  }
}
