import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pineapple_finance/core/theme/app_colors.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';
import 'package:pineapple_finance/modules/profile/controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.yellow,
                child: Text(
                  c.userName.value.isNotEmpty ? c.userName.value[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Obx(() => Text(
                c.userName.value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 8),
          Obx(() => Text(
                c.userEmail.value,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              )),
          const SizedBox(height: 32),
          _option(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Pineapple Finance',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.star, size: 48, color: AppColors.orange),
              children: [const Text('Simple finance management for small businesses')],
            ),
          ),
          _option(
            icon: Icons.security,
            title: 'Security',
            subtitle: 'Change your password',
            onTap: () => _showChangePasswordDialog(c),
          ),
          _option(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => Get.snackbar('Info', 'Coming soon!'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _confirmLogout(c),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _option({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.yellow.withValues(alpha: 0.3),
          child: Icon(icon, color: AppColors.orange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showChangePasswordDialog(ProfileController c) {
    final currentPassField = TextEditingController();
    final newPassField = TextEditingController();
    final confirmPassField = TextEditingController();

    Get.defaultDialog(
      title: 'Change Password',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassField,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Current Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassField,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'New Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassField,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Confirm New Password', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      textCancel: 'Cancel',
      textConfirm: 'Change',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.orange,
      onConfirm: () async {
        if (newPassField.text.isEmpty || currentPassField.text.isEmpty) {
          Get.snackbar('Error', 'Please fill all fields');
          return;
        }
        if (newPassField.text != confirmPassField.text) {
          Get.snackbar('Error', 'Passwords do not match');
          return;
        }
        // Current password is validated here before resetting to prevent unauthorised changes.
        final email = c.userEmail.value;
        final valid = await AuthService.instance.login(email, currentPassField.text);
        if (valid == null) {
          Get.snackbar('Error', 'Current password is incorrect');
          return;
        }
        await AuthService.instance.resetPassword(email, newPassField.text);
        Get.back();
        Get.snackbar('Success', 'Password changed successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
      },
    );
  }

  void _confirmLogout(ProfileController c) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        c.logout();
      },
    );
  }
}
