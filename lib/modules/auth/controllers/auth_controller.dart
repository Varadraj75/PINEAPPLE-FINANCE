import 'package:get/get.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';
import 'package:pineapple_finance/routes/app_routes.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final isLoading = false.obs;
  final showResetOption = false.obs;

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    final user = await AuthService.instance.login(
      email.value.trim(),
      password.value,
    );
    isLoading.value = false;

    if (user != null) {
      Get.offAllNamed(AppRoutes.dashboard);
      return;
    }

    final emailExists =
        await AuthService.instance.checkEmailExists(email.value.trim());

    if (emailExists) {
      showResetOption.value = true;
      Get.snackbar(
        'Error',
        'Incorrect password. You can reset it below.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      showResetOption.value = false;
      Get.defaultDialog(
        title: 'Login Failed',
        middleText:
            'Invalid email or password. Please check your credentials or register a new account.',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
    }
  }

  Future<void> resetPassword(String newPassword) async {
    if (newPassword.trim().isEmpty) return;

    final success = await AuthService.instance.resetPassword(
      email.value.trim(),
      newPassword,
    );

    Get.snackbar(
      success ? 'Success' : 'Error',
      success ? 'Password reset successfully! Please login.' : 'Failed to reset password.',
      snackPosition: SnackPosition.BOTTOM,
    );

    if (success) showResetOption.value = false;
  }

  Future<void> register() async {
    if (name.value.isEmpty || email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    final success = await AuthService.instance.register(
      name.value.trim(),
      email.value.trim(),
      password.value,
    );
    isLoading.value = false;

    if (success) {
      final user = await AuthService.instance.login(
        email.value.trim(),
        password.value,
      );
      if (user != null) Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.defaultDialog(
        title: 'Email Already Exists',
        middleText: 'This email is already registered. Would you like to login instead?',
        textCancel: 'Cancel',
        textConfirm: 'Go to Login',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    }
  }

  void clear() {
    email.value = '';
    password.value = '';
    name.value = '';
    isLoading.value = false;
    showResetOption.value = false;
  }
}
