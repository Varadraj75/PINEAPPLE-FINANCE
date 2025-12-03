import 'package:flutter/material.dart';
import 'modules/intro/screens/intro_screen.dart';
import 'modules/dashboard/screens/dashboard_screen.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(const PineappleApp());
}

class PineappleApp extends StatelessWidget {
  const PineappleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pineapple Finance",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.yellow,
      ),
      home: FutureBuilder<bool>(
        future: AuthService.instance.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (snapshot.data == true) {
            return const DashboardScreen();
          }
          
          return const IntroScreen();
        },
      ),
    );
  }
}
