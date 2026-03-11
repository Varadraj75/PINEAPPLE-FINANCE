import 'package:get/get.dart';
import 'package:pineapple_finance/modules/auth/controllers/auth_controller.dart';
import 'package:pineapple_finance/modules/auth/screens/login_screen.dart';
import 'package:pineapple_finance/modules/auth/screens/register_screen.dart';
import 'package:pineapple_finance/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pineapple_finance/modules/intro/screens/intro_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.intro,
      page: () => const IntroScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthController())),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      // AuthController is shared across login and register; only create if not already alive.
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) {
          Get.lazyPut(() => AuthController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
    ),
  ];
}
