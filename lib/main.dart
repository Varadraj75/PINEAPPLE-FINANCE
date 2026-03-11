import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';
import 'package:pineapple_finance/routes/app_pages.dart';
import 'package:pineapple_finance/routes/app_routes.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final loggedIn = await AuthService.instance.isLoggedIn();

  runApp(PineappleApp(initialRoute: loggedIn ? AppRoutes.dashboard : AppRoutes.intro));
}

class PineappleApp extends StatelessWidget {
  final String initialRoute;
  const PineappleApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pineapple Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.yellow,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
