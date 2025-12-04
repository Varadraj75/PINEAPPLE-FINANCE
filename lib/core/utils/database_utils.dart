import 'package:pineapple_finance/data/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseUtils {
  // Clear all data and reset the app
  static Future<void> clearAllData() async {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Close and delete database
    final db = await DatabaseHelper.instance.database;
    await db.close();
    
    // Note: To fully reset, user should restart the app
  }
}
