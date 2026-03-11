import 'package:get/get.dart';
import 'package:pineapple_finance/data/services/auth_service.dart';
import 'package:pineapple_finance/routes/app_routes.dart';

class ProfileController extends GetxController {
  final userName = 'User'.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    userName.value = await AuthService.instance.getUserName() ?? 'User';
    userEmail.value = await AuthService.instance.getUserEmail() ?? '';
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    Get.offAllNamed(AppRoutes.intro);
  }
}
