import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/modules/auth/controllers/auth_controller.dart';
import 'package:pineapple_finance/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailField = TextEditingController();
    final passField = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailField,
              onChanged: (v) => controller.email.value = v,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passField,
              obscureText: true,
              onChanged: (v) => controller.password.value = v,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                )),
            Obx(() {
              if (!controller.showResetOption.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: TextButton(
                    onPressed: () => _showResetDialog(controller),
                    child: const Text(
                      "Forgot Password? Reset Here",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: AppColors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(AuthController controller) {
    final newPassField = TextEditingController();
    Get.defaultDialog(
      title: 'Reset Password',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your new password below:'),
          const SizedBox(height: 10),
          TextField(
            controller: newPassField,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Reset',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.orange,
      onConfirm: () {
        Get.back();
        controller.resetPassword(newPassField.text);
      },
    );
  }
}
