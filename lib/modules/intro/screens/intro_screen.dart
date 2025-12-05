import 'package:flutter/material.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';

import '../../auth/screens/login_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 100, color: AppColors.orange),

              const SizedBox(height: 20),

              const Text(
                "Pineapple Finance",
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Simple finance for small businesses",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Get Started",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
