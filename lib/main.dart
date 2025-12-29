import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/company_list_screen.dart';
import 'screens/feedback_screen.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Company Directory',
        initialRoute:
        authController.isLoggedIn.value ? '/companies' : '/login',
        getPages: [
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/signup', page: () => SignUpScreen()),
          GetPage(name: '/companies', page: () => const CompanyListScreen()),
          GetPage(name: '/feedback', page: () => FeedbackScreen()),
        ],
      );
    });
  }
}
