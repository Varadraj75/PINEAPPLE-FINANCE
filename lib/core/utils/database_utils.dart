import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseUtils {
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final db = await DatabaseHelper.instance.database;
    await db.close();
  }
}
